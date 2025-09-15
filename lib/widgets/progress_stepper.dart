import 'package:flutter/material.dart';

class ProgressStepper extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepTitles;

  const ProgressStepper({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitles,
  }) : super(key: key);

  @override
  State<ProgressStepper> createState() => _ProgressStepperState();
}

class _ProgressStepperState extends State<ProgressStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: List.generate(
              widget.totalSteps,
              (index) => Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getCircleColor(index),
                        boxShadow: [
                          if (index == widget.currentStep)
                            BoxShadow(
                              color: const Color(0xFF00F5FF).withOpacity(0.5),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                      child: Center(
                        child: index < widget.currentStep
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: _getTextColor(index),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ),
                    if (index < widget.totalSteps - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: index < widget.currentStep
                                ? const Color(0xFF00F5FF)
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.stepTitles[widget.currentStep],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Langkah ${widget.currentStep + 1} dari ${widget.totalSteps}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getCircleColor(int index) {
    if (index < widget.currentStep) return const Color(0xFF00F5FF);
    if (index == widget.currentStep) return const Color(0xFF00F5FF);
    return Colors.grey[300]!;
  }

  Color _getTextColor(int index) {
    if (index <= widget.currentStep) return Colors.white;
    return Colors.grey[600]!;
  }
}
