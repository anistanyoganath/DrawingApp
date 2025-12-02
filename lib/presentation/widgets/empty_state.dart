import 'package:aidrawing/core/constants/app_styles.dart';
import 'package:aidrawing/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.buttonText = 'Get Started',
    this.onButtonPressed,
    this.icon = '🎨',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 48)),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              title,
              style: AppStyles.heading2.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: AppStyles.body.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

            if (onButtonPressed != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                child: PrimaryButton(
                  text: buttonText,
                  onPressed: onButtonPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
