import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    this.inputAction,
    required this.controller,
    this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.helper,
    this.onChanged,
    this.onTap,
    this.validator,
    this.obscureText = false,
    this.suffix,
    this.maxLines = 1,
    Key? key,
    this.labelText,
  }) : super(key: key);

  final TextInputAction? inputAction;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Icon? prefixIcon;
  final String? helper;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3B8B8B8B),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        textInputAction: inputAction,
        obscureText: obscureText,
        minLines: 1,
        maxLines: maxLines,
        textDirection: TextDirection.rtl,
        // enableInteractiveSelection: true,
        scrollPhysics: const BouncingScrollPhysics(),
        scrollController: ScrollController(
          keepScrollOffset: true,
        ),
        style: const TextStyle(
          fontSize: 19.5,
          height: 1.5,
          fontWeight: FontWeight.w600,
          color: Color(0x7CFF0028),
          // color: pinkColor,
        ),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 18,
          ),
          filled: true,
          fillColor: Colors.white,
          suffix: suffix,
          suffixStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0x7CFF0028),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: const BorderSide(
              color: Color(0x7CFF0028),
              width: 2.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            borderSide: const BorderSide(
              color: Color(0x7CFF0028),
              width: 2.2,
            ),
          ),
          errorMaxLines: 2,
          errorStyle: const TextStyle(
            color: Color(0x7CFF0028),
            fontWeight: FontWeight.bold,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0x7C323F48),
          ),
          labelText: labelText,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: 15.sp,
                    end: 12.sp,
                  ),
                  child: prefixIcon,
                )
              : null,
          helperText: helper,
          helperMaxLines: 4,
          helperStyle: TextStyle(
            color: const Color(0x7CFF0028),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.sp),
            gapPadding: 10,
          ),
        ),
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
      ),
    );
  }
}
