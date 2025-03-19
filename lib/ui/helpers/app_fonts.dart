import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppFonts {
  static final Color _defaultColor = Colors.white;

  static TextStyle get headlineLarge =>
      GoogleFonts.tektur(fontSize: 32, color: _defaultColor, fontWeight: FontWeight.bold);

  static TextStyle get headlineMedium =>
      GoogleFonts.tektur(fontSize: 28, color: _defaultColor, fontWeight: FontWeight.bold);

  static TextStyle get headlineSmall =>
      GoogleFonts.tektur(fontSize: 24, color: _defaultColor, fontWeight: FontWeight.bold);

  static TextStyle get labelLarge => GoogleFonts.tektur(
    fontSize: 18,
    color: _defaultColor,
    fontWeight: FontWeight.w600,
  ); // Botões principais
  static TextStyle get labelMedium => GoogleFonts.tektur(
    fontSize: 14,
    color: _defaultColor,
    fontWeight: FontWeight.w500,
  ); // Labels secundárias
  static TextStyle get labelSmall => GoogleFonts.tektur(
    fontSize: 12,
    color: _defaultColor,
    fontWeight: FontWeight.w400,
  ); // Pequenas legendas

  // **Titles** (Seções e subtítulos)
  static TextStyle get titleLarge => GoogleFonts.tektur(
    fontSize: 22,
    color: _defaultColor,
    fontWeight: FontWeight.w600,
  ); // Título de seção
  static TextStyle get titleMedium => GoogleFonts.tektur(
    fontSize: 18,
    color: _defaultColor,
    fontWeight: FontWeight.w500,
  ); // Subtítulo médio
  static TextStyle get titleSmall => GoogleFonts.tektur(
    fontSize: 16,
    color: _defaultColor,
    fontWeight: FontWeight.w500,
  ); // Subtítulo pequeno
}
