import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Hizmet Haritası',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.textSecondary),
            onPressed: () {
              _showFilterSheet(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Arama
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Maps Placeholder
          Container(
            color: Colors.grey.shade100,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg',
                    fit: BoxFit.cover,
                    opacity: const AlwaysStoppedAnimation(0.3),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(Icons.map_outlined, size: 64, color: AppColors.primary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Harita Görünümü',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Google Maps API bağlandığında aktif olacak',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Kategori chip'leri
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildCategoryChip('Tümü', Icons.apps, AppColors.primary, isSelected: _selectedCategory == null),
                  _buildCategoryChip('Sağlık', Icons.local_hospital, AppColors.categoryHealth),
                  _buildCategoryChip('Eğitim', Icons.school, AppColors.categoryEducation),
                  _buildCategoryChip('Hukuki', Icons.gavel, AppColors.categoryLegal),
                  _buildCategoryChip('Barınma', Icons.home, AppColors.categoryHousing),
                  _buildCategoryChip('Sosyal', Icons.volunteer_activism, AppColors.categorySocialAid),
                  _buildCategoryChip('İş', Icons.work, AppColors.categoryEmployment),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 4,
        onPressed: () {
          // TODO: Konumuma git
        },
        child: Icon(Icons.my_location, color: AppColors.primary),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color, {bool isSelected = false}) {
    final bool isActive = _selectedCategory == label || isSelected;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        selected: isActive,
        selectedColor: color,
        backgroundColor: Colors.white,
        elevation: isActive ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isActive ? color : Colors.grey.shade300,
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = label == 'Tümü' ? null : label;
          });
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filtreler', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text('Mesafe', style: Theme.of(context).textTheme.titleMedium),
              Slider(value: 10, min: 1, max: 50, divisions: 49, label: '10 km', onChanged: (v) {}),
              const SizedBox(height: 8),
              Text('Konuşulan Dil', style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(label: const Text('Türkçe'), selected: true, onSelected: (v) {}),
                  FilterChip(label: const Text('Arapça'), selected: false, onSelected: (v) {}),
                  FilterChip(label: const Text('İngilizce'), selected: false, onSelected: (v) {}),
                  FilterChip(label: const Text('Farsça'), selected: false, onSelected: (v) {}),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Uygula')),
              ),
            ],
          ),
        );
      },
    );
  }
}