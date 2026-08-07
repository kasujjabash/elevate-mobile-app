// lib/apis/courses_api.dart

import 'package:era92_elevate/apis/api_client.dart';
import 'package:era92_elevate/apis/endpoints/courses_endpoints.dart';
import 'package:era92_elevate/models/enrollment.dart';

class CoursesApi {
  /// Fetch all modules for a course
  static Future<List<dynamic>> getCourseModules({
    required String courseId,
    required String token,
  }) async {
    final body = await ApiClient.get(
      CoursesEndpoints.modules(courseId),
      token: token,
    );
    if (body is List) return body;
    if (body is Map && body['data'] is List) return body['data'] as List;
    return [];
  }

  /// Fetch a single module with its content
  static Future<Map<String, dynamic>> getModuleById({
    required String moduleId,
    required String token,
  }) async {
    final body = await ApiClient.get(
      CoursesEndpoints.moduleById(moduleId),
      token: token,
    );
    return body as Map<String, dynamic>;
  }

  /// Fetch course progress for the logged-in student
  static Future<Map<String, dynamic>> getCourseProgress({
    required String courseId,
    required String token,
  }) async {
    final body = await ApiClient.get(
      CoursesEndpoints.progress(courseId),
      token: token,
    );
    return body as Map<String, dynamic>;
  }

  /// Submit an assignment link for a module content item
  static Future<void> submitAssignmentLink({
    required String contentId,
    required String link,
    required String token,
  }) async {
    await ApiClient.post(
      CoursesEndpoints.submitAssignment(contentId),
      body: {
        'content': link,
        'filePath': link,
        'status': 'Submitted',
      },
      token: token,
    );
  }

  /// Mark a content item as complete
  static Future<void> markContentComplete({
    required String contentId,
    required String token,
  }) async {
    await ApiClient.post(
      CoursesEndpoints.completeContent(contentId),
      token: token,
    );
  }

  /// Fetch all enrollments for a given student
  static Future<List<Enrollment>> fetchEnrollments({
    required String token,
    required String contactId,
  }) async {
    final body = await ApiClient.get(
      CoursesEndpoints.myEnrollments,
      token: token,
    );

    // API returns { value: [...], Count: N }
    if (body is Map && body['value'] is List) {
      return (body['value'] as List)
          .map((e) => Enrollment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (body is List) {
      return body
          .map((e) => Enrollment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (body is Map && body['data'] is List) {
      return (body['data'] as List)
          .map((e) => Enrollment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
