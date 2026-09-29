import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WelcomeHeaderWidget extends StatefulWidget {
  final String userName;

  const WelcomeHeaderWidget({
    super.key,
    required this.userName,
  });

  @override
  State<WelcomeHeaderWidget> createState() => _WelcomeHeaderWidgetState();
}

class _WelcomeHeaderWidgetState extends State<WelcomeHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _illustrationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _illustrationScale;
  late Animation<double> _moonFloat;

  @override
  void initState() {
    super.initState();
    
    // Fade + Slide animasyonu
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    // Illustration animasyonu
    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _illustrationScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _illustrationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _moonFloat = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _illustrationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _illustrationController.forward();
    });
    
    // Moon floating sürekli
    _illustrationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _illustrationController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _illustrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                AppColors.secondary.withValues(alpha: 0.08),
                AppColors.accent.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merhaba, ${widget.userName} 👋',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Yeni Yuvan\'a\nHoş Geldin!',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Animasyonlu illüstrasyon
              AnimatedBuilder(
                animation: _illustrationController,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: _illustrationScale,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.15),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          // Ay (floating)
                          AnimatedBuilder(
                            animation: _moonFloat,
                            builder: (context, child) {
                              return Positioned(
                                top: 8 + (_moonFloat.value * 4),
                                right: 8 + (_moonFloat.value * 2),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.accent.withValues(alpha: 0.6),
                                        AppColors.accent.withValues(alpha: 0.2),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.accent.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Yıldızlar
                          Positioned(
                            top: 20,
                            left: 15,
                            child: _buildStar(6, _moonFloat.value),
                          ),
                          Positioned(
                            top: 35,
                            right: 40,
                            child: _buildStar(4, 1 - _moonFloat.value),
                          ),
                          // Şehir silueti
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBuilding(38, AppColors.secondary.withValues(alpha: 0.35)),
                                _buildBuilding(56, AppColors.primary.withValues(alpha: 0.35)),
                                _buildBuilding(32, AppColors.secondary.withValues(alpha: 0.35)),
                                _buildBuilding(48, AppColors.primary.withValues(alpha: 0.35)),
                                _buildBuilding(28, AppColors.secondary.withValues(alpha: 0.25)),
                              ],
                            ),
                          ),
                          // Aile ikonu
                          Center(
                            child: Icon(
                              Icons.family_restroom,
                              size: 46,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStar(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3 + (opacity * 0.5)),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(double height, Color color) {
    return Container(
      width: 18,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}