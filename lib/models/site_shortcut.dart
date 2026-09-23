class SiteShortcut {
  final String id;
  String name;
  String url;

  SiteShortcut({
    required this.id,
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
      };

  factory SiteShortcut.fromJson(Map<String, dynamic> json) => SiteShortcut(
        id: json['id'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
      );
}
