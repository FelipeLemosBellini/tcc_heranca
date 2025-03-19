import 'package:flutter/material.dart';
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

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.onChanged,
    required this.controller,
    required this.focusNode,
    this.padding,
    this.maxLines,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
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
          color: AppColors.background,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow:
              !widget.focusNode.hasFocus
                  ? []
                  : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2), // Sombra mais definida
                      blurRadius: 25, // Mais difuso
                      spreadRadius: 1, // Aumenta a área da sombra
                      offset: const Offset(0, 0), // Mantém para baixo
                    ),
                  ],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged ?? (_) {},
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: AppFonts.labelMedium,
          decoration: InputDecoration(
            fillColor: AppColors.background,
            alignLabelWithHint: true,
            hintText: widget.hintText,
            hintStyle: AppFonts.labelMedium.copyWith(
              color: widget.focusNode.hasFocus ? AppColors.disable : Colors.white60,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(strokeAlign: 2, color: AppColors.gray, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(strokeAlign: 2, color: AppColors.gray, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(strokeAlign: 2, color: AppColors.lines, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                strokeAlign: 2,
                style: BorderStyle.solid,
                color: AppColors.lines,
                width: 2,
              ),
            ),
            focusColor: AppColors.lines,
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
