import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged ?? (_) {},
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          labelText: widget.hintText,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
          suffixIcon: Visibility(
            visible: widget.obscureText,
            child: GestureDetector(
              onTap: setVisibilityEye,
              child: Icon(
                showText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
            ),
          ),
        ),
        maxLines: widget.maxLines ?? 1,
        obscureText: showText,
      ),
    );
  }

  void setVisibilityEye() {
    setState(() {
      showText = !showText;
    });
  }
}
