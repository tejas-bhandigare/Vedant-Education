import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackService {

  final supabase = Supabase.instance.client;

  Future<void> submitFeedback({
    required String userId,
    required int rating,
    required String comment,
  }) async {

    await supabase.from('feedback').insert({

      'user_id': userId,
      'rating': rating,
      'comment': comment,

    });

  }

}