import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class QuickToolsWidget extends StatelessWidget {
  const QuickToolsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Kullanışlı Araçlar',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickToolCard(
                icon: Icons.translate,
                label: 'Çeviri',
                color: AppColors.secondary,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickToolCard(
                icon: Icons.health_and_safety,
                label: 'Sağlık\nRehberi',
                color: AppColors.categoryHealth,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickToolCard(
                icon: Icons.directions_bus,
                label: 'Ulaşım\nBilgileri',
                color: AppColors.categoryEmployment,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickToolCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}