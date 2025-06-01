import 'package:flutter/material.dart'; // Required for TextInputType

enum FormFieldType {
  text,
  multilineText,
  number,
  date,
  dateTime, // Added dateTime
  boolean,
  dropdown,
  email,
  phone,
  url,
  // Potentially add more specific types like imagePicker etc.
}

class FormFieldOption {
  final String value; 
  final String label; 

  const FormFieldOption({required this.value, required this.label});
}

class FormFieldDefinition {
  final String name; 
  final String label; 
  final FormFieldType type;
  final bool isRequired;
  final String? hintText;
  final List<FormFieldOption>? options; 
  final dynamic defaultValue;
  final String? Function(String?)? validator; 
  final String? relatedField; 
  final String? relatedValue; 

  const FormFieldDefinition({
    required this.name,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.hintText,
    this.options,
    this.defaultValue,
    this.validator,
    this.relatedField,
    this.relatedValue,
  });

  static List<FormFieldType> get textTypes => [
    FormFieldType.text,
    FormFieldType.multilineText,
    FormFieldType.number, 
    FormFieldType.date,   
    FormFieldType.dateTime, // Added dateTime
    FormFieldType.email,
    FormFieldType.phone,
    FormFieldType.url,
  ];

  TextInputType get keyboardType {
    switch (type) {
      case FormFieldType.number:
        return TextInputType.number;
      case FormFieldType.multilineText:
        return TextInputType.multiline;
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.url:
        return TextInputType.url;
      // For date and dateTime, we might use TextInputType.none if using a picker exclusively
      case FormFieldType.date:
      case FormFieldType.dateTime:
        return TextInputType.datetime; // Or TextInputType.none if picker is mandatory
      default:
        return TextInputType.text;
    }
  }
}
