
/// Model representing a planning list
class PlanningList {
  final String id;
  final String category;
  final String name;
  final List<String> members;
  final int sublistCount;
  final DateTime updatedAt;

  PlanningList({
    required this.id,
    required this.category,
    required this.name,
    required this.members,
    this.sublistCount = 0,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory PlanningList.fromJson(Map<String, dynamic> json) {
    return PlanningList(
      id: json['id'],
      category: json['category'],
      name: json['name'],
      members: List<String>.from(json['members'] ?? []),
      sublistCount: json['sublist_count'] ?? 0,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'members': members,
      'sublist_count': sublistCount,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PlanningList copyWith({
    String? id,
    String? category,
    String? name,
    List<String>? members,
    int? sublistCount,
    DateTime? updatedAt,
  }) {
    return PlanningList(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      members: members ?? this.members,
      sublistCount: sublistCount ?? this.sublistCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model representing a planning sublist
class PlanningSublist {
  final String id;
  final String list;
  final String title;
  final int? itemsTotal;
  final int? itemsCompleted;

  PlanningSublist({
    required this.id,
    required this.list,
    required this.title,
    this.itemsTotal = 0,
    this.itemsCompleted = 0,
  });

  factory PlanningSublist.fromJson(Map<String, dynamic> json) {
    return PlanningSublist(
      id: json['id'],
      list: json['list'],
      title: json['title'],
      itemsTotal: json['items_total'] ?? 0,
      itemsCompleted: json['items_completed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list': list,
      'title': title,
      'items_total': itemsTotal,
      'items_completed': itemsCompleted,
    };
  }

  PlanningSublist copyWith({
    String? id,
    String? list,
    String? title,
    int? itemsTotal,
    int? itemsCompleted,
  }) {
    return PlanningSublist(
      id: id ?? this.id,
      list: list ?? this.list,
      title: title ?? this.title,
      itemsTotal: itemsTotal ?? this.itemsTotal,
      itemsCompleted: itemsCompleted ?? this.itemsCompleted,
    );
  }
}

/// Model representing a planning list item
class PlanningListItem {
  final String id;
  final String sublist;
  final String title;
  final bool checked;

  PlanningListItem({
    required this.id,
    required this.sublist,
    required this.title,
    required this.checked,
  });

  factory PlanningListItem.fromJson(Map<String, dynamic> json) {
    return PlanningListItem(
      id: json['id'],
      sublist: json['sublist'],
      title: json['title'],
      checked: json['checked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sublist': sublist,
      'title': title,
      'checked': checked,
    };
  }

  PlanningListItem copyWith({
    String? id,
    String? sublist,
    String? title,
    bool? checked,
  }) {
    return PlanningListItem(
      id: id ?? this.id,
      sublist: sublist ?? this.sublist,
      title: title ?? this.title,
      checked: checked ?? this.checked,
    );
  }
}
