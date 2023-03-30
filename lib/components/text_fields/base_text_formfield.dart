import 'package:flutter/material.dart';
import 'package:solutionchallenge/constants/strings/error_strings.dart';

class BaseTextFormField extends StatefulWidget {
  String hintText;
  String? labelText;
  String? errorText;
  bool isPassword;
  bool isEmail;
  bool isPhone;
  bool isNumber;
  TextEditingController? controller;
  Icon prefixIcon;
  Icon? suffixIcon;
  bool isHidden;
  double? padding;
  String? Function(dynamic value)? validator;

  BaseTextFormField({
    Key? key,
    required this.hintText,
    this.labelText,
    this.errorText = ErrorStrings.error,
    this.isPassword = false,
    this.isEmail = false,
    this.isPhone = false,
    this.isNumber = false,
    this.controller,
    required this.prefixIcon,
    this.suffixIcon,
    this.isHidden = true,
    this.padding = 8.0,
    String? Function(dynamic value)? validator,
  }) : super(key: key);

  @override
  State<BaseTextFormField> createState() => _BaseTextFormFieldState();
}

class _BaseTextFormFieldState extends State<BaseTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding ?? 8.0),
      child: TextFormField(
        obscureText: widget.isHidden && widget.isPassword,
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          labelText: widget.hintText,
          floatingLabelStyle: const TextStyle(
            height: 4,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.isHidden = !widget.isHidden;
                    });
                  },
                  icon: widget.isHidden
                      ? const Icon(Icons.remove_red_eye_rounded)
                      : const Icon(Icons.remove_red_eye_outlined))
              : null,
        ),
      ),
    );
  }
}
