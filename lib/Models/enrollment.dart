class Enrollment {
  Enrollment({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.courseSlug,
    required this.hubName,
    required this.status,
    required this.progress,
    required this.enrolledAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    final courseName =
        json['title']?.toString() ??
        json['courseName']?.toString() ??
        (json['course'] as Map<String, dynamic>?)?['title']?.toString() ??
        '';

    final slug =
        json['courseSlug']?.toString() ??
        courseName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

    final courseId =
        json['courseId']?.toString() ??
        (json['course'] as Map<String, dynamic>?)?['id']?.toString() ??
        '';

    return Enrollment(
      id: json['enrollmentId']?.toString() ?? json['id']?.toString() ?? '',
      courseId: courseId,
      courseName: courseName,
      courseSlug: slug,
      hubName: json['hub']?.toString() ?? json['hubName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      enrolledAt: json['enrolledAt']?.toString() ?? '',
    );
  }

  /*return Enrollment(
      id: json['id']?.toString() ?? '',
      courseId: courseId,
      courseName: courseName,
      courseSlug: slug,
      hubName: json['hubName']?.toString() ??
          (json['hub'] as Map<String, dynamic>?)?['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      enrolledAt: json['enrolledAt']?.toString() ?? '',
    );
  }*/

  final String id;
  final String courseId;
  final String courseName;
  final String courseSlug;
  final String hubName;
  final String status;
  final int progress;
  final String enrolledAt;
}
