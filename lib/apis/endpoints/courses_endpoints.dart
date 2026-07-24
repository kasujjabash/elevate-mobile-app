// lib/apis/endpoints/courses_endpoints.dart

import 'package:era92_elevate/apis/base_url.dart';

class CoursesEndpoints {
  CoursesEndpoints._();

  /// GET — all modules for a course
  static String modules(String courseId) =>
      '${BaseUrl.api}/courses/$courseId/modules';

  /// GET — single module with its content
  static String moduleById(String moduleId) =>
      '${BaseUrl.api}/courses/modules/$moduleId';

  /// GET — student enrollments
  static String get myEnrollments => '${BaseUrl.api}/students/me/courses';

  /// GET — all student enrollments
  static String get enrollments => '${BaseUrl.api}/courses/enrollment';

  /// GET — course progress
  static String progress(String courseId) =>
      '${BaseUrl.api}/courses/$courseId/progress';

  /// POST — mark content as complete
  static String completeContent(String contentId) =>
      '${BaseUrl.api}/courses/content/$contentId/complete';
}
