import 'package:era92_elevate/providers/auth_provider.dart';
import 'package:era92_elevate/providers/course_provider.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/student_shell.dart';
import 'package:era92_elevate/screens/app_screens/admin_screen/admin.dart';
import 'package:era92_elevate/screens/auth_screens/welcome_screen.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elevate Academy',
        theme: AppTheme.light,
        home: const AuthGate(),
      ),
    );
  }
}

/// Decides the initial screen based on whether a session was restored from
/// disk, and routes authenticated users by role.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final auth = context.read<AuthProvider>();
    final courses = context.read<CourseProvider>();

    // Clear any stale course data before restoring session
    courses.clear();

    await auth.tryAutoLogin();
    if (!mounted) return;

    if (auth.status == AuthStatus.authenticated && auth.user!.isStudent) {
      await courses.fetchEnrollments(
        token: auth.token!,
        contactId: auth.user!.contactId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return switch (auth.status) {
      AuthStatus.unknown ||
      AuthStatus.authenticating =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
      AuthStatus.unauthenticated => const WelcomeScreen(),
      AuthStatus.authenticated =>
        auth.user!.isStudent ? const StudentShell() : const AdminScreen(),
    };
  }
}
