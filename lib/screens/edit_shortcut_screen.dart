import 'package:flutter/material.dart';
import '../models/site_shortcut.dart';
import '../utils/site_url.dart';

class EditShortcutScreen extends StatefulWidget {
  final SiteShortcut? existing;

  const EditShortcutScreen({super.key, this.existing});

  @override
  State<EditShortcutScreen> createState() => _EditShortcutScreenState();
}

class _EditShortcutScreenState extends State<EditShortcutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _urlController = TextEditingController(text: widget.existing?.url ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final shortcut = SiteShortcut(
      id: widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      url: _urlController.text.trim(),
    );
    Navigator.of(context).pop(shortcut);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Site' : 'Add Site',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Site name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 22),
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Weather',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 24),
              const Text('Website address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _urlController,
                style: const TextStyle(fontSize: 22),
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'e.g. www.bbc.com/weather',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a website address';
                  }

                  if (parseSiteUrl(value) == null) {
                    return 'Enter a valid website address, such as example.com';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 64,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(isEditing ? 'Save changes' : 'Add site',
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
