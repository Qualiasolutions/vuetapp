/// Model representing a shopping list
class ShoppingList {
  final String id;
  final String name;
  final List<String> members;
  final int itemsTotal;
  final int itemsCompleted;
  final DateTime updatedAt;

  ShoppingList({
    required this.id,
    required this.name,
    required this.members,
    this.itemsTotal = 0,
    this.itemsCompleted = 0,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'],
      name: json['name'],
      members: List<String>.from(json['members'] ?? []),
      itemsTotal: json['items_total'] ?? 0,
      itemsCompleted: json['items_completed'] ?? 0,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'items_total': itemsTotal,
      'items_completed': itemsCompleted,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    List<String>? members,
    int? itemsTotal,
    int? itemsCompleted,
    DateTime? updatedAt,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      itemsTotal: itemsTotal ?? this.itemsTotal,
      itemsCompleted: itemsCompleted ?? this.itemsCompleted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model representing a shopping list item
class ShoppingListItem {
  final String id;
  final String list;
  final String? store;
  final String title;
  final bool checked;
  final String? notes;

  ShoppingListItem({
    required this.id,
    required this.list,
    this.store,
    required this.title,
    required this.checked,
    this.notes,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'],
      list: json['list'],
      store: json['store'],
      title: json['title'],
      checked: json['checked'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list': list,
      'store': store,
      'title': title,
      'checked': checked,
      'notes': notes,
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? list,
    String? store,
    String? title,
    bool? checked,
    String? notes,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      list: list ?? this.list,
      store: store ?? this.store,
      title: title ?? this.title,
      checked: checked ?? this.checked,
      notes: notes ?? this.notes,
    );
  }
}

/// Model representing a shopping list store
class ShoppingListStore {
  final String id;
  final String name;
  final String createdBy;

  ShoppingListStore({
    required this.id,
    required this.name,
    required this.createdBy,
  });

  factory ShoppingListStore.fromJson(Map<String, dynamic> json) {
    return ShoppingListStore(
      id: json['id'],
      name: json['name'],
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_by': createdBy,
    };
  }

  ShoppingListStore copyWith({
    String? id,
    String? name,
    String? createdBy,
  }) {
    return ShoppingListStore(
      id: id ?? this.id,
      name: name ?? this.name,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

/// Model representing a shopping list delegation
class ShoppingListDelegation {
  final String id;
  final String delegator;
  final String delegatee;
  final String store;
  final String list;
  final String storeName;
  final String listName;

  ShoppingListDelegation({
    required this.id,
    required this.delegator,
    required this.delegatee,
    required this.store,
    required this.list,
    required this.storeName,
    required this.listName,
  });

  factory ShoppingListDelegation.fromJson(Map<String, dynamic> json) {
    return ShoppingListDelegation(
      id: json['id'],
      delegator: json['delegator'],
      delegatee: json['delegatee'],
      store: json['store'],
      list: json['list'],
      storeName: json['store_name'],
      listName: json['list_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delegator': delegator,
      'delegatee': delegatee,
      'store': store,
      'list': list,
      'store_name': storeName,
      'list_name': listName,
    };
  }

  ShoppingListDelegation copyWith({
    String? id,
    String? delegator,
    String? delegatee,
    String? store,
    String? list,
    String? storeName,
    String? listName,
  }) {
    return ShoppingListDelegation(
      id: id ?? this.id,
      delegator: delegator ?? this.delegator,
      delegatee: delegatee ?? this.delegatee,
      store: store ?? this.store,
      list: list ?? this.list,
      storeName: storeName ?? this.storeName,
      listName: listName ?? this.listName,
    );
  }
}
