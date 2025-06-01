import 'package:flutter/material.dart';

/// A dialog for picking an icon for task categories
class CategoryIconPicker extends StatefulWidget {
  /// Constructor
  const CategoryIconPicker({super.key});

  @override
  State<CategoryIconPicker> createState() => _CategoryIconPickerState();
}

class _CategoryIconPickerState extends State<CategoryIconPicker> {
  String? _selectedIconCode;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Common Material Icons that are suitable for task categories
  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'Home', 'code': '0xe318'}, // Icons.home
    {'name': 'Work', 'code': '0xe11c'}, // Icons.work
    {'name': 'School', 'code': '0xe559'}, // Icons.school
    {'name': 'Shopping', 'code': '0xe59c'}, // Icons.shopping_cart
    {'name': 'Health', 'code': '0xe3f3'}, // Icons.favorite
    {'name': 'Fitness', 'code': '0xe28d'}, // Icons.fitness_center
    {'name': 'Travel', 'code': '0xe071'}, // Icons.airplanemode_active
    {'name': 'Finance', 'code': '0xe404'}, // Icons.attach_money
    {'name': 'Food', 'code': '0xe532'}, // Icons.restaurant
    {'name': 'Calendar', 'code': '0xe0be'}, // Icons.calendar_today
    {'name': 'Family', 'code': '0xe58f'}, // Icons.family_restroom
    {'name': 'Personal', 'code': '0xe7fd'}, // Icons.person
    {'name': 'Leisure', 'code': '0xe57f'}, // Icons.sports_basketball
    {'name': 'Meeting', 'code': '0xe574'}, // Icons.meeting_room
    {'name': 'Project', 'code': '0xe8f9'}, // Icons.assignment
    {'name': 'Star', 'code': '0xe838'}, // Icons.star
    {'name': 'Important', 'code': '0xe645'}, // Icons.priority_high
    {'name': 'Emergency', 'code': '0xe623'}, // Icons.warning
    {'name': 'Reminder', 'code': '0xe003'}, // Icons.access_alarm
    {'name': 'Study', 'code': '0xe865'}, // Icons.book
    {'name': 'Party', 'code': '0xe053'}, // Icons.celebration
    {'name': 'Bills', 'code': '0xef63'}, // Icons.receipt
    {'name': 'Car', 'code': '0xe4df'}, // Icons.directions_car
    {'name': 'Gift', 'code': '0xe334'}, // Icons.card_giftcard
    {'name': 'Call', 'code': '0xe0b0'}, // Icons.call
    {'name': 'Email', 'code': '0xe0be'}, // Icons.email
    {'name': 'Chat', 'code': '0xe0ca'}, // Icons.chat
    {'name': 'Music', 'code': '0xe3f5'}, // Icons.music_note
    {'name': 'Movie', 'code': '0xe02c'}, // Icons.movie
    {'name': 'Camera', 'code': '0xe3af'}, // Icons.camera_alt
    {'name': 'Bug', 'code': '0xe868'}, // Icons.bug_report
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredIcons {
    if (_searchQuery.isEmpty) {
      return _iconOptions;
    }
    
    return _iconOptions.where((icon) {
      return icon['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose an Icon'),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxHeight: 400,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search icons',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: _filteredIcons.isEmpty
                  ? const Center(
                      child: Text('No icons found'),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: _filteredIcons.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final iconInfo = _filteredIcons[index];
                        final iconCode = iconInfo['code'];
                        final iconName = iconInfo['name'];
                        final iconData = IconData(
                          int.parse(iconCode),
                          fontFamily: 'MaterialIcons',
                        );
                        final isSelected = iconCode == _selectedIconCode;
                        
                        return Tooltip(
                          message: iconName,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedIconCode = iconCode;
                              });
                            },
                            borderRadius: BorderRadius.circular(isSelected ? 16 : 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : null,
                                borderRadius: BorderRadius.circular(isSelected ? 16 : 8),
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Icon(
                                iconData,
                                size: 32,
                                color: isSelected ? Theme.of(context).primaryColor : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _selectedIconCode != null
              ? () => Navigator.pop(context, _selectedIconCode)
              : null,
          child: const Text('SELECT'),
        ),
      ],
    );
  }
}
