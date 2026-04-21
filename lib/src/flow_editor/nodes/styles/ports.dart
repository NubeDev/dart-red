import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

/// Port styles for the BMS flow editor — Rubix-themed.
///
/// Data ports = circle (accent warm/orange), Control ports = triangle (accent cool/teal).
class PortStyles {
  static const _dataColor = RubixTokens.accentHeat;
  static const _dataHover = Color(0xFFFFD54F);
  static const _ctrlColor = RubixTokens.accentCool;
  static const _ctrlHover = Color(0xFF9DE8F0);
  static const _ctrlInputColor = RubixTokens.statusInfo;
  static const _ctrlInputHover = Color(0xFF93C5FD);

  // -- Data ports --

  static FlPortStyle dataOutput(FlPortState state) => FlPortStyle(
        color: state.isHovered ? _dataHover : _dataColor,
        shape: FlPortShape.circle,
        radius: state.isHovered ? 6 : 5,
        linkStyleBuilder: (linkState) => FlLinkStyle(
          color: linkState.isSelected
              ? _dataHover
              : linkState.isHovered
                  ? _dataHover
                  : _dataColor,
          lineWidth: linkState.isSelected ? 3.5 : 2.5,
          drawMode: FlLineDrawMode.solid,
          curveType: FlLinkCurveType.bezier,
        ),
      );

  static FlPortStyle dataInput(FlPortState state) => FlPortStyle(
        color: state.isHovered ? _dataHover : _dataColor,
        shape: FlPortShape.circle,
        radius: state.isHovered ? 6 : 5,
        linkStyleBuilder: (linkState) => FlLinkStyle(
          color: linkState.isSelected
              ? _dataHover
              : linkState.isHovered
                  ? _dataHover
                  : _dataColor,
          lineWidth: linkState.isSelected ? 3.5 : 2.5,
          drawMode: FlLineDrawMode.solid,
          curveType: FlLinkCurveType.bezier,
        ),
      );

  // -- Control ports --

  static FlPortStyle controlOutput(FlPortState state) => FlPortStyle(
        color: state.isHovered ? _ctrlHover : _ctrlColor,
        shape: FlPortShape.triangle,
        radius: state.isHovered ? 6 : 5,
        linkStyleBuilder: (linkState) => FlLinkStyle(
          color: linkState.isSelected
              ? _ctrlHover
              : linkState.isHovered
                  ? _ctrlHover
                  : _ctrlColor,
          lineWidth: linkState.isSelected ? 3.5 : 2.5,
          drawMode: FlLineDrawMode.solid,
          curveType: FlLinkCurveType.bezier,
        ),
      );

  static FlPortStyle controlInput(FlPortState state) => FlPortStyle(
        color: state.isHovered ? _ctrlInputHover : _ctrlInputColor,
        shape: FlPortShape.triangle,
        radius: state.isHovered ? 6 : 5,
        linkStyleBuilder: (linkState) => FlLinkStyle(
          color: linkState.isSelected
              ? _ctrlInputHover
              : linkState.isHovered
                  ? _ctrlInputHover
                  : _ctrlInputColor,
          lineWidth: linkState.isSelected ? 3.5 : 2.5,
          drawMode: FlLineDrawMode.solid,
          curveType: FlLinkCurveType.bezier,
        ),
      );
}
