import 'package:flutter/material.dart';

class FormProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const FormProgressIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < totalSteps; i++) ...[
              _buildStepCircle(i),
              if (i < totalSteps - 1) _buildConnector(i),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            for (int i = 0; i < totalSteps; i++)
              Expanded(
                child: Text(
                  _getStepTitle(i),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: i <= currentStep
                        ? Colors.blue[600]
                        : Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCircle(int step) {
    final bool isActive = step <= currentStep;
    final bool isCurrent = step == currentStep;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[600] : Colors.grey[300],
        shape: BoxShape.circle,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: step < currentStep
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildConnector(int step) {
    final bool isActive = step < currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[600] : Colors.grey[300],
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Data Pribadi';
      case 1:
        return 'Kelahiran & Kontak';
      case 2:
        return 'Alamat';
      case 3:
        return 'Orang Tua/Wali';
      default:
        return '';
    }
  }
}
