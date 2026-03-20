import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';

class MultiPdfViewerScreen extends StatefulWidget {
  final String bookName;

  /// List of maps: [{"label": "Book 1", "asset": "assets/pdfs/...pdf"}, ...]
  final List<Map<String, String>> pdfs;

  /// Which PDF tab to open first (default 0)
  final int initialIndex;

  const MultiPdfViewerScreen({
    super.key,
    required this.bookName,
    required this.pdfs,
    this.initialIndex = 0,
  });

  @override
  State<MultiPdfViewerScreen> createState() => _MultiPdfViewerScreenState();
}

class _MultiPdfViewerScreenState extends State<MultiPdfViewerScreen> {
  int selectedIndex = 0;

  // Cache: index → local file path
  final Map<int, String> _cachedPaths = {};
  final Map<int, bool> _loading = {};
  final Map<int, String?> _errors = {};

  // Per-PDF page tracking
  final Map<int, int> _currentPage = {};
  final Map<int, int> _totalPages = {};
  final Map<int, PDFViewController?> _controllers = {};

  // ─────────────────────────────────────────────
  //  Init & Dispose
  // ─────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _secureScreen();                      // ← block screenshots on enter
    selectedIndex = widget.initialIndex;
    _loadPdf(selectedIndex);
  }

  @override
  void dispose() {
    _clearSecureScreen();                 // ← restore on exit
    _deleteCachedFiles();                 // ← delete temp PDFs on exit
    super.dispose();
  }

  // ─────────────────────────────────────────────
  //  Screenshot / Screen recording prevention
  // ─────────────────────────────────────────────

  /// Android: FLAG_SECURE blocks screenshots + screen recording
  Future<void> _secureScreen() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  /// Remove FLAG_SECURE when leaving the screen
  Future<void> _clearSecureScreen() async {
    if (Platform.isAndroid) {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  // ─────────────────────────────────────────────
  //  Temp file cleanup (prevents offline access)
  // ─────────────────────────────────────────────

  Future<void> _deleteCachedFiles() async {
    for (final path in _cachedPaths.values) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
  }

  // ─────────────────────────────────────────────
  //  PDF Loading
  // ─────────────────────────────────────────────

  Future<void> _loadPdf(int index) async {
    if (_cachedPaths.containsKey(index)) return;

    setState(() => _loading[index] = true);

    try {
      final assetPath = widget.pdfs[index]['asset']!;
      final bytes = await rootBundle.load(assetPath);
      final dir = await getTemporaryDirectory();
      final fileName = assetPath.split('/').last;
      final file = File('${dir.path}/${widget.bookName}_${index}_$fileName');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

      if (mounted) {
        setState(() {
          _cachedPaths[index] = file.path;
          _loading[index] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errors[index] = 'Could not load PDF.\n$e';
          _loading[index] = false;
        });
      }
    }
  }

  void _switchTab(int index) {
    setState(() => selectedIndex = index);
    _loadPdf(index);
  }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final total = _totalPages[selectedIndex] ?? 0;
    final current = _currentPage[selectedIndex] ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.bookName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        actions: [
          // 🔒 Lock icon shows screen is protected
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.lock_outline, color: Colors.grey, size: 18),
          ),
          if (total > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Text(
                  '${current + 1} / $total',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ── Security notice banner ──
          _buildSecurityBanner(),

          // ── Tab bar (only show if more than 1 PDF) ──
          if (widget.pdfs.length > 1) _buildTabBar(),

          // ── PDF viewer ──
          Expanded(child: _buildViewer()),

          // ── Page navigator ──
          if (total > 1) _buildPageNav(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Security Banner
  // ─────────────────────────────────────────────

  Widget _buildSecurityBanner() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF3CD),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, size: 14, color: Color(0xFF856404)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Preview only — Screenshots & downloads are disabled.',
              style: TextStyle(fontSize: 11, color: Color(0xFF856404)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Tab bar
  // ─────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: List.generate(widget.pdfs.length, (i) {
            final selected = i == selectedIndex;
            final label = widget.pdfs[i]['label'] ?? 'Book ${i + 1}';
            return GestureDetector(
              onTap: () => _switchTab(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF6A5AE0)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF6A5AE0)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey[700],
                    fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  PDF viewer body
  // ─────────────────────────────────────────────

  Widget _buildViewer() {
    final isLoading = _loading[selectedIndex] == true;
    final error = _errors[selectedIndex];
    final path = _cachedPaths[selectedIndex];

    // Loading state
    if (isLoading || (path == null && error == null)) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF6A5AE0)),
            SizedBox(height: 14),
            Text('Loading preview...',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      );
    }

    // Error state
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _errors.remove(selectedIndex);
                  _loadPdf(selectedIndex);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    // PDF view
    return PDFView(
      key: ValueKey(selectedIndex),
      filePath: path,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      fitPolicy: FitPolicy.BOTH,
      onRender: (pages) =>
          setState(() => _totalPages[selectedIndex] = pages ?? 0),
      onViewCreated: (c) => _controllers[selectedIndex] = c,
      onPageChanged: (page, total) => setState(() {
        _currentPage[selectedIndex] = page ?? 0;
        _totalPages[selectedIndex] = total ?? 0;
      }),
      onError: (e) =>
          setState(() => _errors[selectedIndex] = e.toString()),
    );
  }

  // ─────────────────────────────────────────────
  //  Prev / Next page navigator
  // ─────────────────────────────────────────────

  Widget _buildPageNav() {
    final current = _currentPage[selectedIndex] ?? 0;
    final total = _totalPages[selectedIndex] ?? 0;
    final ctrl = _controllers[selectedIndex];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed:
            current > 0 ? () => ctrl?.setPage(current - 1) : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Prev'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A5AE0),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
            ),
          ),
          Text('Page ${current + 1} of $total',
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ElevatedButton.icon(
            onPressed: current < total - 1
                ? () => ctrl?.setPage(current + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6A5AE0),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}








// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
//
//
// class MultiPdfViewerScreen extends StatefulWidget {
//   final String bookName;
//
//   /// List of maps: [{"label": "Book 1", "asset": "assets/pdfs/...pdf"}, ...]
//   final List<Map<String, String>> pdfs;
//
//   /// Which PDF tab to open first (default 0)
//   final int initialIndex;
//
//   const MultiPdfViewerScreen({
//     super.key,
//     required this.bookName,
//     required this.pdfs,
//     this.initialIndex = 0,
//   });
//
//   @override
//   State<MultiPdfViewerScreen> createState() => _MultiPdfViewerScreenState();
// }
//
// class _MultiPdfViewerScreenState extends State<MultiPdfViewerScreen> {
//   int selectedIndex = 0;
//
//   // Cache: index → local file path
//   final Map<int, String> _cachedPaths = {};
//   final Map<int, bool> _loading = {};
//   final Map<int, String?> _errors = {};
//
//   // Per-PDF page tracking
//   final Map<int, int> _currentPage = {};
//   final Map<int, int> _totalPages = {};
//   final Map<int, PDFViewController?> _controllers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.initialIndex;
//     _loadPdf(selectedIndex);
//   }
//
//   Future<void> _loadPdf(int index) async {
//     if (_cachedPaths.containsKey(index)) return;
//
//     setState(() => _loading[index] = true);
//
//     try {
//       final assetPath = widget.pdfs[index]['asset']!;
//       final bytes = await rootBundle.load(assetPath);
//       final dir = await getTemporaryDirectory();
//       final fileName = assetPath.split('/').last;
//       final file = File('${dir.path}/${widget.bookName}_${index}_$fileName');
//       await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
//
//       if (mounted) {
//         setState(() {
//           _cachedPaths[index] = file.path;
//           _loading[index] = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errors[index] = 'Could not load PDF.\n$e';
//           _loading[index] = false;
//         });
//       }
//     }
//   }
//
//   void _switchTab(int index) {
//     setState(() => selectedIndex = index);
//     _loadPdf(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final total = _totalPages[selectedIndex] ?? 0;
//     final current = _currentPage[selectedIndex] ?? 0;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           widget.bookName,
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 17,
//           ),
//         ),
//         actions: [
//           if (total > 0)
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 14),
//                 child: Text(
//                   '${current + 1} / $total',
//                   style: const TextStyle(color: Colors.grey, fontSize: 13),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // ── Tab bar (only show if more than 1 PDF) ──
//           if (widget.pdfs.length > 1) _buildTabBar(),
//
//           // ── PDF viewer ──
//           Expanded(child: _buildViewer()),
//
//           // ── Page navigator ──
//           if (total > 1) _buildPageNav(),
//         ],
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  Tab bar
//   // ─────────────────────────────────────────────
//   Widget _buildTabBar() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Row(
//           children: List.generate(widget.pdfs.length, (i) {
//             final selected = i == selectedIndex;
//             final label = widget.pdfs[i]['label'] ?? 'Book ${i + 1}';
//             return GestureDetector(
//               onTap: () => _switchTab(i),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: const EdgeInsets.only(right: 8),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: selected
//                       ? const Color(0xFF6A5AE0)
//                       : Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: selected
//                         ? const Color(0xFF6A5AE0)
//                         : Colors.grey.shade300,
//                   ),
//                 ),
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     color: selected ? Colors.white : Colors.grey[700],
//                     fontWeight:
//                         selected ? FontWeight.w600 : FontWeight.normal,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  PDF viewer body
//   // ─────────────────────────────────────────────
//   Widget _buildViewer() {
//     final isLoading = _loading[selectedIndex] == true;
//     final error = _errors[selectedIndex];
//     final path = _cachedPaths[selectedIndex];
//
//     // Loading state
//     if (isLoading || (path == null && error == null)) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF6A5AE0)),
//             SizedBox(height: 14),
//             Text('Loading preview...',
//                 style: TextStyle(color: Colors.grey, fontSize: 14)),
//           ],
//         ),
//       );
//     }
//
//     // Error state
//     if (error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 48),
//               const SizedBox(height: 12),
//               Text(error,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.red)),
//               const SizedBox(height: 16),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   _errors.remove(selectedIndex);
//                   _loadPdf(selectedIndex);
//                 },
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Retry'),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF6A5AE0),
//                     foregroundColor: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // PDF view
//     return PDFView(
//       key: ValueKey(selectedIndex),
//       filePath: path,
//       enableSwipe: true,
//       swipeHorizontal: false,
//       autoSpacing: true,
//       pageFling: true,
//       fitPolicy: FitPolicy.BOTH,
//       onRender: (pages) =>
//           setState(() => _totalPages[selectedIndex] = pages ?? 0),
//       onViewCreated: (c) => _controllers[selectedIndex] = c,
//       onPageChanged: (page, total) => setState(() {
//         _currentPage[selectedIndex] = page ?? 0;
//         _totalPages[selectedIndex] = total ?? 0;
//       }),
//       onError: (e) =>
//           setState(() => _errors[selectedIndex] = e.toString()),
//     );
//   }
//
//   // ─────────────────────────────────────────────
//   //  Prev / Next page navigator
//   // ─────────────────────────────────────────────
//   Widget _buildPageNav() {
//     final current = _currentPage[selectedIndex] ?? 0;
//     final total = _totalPages[selectedIndex] ?? 0;
//     final ctrl = _controllers[selectedIndex];
//
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ElevatedButton.icon(
//             onPressed:
//                 current > 0 ? () => ctrl?.setPage(current - 1) : null,
//             icon: const Icon(Icons.chevron_left),
//             label: const Text('Prev'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF6A5AE0),
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: Colors.grey[300],
//             ),
//           ),
//           Text('Page ${current + 1} of $total',
//               style: const TextStyle(color: Colors.grey, fontSize: 13)),
//           ElevatedButton.icon(
//             onPressed: current < total - 1
//                 ? () => ctrl?.setPage(current + 1)
//                 : null,
//             icon: const Icon(Icons.chevron_right),
//             label: const Text('Next'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF6A5AE0),
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: Colors.grey[300],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
