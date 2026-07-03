import 'package:flutter/material.dart';
import 'package:era92_elevate/componets/lesson_card.dart';
import 'dart:math';

class LessonPageView extends StatefulWidget {
  final int currentLessonIndex;
  final bool isActiveDay;
  final int dayIndex;

  const LessonPageView({
    super.key,
    required this.currentLessonIndex,
    required this.isActiveDay,
    required this.dayIndex,
  });

  @override
  State<LessonPageView> createState() => _LessonPageViewState();
}

class _LessonPageViewState extends State<LessonPageView> {
  late PageController _controller;
  late double _page;
  late List<Map<String, String>> lessons;

  final List<Map<String, String>> _allLessons = [
    {
      'subject': 'Graphics Design',
      'time': '08:00 - 09:30',
      'instructor': 'Dr. Smith',
      'description': 'Layout and Hierarchy.',
    },
    {
      'subject': 'Web Development',
      'time': '10:00 - 11:30',
      'instructor': 'Prof. Johnson',
      'description': 'Introduction to Web.',
    },
    {
      'subject': 'Motion Graphics',
      'time': '12:00 - 13:30',
      'instructor': 'Dr. Lee',
      'description': 'Fundamentals of Motion Graphics.',
    },
    {
      'subject': 'UI/UX Design',
      'time': '08:00 - 09:30',
      'instructor': 'Ms. Nakato',
      'description': 'User research and wireframing.',
    },
    {
      'subject': 'Photography',
      'time': '10:00 - 11:30',
      'instructor': 'Mr. Okello',
      'description': 'Composition and lighting basics.',
    },
    {
      'subject': 'Brand Identity',
      'time': '12:00 - 13:30',
      'instructor': 'Mr. Mugisha',
      'description': 'Logo design and brand systems.',
    },
    {
      'subject': 'Typography',
      'time': '14:00 - 15:30',
      'instructor': 'Dr. Apio',
      'description': 'Type hierarchy and pairing.',
    },
  ];

  @override
  void initState() {
    super.initState();

    final seeded = List<Map<String, String>>.from(_allLessons);
    seeded.shuffle(Random(widget.dayIndex));
    lessons = seeded.take(3).toList();

    _controller = PageController(
      initialPage: widget.currentLessonIndex,
      viewportFraction: 0.78,
    );

    _page = widget.currentLessonIndex.toDouble();

    _controller.addListener(() {
      setState(() {
        _page = _controller.page ?? _page;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
      child: PageView.builder(
        controller: _controller,
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final distance = (_page - index).abs();
          final scale = (1.0 - distance * 0.08).clamp(0.92, 1.0);
          final isHighlighted =
              widget.isActiveDay && index == widget.currentLessonIndex;

          return Transform.scale(
            scale: scale,
            child: LessonCard(
              subject: lessons[index]['subject']!,
              time: lessons[index]['time']!,
              instructor: lessons[index]['instructor']!,
              description: lessons[index]['description']!,
              isActive: isHighlighted,
            ),
          );
        },
      ),
    );
  }
}