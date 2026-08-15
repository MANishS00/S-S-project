import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final int currentStep;

  const StatusWidget({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStep(
              number: 1,
              title: "Summary",
              isCompleted: currentStep > 1,
              isCurrent: currentStep == 1,
            ),
          ),
          _buildLine(currentStep > 1),
          Expanded(
            child: _buildStep(
              number: 2,
              title: "Payment",
              isCompleted: currentStep > 2,
              isCurrent: currentStep == 2,
            ),
          ),
          _buildLine(currentStep > 2),
          Expanded(
            child: _buildStep(
              number: 3,
              title: "Order",
              isCompleted: false,
              isCurrent: currentStep == 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted || isCurrent
                ? Colors.black
                : Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    size: 18,
                    color: Colors.white,
                  )
                : Text(
                    "$number",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrent
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight:
                isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 22),
        color: active ? Colors.black : Colors.black26,
      ),
    );
  }
}