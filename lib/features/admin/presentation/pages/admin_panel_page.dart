import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';

class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({super.key});

  @override
  ConsumerState<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.location_on), text: 'Hizmetler'),
            Tab(icon: Icon(Icons.article), text: 'Makaleler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ServiceAdminTab(),
          _ArticleAdminTab(),
        ],
      ),
    );
  }
}

class _ServiceAdminTab extends StatelessWidget {
  const _ServiceAdminTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Hizmet listesi - Supabase entegrasyonu sonrası')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedCategory = ApiConstants.categoryHealth;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Hizmet Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Hizmet Adı (TR)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: [
                  DropdownMenuItem(value: ApiConstants.categoryHealth, child: const Text('Sağlık')),
                  DropdownMenuItem(value: ApiConstants.categoryEducation, child: const Text('Eğitim')),
                  DropdownMenuItem(value: ApiConstants.categoryLegal, child: const Text('Hukuki')),
                  DropdownMenuItem(value: ApiConstants.categoryHousing, child: const Text('Barınma')),
                  DropdownMenuItem(value: ApiConstants.categorySocialAid, child: const Text('Sosyal Yardım')),
                  DropdownMenuItem(value: ApiConstants.categoryEmployment, child: const Text('İş')),
                  DropdownMenuItem(value: ApiConstants.categoryCommunity, child: const Text('Topluluk')),
                ],
                onChanged: (v) => selectedCategory = v ?? selectedCategory,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Adres'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              // TODO: Supabase'e kaydet
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hizmet eklendi (Supabase entegrasyonu gerekli)')),
              );
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}

class _ArticleAdminTab extends StatelessWidget {
  const _ArticleAdminTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Makale listesi - Supabase entegrasyonu sonrası')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddArticleDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddArticleDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = ApiConstants.articleLifeInTurkey;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Makale Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Başlık (TR)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: [
                  DropdownMenuItem(value: ApiConstants.articleLifeInTurkey, child: const Text('Türkiye\'de Yaşam')),
                  DropdownMenuItem(value: ApiConstants.articleEducationSystem, child: const Text('Eğitim Sistemi')),
                  DropdownMenuItem(value: ApiConstants.articleHealthSystem, child: const Text('Sağlık Sistemi')),
                  DropdownMenuItem(value: ApiConstants.articleWorkLife, child: const Text('Çalışma Hayatı')),
                  DropdownMenuItem(value: ApiConstants.articleLegalRights, child: const Text('Hukuki Haklar')),
                ],
                onChanged: (v) => selectedCategory = v ?? selectedCategory,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'İçerik (TR)'),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Makale eklendi (Supabase entegrasyonu gerekli)')),
              );
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}