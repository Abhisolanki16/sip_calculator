import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_calculator/utils/extensions.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool isPassword;
  final bool isEmail;
  final bool isPhone;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  // Customization
  final Widget? prefix; // can be icon, dropdown, text (country code)
  final Widget? suffix; // custom widget
  final String? suffixText; // text to show as suffix
  final int? maxLength;
  final int maxLines;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;
  final bool filled;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final Widget? outsideIcon;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.inputType,
    this.isPassword = false,
    this.isEmail = false,
    this.isPhone = false,
    this.prefix,
    this.suffix,
    this.suffixText,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.textStyle,

    this.borderRadius = 12,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 16,
    ),
    this.fillColor,
    this.filled = false,
    this.labelStyle,
    this.hintStyle,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.outsideIcon,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) return "${widget.label} is required";

    if (widget.isEmail) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) return "Enter a valid email";
    }

    if (widget.isPhone) {
      final phoneRegex = RegExp(r'^[0-9]{10}$');
      if (!phoneRegex.hasMatch(value)) return "Enter a valid phone number";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: widget.isPassword ? _obscure : false,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      validator: widget.validator ?? _defaultValidator,
      style: widget.textStyle ?? widget.hintStyle,

      inputFormatters:
          widget.inputFormatters ??
          [
            if (widget.isPhone) FilteringTextInputFormatter.digitsOnly,

            // Allow only digits for phone input
          ],
      decoration: InputDecoration(
        icon: widget.outsideIcon,
        labelText: widget.label,
        hintText: widget.hint,

        labelStyle: widget.labelStyle,
        hintStyle: widget.hintStyle,
        filled: widget.filled,
        fillColor: widget.fillColor,
        contentPadding: widget.contentPadding,
        suffixText: widget.suffixText,
        enabledBorder:
            widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Colors.grey),
            ),
        focusedBorder:
            widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Colors.blue),
            ),
        errorBorder:
            widget.errorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Colors.red),
            ),
        focusedErrorBorder:
            widget.focusedErrorBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
        disabledBorder: widget.disabledBorder,
        prefixIcon: widget.prefix != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget.prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffix: widget.isPassword
            ? GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
              )
            : widget.suffix,
      ),
    );
  }
}

class AppTextFieldDemo extends StatelessWidget {
  AppTextFieldDemo({super.key});
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom TextFields")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: "Email",
                hint: "Enter your email",
                controller: emailController,
                inputType: TextInputType.emailAddress,
                isEmail: true,
                prefix: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              const SizedBox(height: 16),

              // Phone with Country Code Dropdown
              AppTextField(
                label: "Phone",
                hint: "Enter phone number",
                controller: phoneController,
                inputType: TextInputType.phone,
                isPhone: true,
                prefix: DropdownButton<String>(
                  value: "+91",
                  underline: const SizedBox(),
                  items: ["+91", "+1", "+44"]
                      .map(
                        (code) =>
                            DropdownMenuItem(value: code, child: Text(code)),
                      )
                      .toList(),
                  onChanged: (val) {},
                ),
              ),
              const SizedBox(height: 16),

              // Password
              AppTextField(
                label: "Password",
                hint: "Enter password",
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Form is valid ✅")),
                    );
                  }
                },
                child: const Text("Submit"),
              ),

              Text(
                "Hello Extensions",
              ).paddingAll(16).bg(Colors.blue.shade100).rounded(12).shadow(),
            ],
          ),
        ),
      ),
    );
  }
}
