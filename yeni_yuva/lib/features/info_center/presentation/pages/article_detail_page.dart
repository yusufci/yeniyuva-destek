import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  final String slug;

  const ArticleDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Makale Detayı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Örnek Makale Başlığı',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Yayınlanma: 01.03.2026',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Bu bir örnek makale içeriğidir. Supabase entegrasyonu sonrasında '
              'gerçek içerikler burada görüntülenecektir.\n\n'
              'Makale slug: $slug',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}