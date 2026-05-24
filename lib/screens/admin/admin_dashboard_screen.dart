import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../services/api_client.dart';

class PendingRecipe {
  final String id;
  final String name;
  final String username;
  final DateTime savedAt;
  final String? imageUrl;

  PendingRecipe({
    required this.id,
    required this.name,
    required this.username,
    required this.savedAt,
    this.imageUrl,
  });

  factory PendingRecipe.fromJson(Map<String, dynamic> json) {
    return PendingRecipe(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  List<PendingRecipe> _pending = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPending();
  }

  Future<void> _fetchPending() async {
    setState(() => _loading = true);
    try {
      final response = await ApiClient().get('/admin/pending');
      final List<dynamic> data = response.data;
      setState(() {
        _pending = data.map((e) => PendingRecipe.fromJson(e as Map<String, dynamic>)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load pending recipes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Approvals')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _pending.isEmpty
              ? const Center(child: Text('No pending recipes'))
              : RefreshIndicator(
                  onRefresh: _fetchPending,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pending.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = _pending[index];
                      return ListTile(
                        leading: item.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(Icons.restaurant, size: 48),
                                ),
                              )
                            : const Icon(Icons.restaurant, size: 48),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          '${item.username} · ${item.savedAt.day}/${item.savedAt.month}/${item.savedAt.year}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/admin-recipe', extra: item.id),
                      );
                    },
                  ),
                ),
    );
  }
}
