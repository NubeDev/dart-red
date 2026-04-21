import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

import 'editor_theme.dart' show editorIsDark;
import 'node_icons.dart';

/// Deterministic colour derived from any domain string.
///
/// Uses the string's hash code to pick a hue so every domain gets a
/// distinct, stable colour without the editor knowing what domains exist.
Color colorForDomain(String domain) {
  final hue = (domain.hashCode % 360).abs().toDouble();
  return HSLColor.fromAHSL(1.0, hue, 0.50, 0.42).toColor();
}

/// Build a header style builder for a given domain string and optional icon.
///
/// Returns a function compatible with FlNodePrototype.headerStyleBuilder.
/// Uses a subtle left-edge accent + transparent gradient for editorial feel.
FlNodeHeaderStyle Function(FlNodeState) headerStyleForDomain(
  String domain, {
  String? iconName,
}) {
  final color = colorForDomain(domain);
  final icon = iconName != null ? resolveNodeIcon(iconName) : resolveNodeIcon('circle-dot');
  return (FlNodeState state) => FlNodeHeaderStyle(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.25), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(RubixTokens.radiusCard),
            topRight: Radius.circular(RubixTokens.radiusCard),
          ),
        ),
        textStyle: RubixTokens.heading(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: editorIsDark
              ? RubixTokens.inkPrimary
              : RubixTokens.lightInkPrimary,
          letterSpacing: 0.5,
        ),
        icon: icon,
      );
}
