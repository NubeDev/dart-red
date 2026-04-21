import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

/// Whether the editor is currently in dark mode.
///
/// fl_nodes style builders don't receive BuildContext, so we use this static
/// flag. [FlowEditorScreen] updates it on every build and calls
/// `controller.setStyle()` when the theme changes.
bool editorIsDark = true;

// ─── Canvas / editor style ──────────────────────────────────────────────────

/// Build the editor canvas style for the current theme.
FlNodeEditorStyle rubixEditorStyleFor(bool isDark) {
  return FlNodeEditorStyle(
    decoration: BoxDecoration(
      color: isDark ? RubixTokens.bgDeep : RubixTokens.lightBgDeep,
    ),
    gridStyle: FlGridStyle(
      gridSpacingX: 48,
      gridSpacingY: 48,
      lineWidth: 0.5,
      lineColor: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.06),
      intersectionColor: isDark
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.black.withValues(alpha: 0.10),
      intersectionRadius: 1.0,
      showGrid: true,
    ),
    highlightAreaStyle: FlHighlightAreaStyle(
      color: RubixTokens.accentCool.withValues(alpha: 0.06),
      borderWidth: 1.5,
      borderColor: RubixTokens.accentCool.withValues(alpha: 0.5),
      borderDrawMode: FlLineDrawMode.dashed,
    ),
  );
}

// ─── Node body style ────────────────────────────────────────────────────────

/// Node body style builder — tonal surface shifts, ghost borders only.
FlNodeStyle rubixNodeStyleBuilder(FlNodeState state) {
  final bg = editorIsDark
      ? RubixTokens.surfaceBright
      : RubixTokens.lightSurfaceMatte;
  const radius = BorderRadius.all(Radius.circular(RubixTokens.radiusCard));

  // Ghost border — just a suggestion of a container
  final ghostBorder = BorderSide(
    color: editorIsDark
        ? RubixTokens.ghostBorderDark
        : RubixTokens.ghostBorderLight,
    width: 0.5,
  );

  if (state.isSelected) {
    return FlNodeStyle(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: Border.fromBorderSide(
          BorderSide(
            color: RubixTokens.accentCool.withValues(alpha: 0.7),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: RubixTokens.accentCool.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  if (state.isHovered) {
    return FlNodeStyle(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: Border.fromBorderSide(
          BorderSide(
            color: RubixTokens.accentCool.withValues(alpha: 0.3),
            width: 1.0,
          ),
        ),
      ),
    );
  }

  return FlNodeStyle(
    decoration: BoxDecoration(
      color: bg,
      borderRadius: radius,
      border: Border.fromBorderSide(ghostBorder),
    ),
  );
}

/// Field style — recessed data well inside nodes.
FlFieldStyle get rubixFieldStyle => FlFieldStyle(
      decoration: BoxDecoration(
        color: editorIsDark
            ? RubixTokens.surfaceWell
            : RubixTokens.lightSurfaceWell,
        borderRadius:
            const BorderRadius.all(Radius.circular(RubixTokens.radiusPill)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
