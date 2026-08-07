import 'package:flutter/foundation.dart';
import 'package:era92_elevate/apis/api_client.dart';
import 'package:era92_elevate/apis/courses_api.dart';
import 'package:era92_elevate/models/enrollment.dart';

class CourseProvider extends ChangeNotifier {
  List<Enrollment> enrollments = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchEnrollments({
    required String token,
    required String contactId,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      enrollments = await CoursesApi.fetchEnrollments(
        token: token,
        contactId: contactId,
      );
    } on ApiException catch (e) {
      error = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    enrollments = [];
    error = null;
    isLoading = false;
    notifyListeners();
  }
}
