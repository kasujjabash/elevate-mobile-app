import 'package:era92_elevate/services/session_service.dart';
import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StudentsProfile extends StatefulWidget {
  const StudentsProfile({super.key});

  @override
  State<StudentsProfile> createState() => _StudentsProfileState();
}

class _StudentsProfileState extends State<StudentsProfile> {
  final _session = SessionService.instance;

  late String _firstName;
  late String _lastName;

  @override
  void initState() {
    super.initState();
    _firstName = _session.firstName ?? 'Super';
    _lastName  = _session.lastName  ?? 'Admin';
  }

  String get _initials {
    final f = _firstName.isNotEmpty ? _firstName[0].toUpperCase() : '';
    final l = _lastName.isNotEmpty  ? _lastName[0].toUpperCase()  : '';
    return '$f$l'.isNotEmpty ? '$f$l' : '?';
  }

  void _openEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        firstName: _firstName,
        lastName: _lastName,
        onSave: (first, last) {
          setState(() {
            _firstName = first;
            _lastName  = last;
            _session.firstName = first;
            _session.lastName  = last;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Profile updated successfully!',
                    style: TextStyle(color: Colors.white)),
              ]),
              backgroundColor: const Color(0xFF06D6A0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email        = _session.email        ?? 'Not provided';
    final phone        = _session.phone        ?? 'Not provided';
    final gender       = _session.gender       ?? 'Not provided';
    final hub          = _session.hub          ?? 'Not assigned';
    final role         = _session.role         ?? 'Super Admin';
    final status       = _session.status       ?? 'Active';
    final memberStatus = _session.memberStatus ?? 'Enrolled';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        slivers: [

          // ── Gradient header ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primaryDiagonal,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Text('My Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('MY PROFILE',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2)),
                          Text(
                            '$_firstName $_lastName',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Avatar overlapping banner
                Positioned(
                  bottom: -44,
                  left: 20,
                  child: Stack(
                    children: [
                      Container(
                        width: 88, height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.primary,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(_initials,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
                      // Online dot
                      Positioned(
                        bottom: 4, right: 4,
                        child: Container(
                          width: 14, height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF06D6A0),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Profile button
                Positioned(
                  bottom: -88,
                  right: 20,
                  child: GestureDetector(
                    onTap: _openEditProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppGradients.primary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded,
                              size: 14, color: Colors.white),
                          SizedBox(width: 6),
                          Text('Edit Profile',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 160),
              ],
            ),
          ),

          // ── Email + Role chips ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
              child: Row(
                children: [
                  _Chip(
                    icon: Icons.email_outlined,
                    label: email,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 10),
                  _Chip(
                    icon: Icons.school_rounded,
                    label: role,
                    color: AppColors.primary,
                    filled: true,
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // ── Stats row: HUB · ROLE · STATUS · MEMBER ─────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFFEF476F),
                      label: 'HUB',
                      value: hub,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.school_rounded,
                      iconColor: const Color(0xFF6C5CE7),
                      label: 'ROLE',
                      value: role,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle_rounded,
                      iconColor: const Color(0xFF06D6A0),
                      label: 'STATUS',
                      value: status,
                      valueColor: const Color(0xFF06D6A0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.calendar_month_rounded,
                      iconColor: const Color(0xFF0096B4),
                      label: 'MEMBER',
                      value: memberStatus,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // ── Profile Details + Account cards ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth > 600;
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ProfileDetailsCard(
                          firstName: _firstName,
                          lastName: _lastName,
                          email: email,
                          phone: phone,
                          gender: gender,
                          hub: hub,
                          onEdit: _openEditProfile,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _AccountCard(
                          status: status,
                          username: email,
                          role: role,
                          email: email,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    _ProfileDetailsCard(
                      firstName: _firstName,
                      lastName: _lastName,
                      email: email,
                      phone: phone,
                      gender: gender,
                      hub: hub,
                      onEdit: _openEditProfile,
                    ),
                    const SizedBox(height: 16),
                    _AccountCard(
                      status: status,
                      username: email,
                      role: role,
                      email: email,
                    ),
                  ],
                );
              }),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ── Profile Details card ───────────────────────────────────────────────────────

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.hub,
    required this.onEdit,
  });

  final String firstName, lastName, email, phone, gender, hub;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded,
                    color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile Details',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  Text('Your personal information',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textLight)),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.textLight),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // First Name + Last Name
          Row(
            children: [
              Expanded(
                  child: _DetailField(label: 'FIRST NAME', value: firstName)),
              const SizedBox(width: 16),
              Expanded(
                  child: _DetailField(label: 'LAST NAME', value: lastName)),
            ],
          ),
          const SizedBox(height: 16),

          // Email — READ-ONLY
          _DetailField(
              label: 'EMAIL ADDRESS', value: email, readOnly: true),
          const SizedBox(height: 16),

          // Phone + Gender
          Row(
            children: [
              Expanded(
                  child: _DetailField(
                      label: 'PHONE NUMBER', value: phone)),
              const SizedBox(width: 16),
              Expanded(
                  child: _DetailField(
                      label: 'GENDER', value: gender, readOnly: true)),
            ],
          ),
          const SizedBox(height: 16),

          // Hub — READ-ONLY
          _DetailField(label: 'HUB', value: hub, readOnly: true),
        ],
      ),
    );
  }
}

// ── Account card ───────────────────────────────────────────────────────────────

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.status,
    required this.username,
    required this.role,
    required this.email,
  });

  final String status, username, role, email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.manage_accounts_rounded,
                    color: Color(0xFF6C5CE7), size: 18),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  Text('Status and access',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textLight)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // STATUS
          _AccountRow(
            icon: Icons.check_circle_rounded,
            iconColor: const Color(0xFF06D6A0),
            label: 'STATUS',
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF06D6A0).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle_rounded,
                      size: 11, color: Color(0xFF06D6A0)),
                  SizedBox(width: 4),
                  Text('Active',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF06D6A0))),
                ],
              ),
            ),
          ),
          const _AccountDivider(),

          // USERNAME
          _AccountRow(
            icon: Icons.person_outline_rounded,
            iconColor: AppColors.textLight,
            label: 'USERNAME',
            value: username,
          ),
          const _AccountDivider(),

          // ROLE
          _AccountRow(
            icon: Icons.school_rounded,
            iconColor: const Color(0xFF6C5CE7),
            label: 'ROLE',
            value: role,
          ),
          const _AccountDivider(),

          // EMAIL
          _AccountRow(
            icon: Icons.email_rounded,
            iconColor: AppColors.primary,
            label: 'EMAIL',
            value: email,
          ),
          const _AccountDivider(),

          // PASSWORD
          _AccountRow(
            icon: Icons.lock_rounded,
            iconColor: AppColors.textLight,
            label: 'PASSWORD',
            value: '••••••••',
          ),
        ],
      ),
    );
  }
}

// ── Shared small widgets ───────────────────────────────────────────────────────

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    this.readOnly = false,
  });

  final String label;
  final String value;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textLight,
                    letterSpacing: 0.8)),
            if (readOnly) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.lock_outline_rounded,
                        size: 9, color: AppColors.textLight),
                    SizedBox(width: 2),
                    Text('READ-ONLY',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textLight)),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: value == 'Not provided' || value == 'Not assigned'
                ? AppColors.textLight
                : AppColors.textPrimary,
            fontStyle: value == 'Not provided' || value == 'Not assigned'
                ? FontStyle.italic
                : FontStyle.normal,
          ),
        ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.value,
    this.child,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                        letterSpacing: 0.8)),
                const SizedBox(height: 2),
                if (child != null)
                  child!
                else
                  Text(value ?? '—',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountDivider extends StatelessWidget {
  const _AccountDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(color: AppColors.divider, height: 1, indent: 44);
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, color: iconColor, size: 15),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                  letterSpacing: 0.5)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.color,
    this.filled = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                filled ? color.withValues(alpha: 0.3) : AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ── Edit Profile bottom sheet ──────────────────────────────────────────────────

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.firstName,
    required this.lastName,
    required this.onSave,
  });

  final String firstName;
  final String lastName;
  final void Function(String first, String last) onSave;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstCtrl = TextEditingController(text: widget.firstName);
    _lastCtrl  = TextEditingController(text: widget.lastName);
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context);
    widget.onSave(_firstCtrl.text.trim(), _lastCtrl.text.trim());
  }

  InputDecoration _dec({required String hint, required IconData icon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: AppColors.textLight, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
        filled: true,
        fillColor: const Color(0xFFF5F5F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF476F))),
      );

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Edit Profile',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Only your name can be changed here.',
                style:
                    TextStyle(fontSize: 13, color: AppColors.textLight)),
            const SizedBox(height: 24),

            const Text('First Name',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _firstCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _dec(
                  hint: 'Enter first name', icon: Icons.badge_rounded),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length < 2) return 'Too short';
                return null;
              },
            ),
            const SizedBox(height: 16),

            const Text('Last Name',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _lastCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _dec(
                  hint: 'Enter last name', icon: Icons.badge_outlined),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (v.trim().length < 2) return 'Too short';
                return null;
              },
            ),
            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLight)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: AppGradients.primary,
                          borderRadius: BorderRadius.circular(12)),
                      child: TextButton(
                        onPressed: _save,
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded,
                                size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Save Changes',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
