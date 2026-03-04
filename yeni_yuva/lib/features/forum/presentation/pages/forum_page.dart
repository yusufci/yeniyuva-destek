import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_display_widget.dart';
import '../../domain/entities/thread_entity.dart';
import '../providers/forum_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ForumPage extends ConsumerStatefulWidget {
  const ForumPage({super.key});

  @override
  ConsumerState<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends ConsumerState<ForumPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _categories = ['Tümü', 'Genel', 'Soru-Cevap', 'Deneyimler', 'Duyurular'];

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
    final forumState = ref.watch(forumProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Topluluk Forumu', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search, color: AppColors.textSecondary), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Konular'), Tab(text: 'Popüler')],
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
                  final selectedCat = forumState.selectedCategory;
                  final isSelected = (cat == 'Tümü' && selectedCat == null) || selectedCat == cat.toLowerCase();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.grey.shade100,
                      onSelected: (_) {
                        ref.read(forumProvider.notifier).setCategory(cat == 'Tümü' ? null : cat.toLowerCase());
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Konu listesi
          Expanded(
            child: forumState.isLoading
                ? const LoadingWidget(message: 'Konular yükleniyor...')
                : forumState.error != null
                    ? ErrorDisplayWidget(
                        message: 'Konular yüklenemedi',
                        details: forumState.error,
                        onRetry: () => ref.read(forumProvider.notifier).refresh(),
                      )
                    : forumState.threads.isEmpty
                        ? const EmptyStateWidget(message: 'Henüz konu bulunmuyor', icon: Icons.forum_outlined, subtitle: 'İlk konuyu siz açın!')
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildThreadList(forumState.threads),
                              _buildThreadList(List.from(forumState.threads)..sort((a, b) => b.voteCount.compareTo(a.voteCount))),
                            ],
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewThreadDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit),
        label: const Text('Yeni Konu'),
      ),
    );
  }

  Widget _buildThreadList(List<ThreadEntity> threads) {
    return RefreshIndicator(
      onRefresh: () => ref.read(forumProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: threads.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _buildThreadCard(threads[index]),
      ),
    );
  }

  Widget _buildThreadCard(ThreadEntity thread) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: thread.isPinned ? AppColors.accent.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Konu detay sayfası
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
                    Text('Sabitlenmiş', style: TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                  ],
                  if (thread.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(thread.category!, style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w500)),
                    ),
                  const Spacer(),
                  Text(timeago.format(thread.createdAt, locale: 'tr'), style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                ],
              ),
              const SizedBox(height: 10),
              Text(thread.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      (thread.authorName ?? 'U')[0].toUpperCase(),
                      style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(thread.authorName ?? 'Kullanıcı', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const Spacer(),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.arrow_upward, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text('${thread.voteCount}', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(width: 12),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text('${thread.replyCount}', style: TextStyle(fontSize: 12, color: AppColors.secondary, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewThreadDialog(BuildContext context) {
    final isAuth = ref.read(authProvider).status == AuthStatus.authenticated;
    if (!isAuth) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Konu açmak için giriş yapmalısınız'), backgroundColor: AppColors.warning, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('Yeni Konu Oluştur', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(controller: titleController, decoration: const InputDecoration(labelText: 'Konu Başlığı', hintText: 'Sorunuzu veya konunuzu yazın...')),
              const SizedBox(height: 12),
              TextFormField(controller: bodyController, maxLines: 4, decoration: const InputDecoration(labelText: 'İçerik', hintText: 'Detayları buraya yazın...', alignLabelWithHint: true)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: _categories.where((c) => c != 'Tümü').map((c) => DropdownMenuItem(value: c.toLowerCase(), child: Text(c))).toList(),
                onChanged: (v) => selectedCategory = v,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty || bodyController.text.isEmpty) return;
                    await ref.read(forumProvider.notifier).createThread(
                      title: titleController.text,
                      body: bodyController.text,
                      category: selectedCategory,
                    );
                    if (context.mounted) Navigator.pop(context);
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