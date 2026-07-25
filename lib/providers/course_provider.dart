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
    String? studentHub, // Added for hub-based filtering
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final rawEnrollments = await CoursesApi.fetchEnrollments(
        token: token,
        contactId: contactId,
      );

      // --- STRICT FILTERING & DEDUPLICATION ---
      final uniqueMap = <String, Enrollment>{};
      
      for (var enrollment in rawEnrollments) {
        // 1. Filter by Hub
        if (studentHub != null && studentHub.isNotEmpty) {
          // Compare hubs (case-insensitive)
          final isSameHub = enrollment.hubName.trim().toLowerCase() == studentHub.trim().toLowerCase();
          if (!isSameHub) continue; 
        }

        // 2. Deduplicate by courseId (or name if ID is missing)
        final key = enrollment.courseId.isNotEmpty ? enrollment.courseId : enrollment.courseName.trim().toLowerCase();
        
        // We keep the first one we find or could add logic to keep the most recent
        if (!uniqueMap.containsKey(key)) {
          uniqueMap[key] = enrollment;
        }
      }
      
      enrollments = uniqueMap.values.toList();
      
      // Optional: Sort by enrollment date
      enrollments.sort((a, b) => b.enrolledAt.compareTo(a.enrolledAt));
      
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
