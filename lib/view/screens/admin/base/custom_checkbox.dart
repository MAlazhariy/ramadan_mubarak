import 'package:flutter/material.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final bool value;
  final String title;
  final void Function(bool?)? onChanged;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
        Expanded(
          child: Text(
            widget.title,
            style: kMediumFontStyle.copyWith(
                color: widget.value ? kMainColor : null,
            ),
          ),
        ),
      ],
    );
  }
}
