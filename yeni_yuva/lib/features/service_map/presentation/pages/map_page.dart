import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hizmet Haritası'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Arama
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // TODO: Google Maps widget gelecek
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Harita yükleniyor...',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Google Maps API key gerekli',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          // Kategori chip'leri
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
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
        onPressed: () {
          // TODO: Konumuma git
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: false,
        onSelected: (selected) {
          // TODO: Filtre uygula
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