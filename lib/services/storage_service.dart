import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/site_shortcut.dart';

class StorageService {
  static const _key = 'site_shortcuts';

  Future<List<SiteShortcut>> loadShortcuts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list
        .map((e) => SiteShortcut.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveShortcuts(List<SiteShortcut> shortcuts) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(shortcuts.map((s) => s.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
