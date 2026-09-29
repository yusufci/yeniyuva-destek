import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_display_widget.dart';
import '../providers/service_map_provider.dart';

class ServiceDetailPage extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  ConsumerState<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends ConsumerState<ServiceDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceAsync = ref.watch(serviceDetailProvider(widget.serviceId));
    const imageHeight = 260.0;
    final parallaxOffset = _scrollOffset * 0.4;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: serviceAsync.when(
        loading: () => const Scaffold(body: LoadingWidget(message: 'Hizmet bilgileri yükleniyor...')),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorDisplayWidget(
            message: 'Hizmet bilgileri yüklenemedi',
            details: error.toString(),
            onRetry: () => ref.invalidate(serviceDetailProvider(widget.serviceId)),
          ),
        ),
        data: (service) {
          final name = service.getLocalizedName('tr');
          final desc = service.getLocalizedDescription('tr');
          final address = service.getLocalizedAddress('tr');
          final categoryColor = AppColors.getCategoryColor(service.category);

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: imageHeight,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                foregroundColor: _scrollOffset > imageHeight - 100 ? AppColors.textPrimary : Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Transform.translate(
                        offset: Offset(0, parallaxOffset),
                        child: Container(
                          color: categoryColor.withValues(alpha: 0.2),
                          child: Center(
                            child: Icon(_getCategoryIcon(service.category), size: 80, color: categoryColor.withValues(alpha: 0.5)),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withValues(alpha: 0.2), Colors.black.withValues(alpha: 0.5)],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20, left: 20, right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: categoryColor, borderRadius: BorderRadius.circular(6)),
                              child: Text(_getCategoryLabel(service.category), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                            ),
                            const SizedBox(height: 8),
                            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22, shadows: [Shadow(color: Colors.black38, blurRadius: 8)])),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isFavorite),
                        color: _isFavorite ? AppColors.error : (_scrollOffset > imageHeight - 100 ? AppColors.textSecondary : Colors.white),
                      ),
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                  IconButton(
                    icon: Icon(Icons.share_outlined, color: _scrollOffset > imageHeight - 100 ? AppColors.textSecondary : Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedListItem(
                          index: 0,
                          child: Row(
                            children: [
                              _buildStatusChip('Açık', AppColors.success, Icons.circle),
                              const SizedBox(width: 12),
                              if (service.distanceKm != null)
                                _buildStatusChip('${service.distanceKm!.toStringAsFixed(1)} km', AppColors.secondary, Icons.location_on),
                            ],
                          ),
                        ),
                        if (desc.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          AnimatedListItem(
                            index: 1,
                            child: Text(desc, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.6)),
                          ),
                        ],
                        const SizedBox(height: 24),
                        AnimatedListItem(index: 2, child: const Divider()),
                        const SizedBox(height: 24),
                        if (address.isNotEmpty)
                          AnimatedListItem(index: 3, child: _buildInfoRow(Icons.location_on_outlined, 'Adres', address)),
                        if (service.phone != null) ...[
                          const SizedBox(height: 20),
                          AnimatedListItem(index: 4, child: _buildInfoRow(Icons.phone_outlined, 'İletişim', service.phone!)),
                        ],
                        if (service.spokenLanguages.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          AnimatedListItem(index: 5, child: _buildInfoRow(Icons.language_outlined, 'Desteklenen Diller', service.spokenLanguages.join(', '))),
                        ],
                        if (service.website != null) ...[
                          const SizedBox(height: 20),
                          AnimatedListItem(index: 6, child: _buildInfoRow(Icons.web_outlined, 'Web Sitesi', service.website!)),
                        ],
                        const SizedBox(height: 32),
                        AnimatedListItem(
                          index: 7,
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.phone),
                                  label: const Text('Ara'),
                                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.directions),
                                  label: const Text('Yol Tarifi Al'),
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 4, shadowColor: AppColors.primary.withValues(alpha: 0.3)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.4)),
          ]),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'health': return Icons.local_hospital;
      case 'education': return Icons.school;
      case 'legal': return Icons.gavel;
      case 'housing': return Icons.home;
      case 'social_aid': return Icons.volunteer_activism;
      case 'employment': return Icons.work;
      case 'community': return Icons.people;
      default: return Icons.place;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'health': return 'Sağlık';
      case 'education': return 'Eğitim';
      case 'legal': return 'Hukuki';
      case 'housing': return 'Barınma';
      case 'social_aid': return 'Sosyal Yardım';
      case 'employment': return 'İş';
      case 'community': return 'Topluluk';
      default: return category;
    }
  }
}