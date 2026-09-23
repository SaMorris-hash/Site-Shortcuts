import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/site_shortcut.dart';
import '../services/storage_service.dart';
import 'edit_shortcut_screen.dart';
import '../utils/site_url.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  List<SiteShortcut> _shortcuts = [];
  bool _editMode = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await _storage.loadShortcuts();

    if (!mounted) return;

    setState(() {
      _shortcuts = list;
      _loading = false;
    });
  }

  Future<void> _openSite(SiteShortcut shortcut) async {
    final uri = parseSiteUrl(shortcut.url);

    if (uri == null) {
      _showMessage('That web address doesn\'t look valid.');
      return;
    }

    try {
      final launched =
          await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched) {
        _showMessage('Could not open a browser for this site.');
      }
    } catch (_) {
      _showMessage('Could not open a browser for this site.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 18))),
    );
  }

  Future<void> _addShortcut() async {
    final result = await Navigator.of(context).push<SiteShortcut>(
      MaterialPageRoute(builder: (_) => const EditShortcutScreen()),
    );
    if (result != null && mounted) {
      setState(() => _shortcuts.add(result));
      await _storage.saveShortcuts(_shortcuts);
    }
  }

  Future<void> _editShortcut(SiteShortcut shortcut) async {
    final result = await Navigator.of(context).push<SiteShortcut>(
      MaterialPageRoute(builder: (_) => EditShortcutScreen(existing: shortcut)),
    );
    if (result != null && mounted) {
      setState(() {
        final index = _shortcuts.indexWhere((s) => s.id == shortcut.id);
        if (index != -1) _shortcuts[index] = result;
      });
      await _storage.saveShortcuts(_shortcuts);
    }
  }

  Future<void> _deleteShortcut(SiteShortcut shortcut) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove shortcut?', style: TextStyle(fontSize: 22)),
        content: Text('Remove "${shortcut.name}"?',
            style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(fontSize: 18)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove',
                style: TextStyle(fontSize: 18, color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _shortcuts.removeWhere((s) => s.id == shortcut.id));
      await _storage.saveShortcuts(_shortcuts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sites',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            iconSize: 32,
            tooltip: _editMode ? 'Done editing' : 'Edit shortcuts',
            icon: Icon(_editMode ? Icons.check_circle : Icons.edit),
            onPressed: () => setState(() => _editMode = !_editMode),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _shortcuts.isEmpty
              ? _buildEmptyState(context)
              : _buildGrid(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addShortcut,
        icon: const Icon(Icons.add, size: 28),
        label: const Text('Add site', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          'No sites yet.\nTap "Add site" below to get started.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: _shortcuts.length,
      itemBuilder: (context, index) {
        final shortcut = _shortcuts[index];
        return _ShortcutTile(
          shortcut: shortcut,
          editMode: _editMode,
          onTap: () =>
              _editMode ? _editShortcut(shortcut) : _openSite(shortcut),
          onDelete: () => _deleteShortcut(shortcut),
        );
      },
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final SiteShortcut shortcut;
  final bool editMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ShortcutTile({
    required this.shortcut,
    required this.editMode,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final initial =
        shortcut.name.isNotEmpty ? shortcut.name[0].toUpperCase() : '?';
    return Semantics(
      button: true,
      label: editMode
          ? 'Edit ${shortcut.name}'
          : 'Open ${shortcut.name} in browser',
      child: Material(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        initial,
                        style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      shortcut.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              if (editMode)
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    iconSize: 28,
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Remove ${shortcut.name}',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
