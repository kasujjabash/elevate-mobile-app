import 'package:era92_elevate/componets/text_field.dart';
import 'package:era92_elevate/screens/app_screens/Students_screen/student_shell.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0;

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
            // ── Full-screen background ────────────────────────────
            Image.asset('assets/welcome-elevate-1.png', fit: BoxFit.cover),

            // ── Dark overlay ──────────────────────────────────────
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

            // ── Draggable card ────────────────────────────────────
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
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
                        // Drag handle
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

                        // Headline
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

                        // ── Tab switcher ───────────────────────────
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

                        // ── Tab content ────────────────────────────
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
                            children: _tab == 0
                                ? _loginContent()
                                : _registerContent(),
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

  // ── Login ─────────────────────────────────────────────────────────
  List<Widget> _loginContent() => [
        MyTextfield(
          label: 'Username',
          icon: Icons.person_outline_rounded,
          obscuretext: false,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          obscuretext: true,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
        _gradientButton('Login', () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const StudentShell()),
          );
        }),
      ];

  // ── Register ──────────────────────────────────────────────────────
  List<Widget> _registerContent() => [
        // Bio data
        MyTextfield(
          label: 'First Name',
          icon: Icons.person_outline_rounded,
          obscuretext: false,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Last Name',
          icon: Icons.person_outline_rounded,
          obscuretext: false,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          obscuretext: false,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Date of Birth',
          icon: Icons.cake_outlined,
          obscuretext: false,
        ),
        const SizedBox(height: 20),
        // Account details
        MyTextfield(
          label: 'Email Address',
          icon: Icons.email_outlined,
          obscuretext: false,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Username',
          icon: Icons.alternate_email_rounded,
          obscuretext: false,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Password',
          icon: Icons.lock_outline_rounded,
          obscuretext: true,
        ),
        const SizedBox(height: 12),
        MyTextfield(
          label: 'Confirm Password',
          icon: Icons.lock_outline_rounded,
          obscuretext: true,
        ),
        const SizedBox(height: 28),
        _gradientButton('Register', () {}),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 12, color: AppColors.textLight, height: 1.6),
              children: [
                TextSpan(text: 'By registering you agree to our '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ];

  // ── Shared ────────────────────────────────────────────────────────
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
                ? [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.09),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color:
                  active ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gradientButton(String label, VoidCallback onPressed) => SizedBox(
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2),
            ),
            child: Text(label),
          ),
        ),
      );

}
