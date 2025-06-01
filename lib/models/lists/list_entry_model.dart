/// Model representing a list entry
class ListEntry {
  final String id;
  final String list;
  final String title;
  final bool selected;
  final String? image;
  final String? notes;
  final String? phoneNumber;
  final String? image200x200;
  final String? presignedImageUrl;
  final String? presignedImageUrlLarge;

  ListEntry({
    required this.id,
    required this.list,
    required this.title,
    required this.selected,
    this.image,
    this.notes,
    this.phoneNumber,
    this.image200x200,
    this.presignedImageUrl,
    this.presignedImageUrlLarge,
  });

  factory ListEntry.fromJson(Map<String, dynamic> json) {
    return ListEntry(
      id: json['id'],
      list: json['list'],
      title: json['title'] ?? '',
      selected: json['selected'] ?? false,
      image: json['image'],
      notes: json['notes'],
      phoneNumber: json['phone_number'],
      image200x200: json['image_200_200'],
      presignedImageUrl: json['presigned_image_url'],
      presignedImageUrlLarge: json['presigned_image_url_large'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list': list,
      'title': title,
      'selected': selected,
      'image': image,
      'notes': notes,
      'phone_number': phoneNumber,
      'image_200_200': image200x200,
      'presigned_image_url': presignedImageUrl,
      'presigned_image_url_large': presignedImageUrlLarge,
    };
  }

  ListEntry copyWith({
    String? id,
    String? list,
    String? title,
    bool? selected,
    String? image,
    String? notes,
    String? phoneNumber,
    String? image200x200,
    String? presignedImageUrl,
    String? presignedImageUrlLarge,
  }) {
    return ListEntry(
      id: id ?? this.id,
      list: list ?? this.list,
      title: title ?? this.title,
      selected: selected ?? this.selected,
      image: image ?? this.image,
      notes: notes ?? this.notes,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image200x200: image200x200 ?? this.image200x200,
      presignedImageUrl: presignedImageUrl ?? this.presignedImageUrl,
      presignedImageUrlLarge: presignedImageUrlLarge ?? this.presignedImageUrlLarge,
    );
  }
}

/// Model for creating a new list entry
class ListEntryCreateRequest {
  final String list;
  final String? title;
  final bool? selected;
  final String? image;
  final String? notes;
  final String? phoneNumber;

  ListEntryCreateRequest({
    required this.list,
    this.title,
    this.selected,
    this.image,
    this.notes,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'list': list,
      'title': title,
      'selected': selected,
      'image': image,
      'notes': notes,
      'phone_number': phoneNumber,
    };
  }
}

/// Model for updating an existing list entry
class ListEntryUpdateRequest {
  final String id;
  final String? list;
  final String? title;
  final bool? selected;
  final String? image;
  final String? notes;
  final String? phoneNumber;

  ListEntryUpdateRequest({
    required this.id,
    this.list,
    this.title,
    this.selected,
    this.image,
    this.notes,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
    };

    if (list != null) data['list'] = list;
    if (title != null) data['title'] = title;
    if (selected != null) data['selected'] = selected;
    if (image != null) data['image'] = image;
    if (notes != null) data['notes'] = notes;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;

    return data;
  }
}
