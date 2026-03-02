import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

class ForumPage extends ConsumerStatefulWidget {
  const ForumPage({super.key});

  @override
  ConsumerState<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends ConsumerState<ForumPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Tümü';

  final _categories = ['Tümü', 'Genel', 'Soru-Cevap', 'Deneyimler', 'Duyurular'];

  // Mock veriler
  final _mockThreads = [
    _MockThread(
      title: 'Oturma izni yenileme süreci hakkında',
      author: 'Ahmet K.',
      category: 'Soru-Cevap',
      replies: 12,
      votes: 8,
      timeAgo: '2 saat önce',
      isPinned: true,
    ),
    _MockThread(
      title: 'İstanbul\'da ücretsiz Türkçe kursları',
      author: 'Maria S.',
      category: 'Deneyimler',
      replies: 25,
      votes: 34,
      timeAgo: '5 saat önce',
    ),
    _MockThread(
      title: 'İş izni başvurusu yapacaklara tavsiyeler',
      author: 'Hassan M.',
      category: 'Deneyimler',
      replies: 18,
      votes: 22,
      timeAgo: '1 gün önce',
    ),
    _MockThread(
      title: 'Sağlık sigortası nasıl yapılır?',
      author: 'Elena P.',
      category: 'Soru-Cevap',
      replies: 7,
      votes: 11,
      timeAgo: '1 gün önce',
    ),
    _MockThread(
      title: 'Yeni gelen arkadaşlara hoş geldiniz mesajı',
      author: 'Admin',
      category: 'Duyurular',
      replies: 45,
      votes: 67,
      timeAgo: '3 gün önce',
      isPinned: true,
    ),
    _MockThread(
      title: 'Kiralık ev ararken dikkat edilmesi gerekenler',
      author: 'Fatma Y.',
      category: 'Genel',
      replies: 31,
      votes: 28,
      timeAgo: '4 gün önce',
    ),
  ];

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

  List<_MockThread> get _filteredThreads {
    if (_selectedCategory == 'Tümü') return _mockThreads;
    return _mockThreads.where((t) => t.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Topluluk Forumu',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Forum arama
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Konular'),
            Tab(text: 'Popüler'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Kategori filtreleri
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.grey.shade100,
                      onSelected: (_) => setState(() => _selectedCategory = cat),
                    ),
                  );
                },
              ),
            ),
          ),
          // Konu listesi
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildThreadList(_filteredThreads),
                _buildThreadList(
                  List.from(_filteredThreads)..sort((a, b) => b.votes.compareTo(a.votes)),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewThreadDialog(context);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Yeni Konu'),
      ),
    );
  }

  Widget _buildThreadList(List<_MockThread> threads) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: threads.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final thread = threads[index];
        return _buildThreadCard(thread);
      },
    );
  }

  Widget _buildThreadCard(_MockThread thread) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: thread.isPinned
              ? AppColors.accent.withValues(alpha: 0.4)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Konu detayına git
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (thread.isPinned) ...[
                    Icon(Icons.push_pin, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      'Sabitlenmiş',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      thread.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    thread.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                thread.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      thread.author[0],
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    thread.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  _buildStatChip(Icons.arrow_upward, thread.votes.toString(), AppColors.success),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.chat_bubble_outline, thread.replies.toString(), AppColors.secondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showNewThreadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Yeni Konu Oluştur',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Konu Başlığı',
                  hintText: 'Sorunuzu veya konunuzu yazın...',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  hintText: 'Detayları buraya yazın...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                ),
                items: _categories
                    .where((c) => c != 'Tümü')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {},
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Konu oluşturma özelliği yakında aktif olacak!')),
                    );
                  },
                  child: const Text('Paylaş'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MockThread {
  final String title;
  final String author;
  final String category;
  final int replies;
  final int votes;
  final String timeAgo;
  final bool isPinned;

  _MockThread({
    required this.title,
    required this.author,
    required this.category,
    required this.replies,
    required this.votes,
    required this.timeAgo,
    this.isPinned = false,
  });
}