// lib/screens/app_screens/Students_screen/course_content_screen.dart

import 'package:era92_elevate/apis/courses_api.dart';
import 'package:era92_elevate/models/enrollment.dart';
import 'package:era92_elevate/providers/auth_provider.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ── Models ─────────────────────────────────────────────────────────────────────

class _ContentItem {
  _ContentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.body,
    required this.durationMin,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String type;
  final String body;
  final int durationMin;
  bool isCompleted;

  factory _ContentItem.fromJson(Map<String, dynamic> json) => _ContentItem(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        type: json['type']?.toString() ?? 'Lesson',
        body: json['body']?.toString() ?? '',
        durationMin: (json['durationMin'] as num?)?.toInt() ?? 0,
        isCompleted: json['isCompleted'] == true,
      );
}

class _Module {
  _Module({
    required this.id,
    required this.title,
    required this.contents,
  });

  final String id;
  final String title;
  List<_ContentItem> contents;

  factory _Module.fromJson(Map<String, dynamic> json) {
    final rawContents = json['contents'] as List<dynamic>? ??
        json['moduleContent'] as List<dynamic>? ?? [];
    return _Module(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      contents: rawContents
          .map((c) => _ContentItem.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── Screen ─────────────────────────────────────────────────────────────────────

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen({
    super.key,
    required this.enrollment,
    required this.accent,
    required this.icon,
  });

  final Enrollment enrollment;
  final Color accent;
  final IconData icon;

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  List<_Module> _modules = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    final token = context.read<AuthProvider>().token ?? '';
    try {
      final raw = await CoursesApi.getCourseModules(
        courseId: widget.enrollment.courseId,
        token: token,
      );
      setState(() {
        _modules = raw
            .map((m) => _Module.fromJson(m as Map<String, dynamic>))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load course content';
        _loading = false;
      });
    }
  }

  int get _totalContent =>
      _modules.fold(0, (sum, m) => sum + m.contents.length);

  int get _completedContent => _modules.fold(
      0, (sum, m) => sum + m.contents.where((c) => c.isCompleted).length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [
          // ── App bar ────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: widget.accent,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.accent,
                      widget.accent.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(widget.icon,
                          size: 160,
                          color: Colors.white.withValues(alpha: 0.07)),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.enrollment.courseName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (!_loading)
                              Row(
                                children: [
                                  const Icon(Icons.menu_book_rounded,
                                      size: 13, color: Colors.white70),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${_modules.length} modules  •  $_totalContent lessons',
                                    style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Progress bar ───────────────────────────────────────────────────
          if (!_loading && _totalContent > 0)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_completedContent of $_totalContent completed',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${widget.enrollment.progress}%',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: widget.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (widget.enrollment.progress / 100)
                            .clamp(0.0, 1.0),
                        backgroundColor:
                            widget.accent.withValues(alpha: 0.12),
                        valueColor:
                            AlwaysStoppedAnimation(widget.accent),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Body ──────────────────────────────────────────────────────────
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: AppColors.textLight),
                    const SizedBox(height: 12),
                    Text(_error!,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadModules,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_modules.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_open_rounded,
                        size: 56, color: AppColors.textLight),
                    SizedBox(height: 12),
                    Text('No content available yet',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    SizedBox(height: 4),
                    Text('Check back soon for course materials.',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ModuleCard(
                      module: _modules[i],
                      moduleNumber: i + 1,
                      accent: widget.accent,
                      token: context.read<AuthProvider>().token ?? '',
                      onContentCompleted: () => setState(() {}),
                    ),
                  ),
                  childCount: _modules.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Module card ────────────────────────────────────────────────────────────────

class _ModuleCard extends StatefulWidget {
  const _ModuleCard({
    required this.module,
    required this.moduleNumber,
    required this.accent,
    required this.token,
    required this.onContentCompleted,
  });

  final _Module module;
  final int moduleNumber;
  final Color accent;
  final String token;
  final VoidCallback onContentCompleted;

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _expanded = false;

  int get _completed =>
      widget.module.contents.where((c) => c.isCompleted).length;
  int get _total => widget.module.contents.length;
  bool get _allDone => _completed == _total && _total > 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Module header ────────────────────────────────────────────────
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Module number circle
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _allDone
                          ? const Color(0xFF06D6A0).withValues(alpha: 0.12)
                          : widget.accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: _allDone
                        ? const Icon(Icons.check_rounded,
                            color: Color(0xFF06D6A0), size: 18)
                        : Center(
                            child: Text(
                              '${widget.moduleNumber}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: widget.accent,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.module.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$_completed / $_total lessons',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textLight,
                  ),
                ],
              ),
            ),
          ),

          // ── Content items ────────────────────────────────────────────────
          if (_expanded) ...[
            const Divider(color: AppColors.divider, height: 1),
            ...widget.module.contents.map(
              (content) => _ContentTile(
                content: content,
                accent: widget.accent,
                token: widget.token,
                onCompleted: () {
                  setState(() => content.isCompleted = true);
                  widget.onContentCompleted();
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Content tile ───────────────────────────────────────────────────────────────

class _ContentTile extends StatelessWidget {
  const _ContentTile({
    required this.content,
    required this.accent,
    required this.token,
    required this.onCompleted,
  });

  final _ContentItem content;
  final Color accent;
  final String token;
  final VoidCallback onCompleted;

  IconData get _typeIcon {
    switch (content.type) {
      case 'Video':
        return Icons.play_circle_outline_rounded;
      case 'Quiz':
        return Icons.quiz_outlined;
      case 'Assignment':
        return Icons.assignment_outlined;
      case 'Resource':
        return Icons.attach_file_rounded;
      default:
        return Icons.menu_book_outlined;
    }
  }

  Color get _typeColor {
    switch (content.type) {
      case 'Video':
        return const Color(0xFF1565C0);
      case 'Quiz':
        return const Color(0xFFEF6C00);
      case 'Assignment':
        return const Color(0xFF7B1FA2);
      case 'Resource':
        return const Color(0xFF2E7D32);
      default:
        return AppColors.primary;
    }
  }

  void _openContent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ContentDetailScreen(
          content: content,
          accent: accent,
          token: token,
          onCompleted: onCompleted,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openContent(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _typeColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_typeIcon, color: _typeColor, size: 16),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: content.isCompleted
                          ? AppColors.textLight
                          : AppColors.textPrimary,
                      decoration: content.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        content.type,
                        style: TextStyle(
                            fontSize: 10,
                            color: _typeColor,
                            fontWeight: FontWeight.w600),
                      ),
                      if (content.durationMin > 0) ...[
                        const Text('  •  ',
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textLight)),
                        Text(
                          '${content.durationMin} min',
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textLight),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Completion indicator
            if (content.isCompleted)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF06D6A0), size: 20)
            else
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textLight, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Content detail screen ──────────────────────────────────────────────────────

class _ContentDetailScreen extends StatefulWidget {
  const _ContentDetailScreen({
    required this.content,
    required this.accent,
    required this.token,
    required this.onCompleted,
  });

  final _ContentItem content;
  final Color accent;
  final String token;
  final VoidCallback onCompleted;

  @override
  State<_ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<_ContentDetailScreen> {
  bool _marking = false;

  IconData get _typeIcon {
    switch (widget.content.type) {
      case 'Video':
        return Icons.play_circle_outline_rounded;
      case 'Quiz':
        return Icons.quiz_outlined;
      case 'Assignment':
        return Icons.assignment_outlined;
      case 'Resource':
        return Icons.attach_file_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  Future<void> _markComplete() async {
    if (widget.content.isCompleted) return;
    setState(() => _marking = true);
    try {
      await CoursesApi.markContentComplete(
        contentId: widget.content.id,
        token: widget.token,
      );
      widget.content.isCompleted = true;
      widget.onCompleted();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Marked as complete!',
                  style: TextStyle(color: Colors.white)),
            ]),
            backgroundColor: const Color(0xFF06D6A0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context);
      }
    } catch (_) {
      // Mark complete locally even if API fails
      widget.content.isCompleted = true;
      widget.onCompleted();
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: widget.accent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
          ),
        ),
        title: Text(
          widget.content.type,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type + title card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.accent,
                    widget.accent.withValues(alpha: 0.75)
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_typeIcon,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.content.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  if (widget.content.durationMin > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 13, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.content.durationMin} min',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Content body
            const Row(
              children: [
                Icon(Icons.article_outlined,
                    size: 16, color: AppColors.primary),
                SizedBox(width: 6),
                Text('Content',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.content.body.isNotEmpty
                    ? widget.content.body
                    : 'No content available for this item yet.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Mark complete button
            if (!widget.content.isCompleted)
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.accent,
                        widget.accent.withValues(alpha: 0.8)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton(
                    onPressed: _marking ? null : _markComplete,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _marking
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_rounded,
                                  color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Mark as Complete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF06D6A0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: const Color(0xFF06D6A0).withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: Color(0xFF06D6A0), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Color(0xFF06D6A0),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
