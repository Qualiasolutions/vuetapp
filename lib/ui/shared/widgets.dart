import 'package:flutter/material.dart';
import '../../config/theme_config.dart';

/// Global Widgets for Vuet App - Modern Palette Edition
/// Dark Jungle Green #202827 · Medium Turquoise #55C6D6 · Orange #E49F2F · Steel #798D8E · White #FFFFFF

class VuetHeader extends StatelessWidget implements PreferredSizeWidget {
  const VuetHeader(this.title, {super.key});
  final String title;
  
  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: AppColors.darkJungleGreen,
        title: Text(title, style: const TextStyle(color: AppColors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
        elevation: 0,
        centerTitle: true,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class VuetTextField extends StatelessWidget {
  const VuetTextField(
    this.hint, {
    required this.controller,
    required this.validator,
    this.type = TextInputType.text,
    super.key,
  });
  
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType type;
  
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.steel),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.steel),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mediumTurquoise),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: validator,
      );
}

class VuetDatePicker extends StatelessWidget {
  const VuetDatePicker(
    this.hint, {
    required this.controller,
    required this.validator,
    super.key,
  });
  
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.steel),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.steel),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.mediumTurquoise),
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: AppColors.steel),
        ),
        validator: validator,
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: AppColors.mediumTurquoise,
                    onPrimary: AppColors.white,
                    surface: AppColors.white,
                    onSurface: AppColors.darkJungleGreen,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (date != null) {
            controller.text = date.toIso8601String().split('T')[0]; // YYYY-MM-DD format
          }
        },
      );
}

/// Validation helpers as specified in the detailed guide
class VuetValidators {
  /// Required string validator
  static String? Function(String?) required = (v) =>
      v != null && v.trim().isNotEmpty ? null : 'Required';
  
  /// Date ISO validator (YYYY-MM-DD)
  static String? Function(String?) dateIso = (v) =>
      DateTime.tryParse(v ?? '') != null ? null : 'yyyy-MM-dd';
  
  /// Positive integer validator
  static String? Function(String?) positiveInt = (v) =>
      int.tryParse(v ?? '') != null && int.parse(v!) > 0 ? null : '>0';
}

/// Modern Save Button as specified in the guide
class VuetSaveButton extends StatelessWidget {
  const VuetSaveButton({
    required this.onPressed,
    this.text = 'Save',
    super.key,
  });
  
  final VoidCallback onPressed;
  final String text;
  
  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orange,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      );
}

/// Modern FAB as specified in the guide
class VuetFAB extends StatelessWidget {
  const VuetFAB({
    required this.onPressed,
    this.icon = Icons.add,
    this.tooltip,
    super.key,
  });
  
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  
  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.white,
        child: Icon(icon),
      );
}

/// Category Tile as specified in the guide
class VuetCategoryTile extends StatelessWidget {
  const VuetCategoryTile({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });
  
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.orange.withOpacity(0.15),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: AppColors.darkJungleGreen,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkJungleGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
}

/// Modern Toggle as specified in the guide
class VuetToggle extends StatelessWidget {
  const VuetToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });
  
  final bool value;
  final ValueChanged<bool> onChanged;
  
  @override
  Widget build(BuildContext context) => Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.mediumTurquoise,
        activeTrackColor: AppColors.mediumTurquoise.withOpacity(0.35),
        inactiveThumbColor: AppColors.steel,
        inactiveTrackColor: AppColors.steel.withOpacity(0.35),
      );
}

/// Form Divider as specified in the guide
class VuetDivider extends StatelessWidget {
  const VuetDivider({super.key});
  
  @override
  Widget build(BuildContext context) => const Divider(
        color: AppColors.steel,
        thickness: 1,
        height: 32,
      );
}
