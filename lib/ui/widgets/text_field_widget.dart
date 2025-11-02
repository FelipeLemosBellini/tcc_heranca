import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/ui/helpers/app_colors.dart';
import 'package:tcc/ui/helpers/app_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final EdgeInsets? padding;
  final int? maxLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool onlyNumber;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    required this.controller,
    required this.focusNode,
    this.padding,
    this.maxLines,
    this.obscureText = false,
    this.onlyNumber = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool showText = false;

  @override
  void initState() {
    super.initState();
    showText = widget.obscureText;
    widget.focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary7,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow:
              !widget.focusNode.hasFocus
                  ? []
                  : [
                    BoxShadow(
                      color: AppColors.primaryLight.withOpacity(0.2),
                      blurRadius: 25,
                      spreadRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                  ],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged ?? (_) {},
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: AppFonts.labelSmallLight,
          inputFormatters: [
            ...?widget.inputFormatters,
            if (widget.onlyNumber)
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
          ],
          decoration: InputDecoration(
            fillColor: AppColors.primary7,
            alignLabelWithHint: true,
            hintText: widget.hintText,
            hintStyle: AppFonts.labelSmallLight.copyWith(
              color: widget.focusNode.hasFocus ? AppColors.gray4 : AppColors.white,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(strokeAlign: 1, color: AppColors.gray7, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(strokeAlign: 1, color: AppColors.gray, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(strokeAlign: 1, color: AppColors.primary2, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                strokeAlign: 1,
                style: BorderStyle.solid,
                color: AppColors.primary2,
                width: 1,
              ),
            ),
            focusColor: AppColors.primary2,
            isDense: true,
            suffixIcon: Visibility(
              visible: widget.obscureText,
              child: GestureDetector(
                onTap: setVisibilityEye,
                child: Icon(
                  showText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          maxLines: widget.maxLines ?? 1,
          obscureText: showText,
        ),
      ),
    );
  }

  void setVisibilityEye() {
    setState(() {
      showText = !showText;
    });
  }
}
