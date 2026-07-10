import 'package:era92_elevate/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  const MyTextfield({
    super.key,
    required this.label,
    required this.icon,
    required this.obscuretext,
    this.controller,
  });

  final String label;
  final IconData? icon;
  final bool obscuretext;
  final TextEditingController? controller;

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscuretext;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon, size: 20),
        suffixIcon: widget.obscuretext
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: AppColors.textLight,
                ),
              )
            : null,
      ),
    );
  }
}
