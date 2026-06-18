import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackService {
  final _supabase = Supabase.instance.client;

  Future<void> submitFeedback({
    required int rating,
    required List<String> tags,
    required String comment,
  }) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User is not logged in.');
    }

    await _supabase.from('feedback').insert({
      'user_id': userId,
      'rating': rating,
      'tags': tags,
      'comment': comment.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}






// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class FeedbackService {
//
//   final supabase = Supabase.instance.client;
//
//   Future<void> submitFeedback({
//     required String userId,
//     required int rating,
//     required String comment,
//   }) async {
//
//     await supabase.from('feedback').insert({
//
//       'user_id': userId,
//       'rating': rating,
//       'comment': comment,
//
//     });
//
//   }
//
// }