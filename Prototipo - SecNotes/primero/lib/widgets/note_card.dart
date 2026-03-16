import 'package:flutter/material.dart';
import 'dart:math';

class NoteCard extends StatelessWidget {

  final Map note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {

    final random = Random();
    final rotation = (random.nextDouble() * 0.1) - 0.05;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,

      child: Transform.rotate(
        angle: rotation,

        child: Container(
          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color: Color(note["color"]),
            borderRadius: BorderRadius.circular(16),

            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(4,4),
              )
            ],
          ),

          child: Center(
            child: Text(
              note["content"],
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              ),
          ),
        ),
      ),
    ));
  }
}