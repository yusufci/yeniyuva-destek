import 'package:flutter/material.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilgi Merkezi'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategorySection(context, 'Türkiye\'de Yaşam', Icons.public, [
            'Oturma İzni Nasıl Alınır?',
            'Bankacılık İşlemleri Rehberi',
            'Ulaşım Sistemi Hakkında',
          ]),
          _buildCategorySection(context, 'Eğitim Sistemi', Icons.school, [
            'Okul Kaydı Nasıl Yapılır?',
            'Denklik İşlemleri',
            'Burs Olanakları',
          ]),
          _buildCategorySection(context, 'Sağlık Sistemi', Icons.local_hospital, [
            'Randevu Alma Rehberi',
            'Acil Servis Bilgileri',
            'Sağlık Sigortası',
          ]),
          _buildCategorySection(context, 'Çalışma Hayatı', Icons.work, [
            'Çalışma İzni Nasıl Alınır?',
            'İş Arama Yöntemleri',
            'İşçi Hakları',
          ]),
          _buildCategorySection(context, 'Hukuki Haklar', Icons.gavel, [
            'Mülteci Statüsü Nedir?',
            'Hak ve Yükümlülükler',
            'Hukuki Danışmanlık',
          ]),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, IconData icon, List<String> articles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        ...articles.map((article) => Card(
          child: ListTile(
            title: Text(article),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to article detail
            },
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}