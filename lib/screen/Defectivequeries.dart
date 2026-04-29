import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DefectiveQueriesScreen extends StatefulWidget {
  const DefectiveQueriesScreen({super.key});

  @override
  State<DefectiveQueriesScreen> createState() =>
      _DefectiveQueriesScreenState();
}

class _DefectiveQueriesScreenState extends State<DefectiveQueriesScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _queries = [];
  bool _isLoading = true;

  // Filter: 'all' | 'pending' | 'resolved'
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _fetchQueries();
  }

  // ── Fetch all defective queries ──────────────────────────────────────────
  Future<void> _fetchQueries() async {
    setState(() => _isLoading = true);
    try {
      var query = _supabase
          .from('defective_queries')
          .select()
          .order('created_at', ascending: false);

      final data = await query;
      if (mounted) {
        setState(() {
          _queries = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Update status ────────────────────────────────────────────────────────
  Future<void> _updateStatus(String id, String newStatus) async {
    try {
      await _supabase
          .from('defective_queries')
          .update({'status': newStatus})
          .eq('id', id);
      _fetchQueries();
    } catch (e) {
      debugPrint("Status update error: $e");
    }
  }

  // ── Filtered list ────────────────────────────────────────────────────────
  List<Map<String, dynamic>> get _filteredQueries {
    if (_filter == 'all') return _queries;
    return _queries.where((q) => q['status'] == _filter).toList();
  }

  // ── Format date ──────────────────────────────────────────────────────────
  String _formatDate(String? iso) {
    if (iso == null) return '—';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '—';
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  // ── Status chip ──────────────────────────────────────────────────────────
  Widget _statusChip(String status) {
    final Color color;
    final IconData icon;
    switch (status) {
      case 'resolved':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'in_review':
        color = Colors.blue;
        icon = Icons.hourglass_empty;
        break;
      default:
        color = Colors.orange;
        icon = Icons.pending_outlined;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ── Main build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Defective Queries",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchQueries,
            tooltip: "Refresh",
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Filter chips ─────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
             child:SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 children: [
                   _FilterChip(
                     label: "All",
                     selected: _filter == 'all',
                     onTap: () => setState(() => _filter = 'all'),
                     count: _queries.length,
                   ),
                   const SizedBox(width: 8),
                   _FilterChip(
                     label: "Pending",
                     selected: _filter == 'pending',
                     onTap: () => setState(() => _filter = 'pending'),
                     color: Colors.orange,
                     count: _queries.where((q) => q['status'] == 'pending').length,
                   ),
                   const SizedBox(width: 8),
                   _FilterChip(
                     label: "In Review",
                     selected: _filter == 'in_review',
                     onTap: () => setState(() => _filter = 'in_review'),
                     color: Colors.blue,
                     count: _queries.where((q) => q['status'] == 'in_review').length,
                   ),
                   const SizedBox(width: 8),
                   _FilterChip(
                     label: "Resolved",
                     selected: _filter == 'resolved',
                     onTap: () => setState(() => _filter = 'resolved'),
                     color: Colors.green,
                     count: _queries.where((q) => q['status'] == 'resolved').length,
                   ),
                 ],
               ),
             )

),
          const Divider(height: 1),

          // ── List ─────────────────────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredQueries.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    "No ${_filter == 'all' ? '' : _filter} queries",
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredQueries.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final q = _filteredQueries[index];
                return _QueryCard(
                  query: q,
                  formatDate: _formatDate,
                  statusChip: _statusChip,
                  onUpdateStatus: (newStatus) =>
                      _updateStatus(q['id'].toString(), newStatus),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Query Card ───────────────────────────────────────────────────────────────
class _QueryCard extends StatelessWidget {
  final Map<String, dynamic> query;
  final String Function(String?) formatDate;
  final Widget Function(String) statusChip;
  final void Function(String) onUpdateStatus;

  const _QueryCard({
    required this.query,
    required this.formatDate,
    required this.statusChip,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = query['image_url'] as String?;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image (if available) ────────────────────────────────────
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 80,
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined,
                        color: Colors.grey),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row ─────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Order: ${query['order_number'] ?? '—'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    statusChip(query['status'] ?? 'pending'),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Details ────────────────────────────────────────
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: "Order Date",
                  value: formatDate(query['order_date']),
                ),
                const SizedBox(height: 6),
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  label: "Address",
                  value: query['address'] ?? '—',
                ),
                const SizedBox(height: 6),
                _DetailRow(
                  icon: Icons.phone_outlined,
                  label: "Phone",
                  value: query['phone'] ?? '—',
                ),

                if (query['description'] != null &&
                    (query['description'] as String).isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _DetailRow(
                    icon: Icons.description_outlined,
                    label: "Issue",
                    value: query['description'],
                  ),
                ],

                const SizedBox(height: 6),
                _DetailRow(
                  icon: Icons.access_time,
                  label: "Submitted",
                  value: formatDate(query['created_at']),
                ),

                const SizedBox(height: 14),

                // ── Action buttons ─────────────────────────────────
                Row(
                  children: [
                    if (query['status'] != 'in_review')
                      Expanded(
                        child: _ActionButton(
                          label: "Mark In Review",
                          color: Colors.blue,
                          onTap: () => onUpdateStatus('in_review'),
                        ),
                      ),
                    if (query['status'] != 'in_review')
                      const SizedBox(width: 8),
                    if (query['status'] != 'resolved')
                      Expanded(
                        child: _ActionButton(
                          label: "Mark Resolved",
                          color: Colors.green,
                          onTap: () => onUpdateStatus('resolved'),
                        ),
                      ),
                    if (query['status'] == 'resolved')
                      Expanded(
                        child: _ActionButton(
                          label: "Reopen",
                          color: Colors.orange,
                          onTap: () => onUpdateStatus('pending'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail row widget ────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

// ── Action button widget ─────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Filter chip widget ───────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;
  final int count;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = Colors.blueGrey,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "$label ($count)",
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
            fontWeight:
            selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}