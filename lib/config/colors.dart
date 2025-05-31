import 'package:flutter/material.dart';

class AppColors {
  // 1. Colores base (neutrales)
  static const Color lightBackground = Color(0xFFF9FAFB); // Fondo claro
  static const Color darkBackground = Color(0xFF1E1E2D); // Fondo oscuro
  static const Color primaryText = Color(
    0xFF1F2937,
  ); // Texto primario (gris oscuro)
  static const Color secondaryText = Color(
    0xFF6B7280,
  ); // Texto secundario (gris medio)

  // 2. Colores primarios (identidad de la app)
  static const Color primaryColor = Color.fromARGB(
    255,
    34,
    82,
    185,
  ); // Azul moderno
  static const Color lightprimaryColor = Color.fromARGB(
    255,
    227,
    235,
    253,
  ); // Azul moderno
  static const Color alternativeColor1 = Color(0xFF10B981); // Verde pro (éxito)
  static const Color alternativeColor2 = Color(
    0xFFF97316,
  ); // Naranja energético

  // 3. Colores de acento / éxito / advertencia
  static const Color successColor = Color(
    0xFF22C55E,
  ); // Éxito (verde brillante)
  static const Color errorColor = Color(0xFFEF4444); // Error (rojo moderno)
  static const Color warningColor = Color(
    0xFFFACC15,
  ); // Advertencia (amarillo cálido)
  static const Color infoColor = Color(0xFF3B82F6); // Info (azul claro)

  // 4. Bordes y tarjetas
  static const Color borderColor = Color(0xFFE5E7EB); // Bordes suaves
  static const Color cardBackgroundLight = Color(
    0xFFFFFFFF,
  ); // Fondo de tarjetas (modo claro)
  static const Color cardBackgroundDark = Color(
    0xFF2A2A3B,
  ); // Fondo de tarjetas (modo oscuro)
}
