import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ColorSelector extends StatelessWidget {
  final AppState appState;

  const ColorSelector({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(AppState.availableColors.length, (index) {
          final color = AppState.availableColors[index];
          final isSelected = appState.selectedColorIndex == index;
          return GestureDetector(
            onTap: () => appState.selectColor(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 44 : 36,
              height: isSelected ? 44 : 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white38,
                  width: isSelected ? 3 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
            ),
          );
        }),
      ),
    );
  }
}
