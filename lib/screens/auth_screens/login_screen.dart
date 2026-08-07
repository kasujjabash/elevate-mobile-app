import 'package:era92_elevate/componets/text_field.dart';
import 'package:era92_elevate/providers/auth_provider.dart';
import 'package:era92_elevate/providers/course_provider.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/student_shell.dart';
import 'package:era92_elevate/screens/app_screens/admin_screen/admin.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Please enter username and password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final auth = context.read<AuthProvider>();
    final success = await auth.login(username, password);

    if (!success) {
      if (mounted) {
        setState(() {
          _errorText = auth.errorMessage;
          _isLoading = false;
        });
      }
      return;
    }

    final user = auth.user!;
    if (user.isStudent) {
      if (!mounted) return;
      final courseProvider = context.read<CourseProvider>();
      courseProvider.clear(); // clear previous student's courses first
      await courseProvider.fetchEnrollments(
            token: auth.token!,
            contactId: user.contactId,
          );
    }

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => user.isStudent ? const StudentShell() : const AdminScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/welcome-elevate-1.png', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.30),
                    AppColors.black.withValues(alpha: 0.50),
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.72,
              minChildSize: 0.55,
              maxChildSize: 0.97,
              snap: true,
              snapSizes: const [0.55, 0.72, 0.97],
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      inputDecorationTheme:
                          Theme.of(context).inputDecorationTheme.copyWith(
                                fillColor: const Color(0xFFF5F5F7),
                              ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 48),
                      children: [
                        Center(
                          child: Container(
                            width: 36,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: AppColors.divider,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Align(
                            key: ValueKey(_tab),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _tab == 0
                                  ? 'Go ahead and set up\nyour account'
                                  : 'Enroll into\nthe program',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.2,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign-in to enjoy the best learning experience',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 46,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F2),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Row(
                            children: [
                              _tabItem('Login', 0),
                              _tabItem('Register', 1),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOut,
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.04),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: Column(
                            key: ValueKey(_tab),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _tab == 0 ? _loginContent() : _registerContent(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _loginContent() => [
        MyTextfield(
          label: 'Username',
          icon: Icons.person_outline_rounded,
          obscuretext: false,
          controller: _usernameController,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          obscuretext: true,
          controller: _passwordController,
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 10),
          Text(
            _errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],
        const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: false,
                          onChanged: (_) {},
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          side: const BorderSide(color: AppColors.divider),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 24),
        _gradientButton(
          _isLoading ? 'Logging in...' : 'Login',
          _isLoading ? null : _handleLogin,
        ),
      ];

  List<Widget> _registerContent() => [
        MyTextfield(label: 'First Name', icon: Icons.person_outline_rounded, obscuretext: false),
        const SizedBox(height: 12),
        MyTextfield(label: 'Last Name', icon: Icons.person_outline_rounded, obscuretext: false),
        const SizedBox(height: 12),
        MyTextfield(label: 'Phone Number', icon: Icons.phone_outlined, obscuretext: false),
        const SizedBox(height: 12),
        MyTextfield(label: 'Date of Birth', icon: Icons.cake_outlined, obscuretext: false),
        const SizedBox(height: 20),
        MyTextfield(label: 'Email Address', icon: Icons.email_outlined, obscuretext: false),
        const SizedBox(height: 12),
        MyTextfield(label: 'Username', icon: Icons.alternate_email_rounded, obscuretext: false),
        const SizedBox(height: 12),
        MyTextfield(label: 'Password', icon: Icons.lock_outline_rounded, obscuretext: true),
        const SizedBox(height: 12),
        MyTextfield(label: 'Confirm Password', icon: Icons.lock_outline_rounded, obscuretext: true),
        const SizedBox(height: 28),
        _gradientButton('Register', () {}),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.6),
              children: [
                TextSpan(text: 'By registering you agree to our '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ];

  Widget _tabItem(String label, int index) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: active ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active
                ? [BoxShadow(color: AppColors.black.withValues(alpha: 0.09), blurRadius: 10, offset: const Offset(0, 3))]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback? onPressed) => SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.2),
            ),
            child: Text(label),
          ),
        ),
      );
}
