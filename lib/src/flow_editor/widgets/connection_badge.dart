import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

class ConnectionBadge extends StatelessWidget {
  final bool connected;
  const ConnectionBadge({super.key, required this.connected});

  @override
  Widget build(BuildContext context) {
    final color =
        connected ? RubixTokens.statusSuccess : RubixTokens.statusError;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(RubixTokens.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            connected ? 'CONNECTED' : 'OFFLINE',
            style: RubixTokens.mono(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
