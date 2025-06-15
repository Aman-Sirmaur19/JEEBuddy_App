class ResourceItem {
  final String bottomTab;
  final String tab;
  final String section;
  final String subSection;
  final String name;
  final String url;

  ResourceItem({
    required this.bottomTab,
    required this.tab,
    required this.section,
    required this.subSection,
    required this.name,
    required this.url,
  });

  factory ResourceItem.fromList(List<dynamic> row) {
    return ResourceItem(
      bottomTab: row[1] ?? '',
      tab: row[2] ?? '',
      section: row[3] ?? '',
      subSection: row[4] ?? '',
      name: row[5] ?? '',
      url: row.length > 6 ? row[6] ?? '' : '',
    );
  }
}
