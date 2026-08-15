class ReferralTreeModel {
  final int id;
  final String name;
  final List<ReferralTreeModel> children;

  ReferralTreeModel({
    required this.id,
    required this.name,
    required this.children,
  });

  factory ReferralTreeModel.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'] as List<dynamic>? ?? [];
    List<ReferralTreeModel> childrenList = childrenJson
        .map((e) => ReferralTreeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ReferralTreeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      children: childrenList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}
