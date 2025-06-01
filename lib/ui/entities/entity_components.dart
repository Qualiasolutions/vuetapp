// Placeholder file for entity UI components

import 'package:flutter/material.dart';
import '../../models/entity_model.dart'; // Imports BaseEntityModel, EntitySubtype
// Import subtype models
// Import reference model
// Import reference group model
// Import repository for fetching tags
import '../../utils/datetime_extensions.dart'; // Import DateTime extensions
// Import the new EntityTaggingWidget

// TODO: Implement widgets for displaying entity lists

class EntityListWidget extends StatelessWidget {
  final List<BaseEntityModel> entities;

  const EntityListWidget({super.key, required this.entities});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement entity list display
    return ListView.builder(
      itemCount: entities.length,
      itemBuilder: (context, index) {
        final entity = entities[index];
        return ListTile(
          title: Text(entity.name),
          subtitle: Text(entity.subtype.name), 
          // TODO: Add onTap to navigate to entity detail screen
        );
      },
    );
  }
}

// Mapping from entity subtype to display widget
Widget getEntityDisplayWidget(BaseEntityModel entity) { 
  switch (entity.subtype) { 
    case EntitySubtype.pet:
      return PetEntityWidget(entity: entity, specificData: entity.customFields);
    case EntitySubtype.appliance:
      return HomeApplianceEntityWidget(entity: entity, specificData: entity.customFields);
    case EntitySubtype.holiday:
      return HolidayEntityWidget(entity: entity, specificData: entity.customFields);
    case EntitySubtype.car: 
      return CarEntityWidget(entity: entity, specificData: entity.customFields);
    // Note: EntitySubtype.home is not explicitly handled as there's no HomeSpecificDataModel distinct from HomeAppliance.
    // If 'home' is a valid subtype without specific data, it will fall to default.
    // Or, if it should use HomeAppliance, add: case EntitySubtype.home:
    default:
      return DefaultEntityWidget(entity: entity);
  }
}


// Example of a widget for a specific entity subtype
class PetEntityWidget extends StatelessWidget {
  final BaseEntityModel entity; 
  final Map<String, dynamic>? specificData;

  const PetEntityWidget({super.key, required this.entity, this.specificData});

  @override
  Widget build(BuildContext context) {
    final petTypeValue = specificData?['pet_type'];
    final String? petType = petTypeValue is String ? petTypeValue : null;

    final breedValue = specificData?['breed'];
    final String? breed = breedValue is String ? breedValue : null;

    final dateOfBirthStrValue = specificData?['date_of_birth'];
    final String? dateOfBirthStr = dateOfBirthStrValue is String ? dateOfBirthStrValue : null;
    final DateTime? dateOfBirth = dateOfBirthStr != null ? DateTime.tryParse(dateOfBirthStr) : null;

    final vetNameValue = specificData?['vet_name'];
    final String? vetName = vetNameValue is String ? vetNameValue : null;

    final vetPhoneNumberValue = specificData?['vet_phone_number'];
    final String? vetPhoneNumber = vetPhoneNumberValue is String ? vetPhoneNumberValue : null;

    final microchipIdValue = specificData?['microchip_id'];
    final String? microchipId = microchipIdValue is String ? microchipIdValue : null;

    final insurancePolicyNumberValue = specificData?['insurance_policy_number'];
    final String? insurancePolicyNumber = insurancePolicyNumberValue is String ? insurancePolicyNumberValue : null;
    
    // Assuming 'notes' in specificData for PetSpecificDataModel was intended for pet-specific notes
    final petSpecificNotesValue = specificData?['notes'];
    final String? petSpecificNotes = petSpecificNotesValue is String ? petSpecificNotesValue : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${entity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Subtype: ${entity.subtype.name}'), 
            if (petType != null) Text('Type: $petType'),
            if (breed != null) Text('Breed: $breed'),
            if (dateOfBirth != null)
              Text('Date of Birth: ${dateOfBirth.toLocal().toShortDateString()}'),
            if (vetName != null) Text('Vet: $vetName'),
            if (vetPhoneNumber != null) Text('Vet Phone: $vetPhoneNumber'),
            if (microchipId != null) Text('Microchip: $microchipId'),
            if (insurancePolicyNumber != null) Text('Insurance: $insurancePolicyNumber'),
            if (petSpecificNotes != null) Text('Pet Notes: $petSpecificNotes'),
            Text('General Notes: ${entity.description ?? 'N/A'}'),
            // TODO: Display common entity fields like image
          ],
        ),
      ),
    );
  }
}

// Stub for CarEntityWidget
class CarEntityWidget extends StatelessWidget {
  final BaseEntityModel entity;
  final Map<String, dynamic>? specificData;

  const CarEntityWidget({super.key, required this.entity, this.specificData});

  @override
  Widget build(BuildContext context) {
    final makeValue = specificData?['make'];
    final String? make = makeValue is String ? makeValue : null;

    final modelValue = specificData?['model'];
    final String? model = modelValue is String ? modelValue : null;

    final registrationValue = specificData?['registration'];
    final String? registration = registrationValue is String ? registrationValue : null;

    final motDueDateStrValue = specificData?['mot_due_date'];
    final String? motDueDateStr = motDueDateStrValue is String ? motDueDateStrValue : null;
    final DateTime? motDueDate = motDueDateStr != null ? DateTime.tryParse(motDueDateStr) : null;

    final insuranceDueDateStrValue = specificData?['insurance_due_date'];
    final String? insuranceDueDateStr = insuranceDueDateStrValue is String ? insuranceDueDateStrValue : null;
    final DateTime? insuranceDueDate = insuranceDueDateStr != null ? DateTime.tryParse(insuranceDueDateStr) : null;

    final serviceDueDateStrValue = specificData?['service_due_date'];
    final String? serviceDueDateStr = serviceDueDateStrValue is String ? serviceDueDateStrValue : null;
    final DateTime? serviceDueDate = serviceDueDateStr != null ? DateTime.tryParse(serviceDueDateStr) : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name: ${entity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Subtype: ${entity.subtype.name}'),
          if (make != null) Text('Make: $make'),
          if (model != null) Text('Model: $model'),
          if (registration != null) Text('Registration: $registration'),
          if (motDueDate != null) Text('MOT Due: ${motDueDate.toLocal().toShortDateString()}'),
          if (insuranceDueDate != null) Text('Insurance Due: ${insuranceDueDate.toLocal().toShortDateString()}'),
          if (serviceDueDate != null) Text('Service Due: ${serviceDueDate.toLocal().toShortDateString()}'),
          Text('Notes: ${entity.description ?? 'N/A'}'),
        ]),
      ),
    );
  }
}

// Renamed from HomeEntityWidget
class HomeApplianceEntityWidget extends StatelessWidget {
  final BaseEntityModel entity;
  final Map<String, dynamic>? specificData;

  const HomeApplianceEntityWidget({super.key, required this.entity, this.specificData});

  @override
  Widget build(BuildContext context) {
    final applianceTypeValue = specificData?['appliance_type'];
    final String? applianceType = applianceTypeValue is String ? applianceTypeValue : null;

    final brandValue = specificData?['brand'];
    final String? brand = brandValue is String ? brandValue : null;

    final modelNumberValue = specificData?['model_number'];
    final String? modelNumber = modelNumberValue is String ? modelNumberValue : null;

    final serialNumberValue = specificData?['serial_number'];
    final String? serialNumber = serialNumberValue is String ? serialNumberValue : null;

    final purchaseDateStrValue = specificData?['purchase_date'];
    final String? purchaseDateStr = purchaseDateStrValue is String ? purchaseDateStrValue : null;
    final DateTime? purchaseDate = purchaseDateStr != null ? DateTime.tryParse(purchaseDateStr) : null;

    final warrantyExpiryDateStrValue = specificData?['warranty_expiry_date'];
    final String? warrantyExpiryDateStr = warrantyExpiryDateStrValue is String ? warrantyExpiryDateStrValue : null;
    final DateTime? warrantyExpiryDate = warrantyExpiryDateStr != null ? DateTime.tryParse(warrantyExpiryDateStr) : null;

    final manualUrlValue = specificData?['manual_url'];
    final String? manualUrl = manualUrlValue is String ? manualUrlValue : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Name: ${entity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Subtype: ${entity.subtype.name}'),
          if (applianceType != null) Text('Appliance Type: $applianceType'),
          if (brand != null) Text('Brand: $brand'),
          if (modelNumber != null) Text('Model: $modelNumber'),
          if (serialNumber != null) Text('Serial: $serialNumber'),
          if (purchaseDate != null) Text('Purchased: ${purchaseDate.toLocal().toShortDateString()}'),
          if (warrantyExpiryDate != null) Text('Warranty Ends: ${warrantyExpiryDate.toLocal().toShortDateString()}'),
          if (manualUrl != null) Text('Manual: $manualUrl'), // TODO: Make this a link
          Text('Notes: ${entity.description ?? 'N/A'}'),
        ]),
      ),
    );
  }
}

class HolidayEntityWidget extends StatelessWidget {
  final BaseEntityModel entity; 
  final Map<String, dynamic>? specificData;

  const HolidayEntityWidget({super.key, required this.entity, this.specificData});

  @override
  Widget build(BuildContext context) {
    final destinationValue = specificData?['destination'];
    final String? destination = destinationValue is String ? destinationValue : null;

    final startDateStrValue = specificData?['start_date'];
    final String? startDateStr = startDateStrValue is String ? startDateStrValue : null;
    final DateTime? startDate = startDateStr != null ? DateTime.tryParse(startDateStr) : null;

    final endDateStrValue = specificData?['end_date'];
    final String? endDateStr = endDateStrValue is String ? endDateStrValue : null;
    final DateTime? endDate = endDateStr != null ? DateTime.tryParse(endDateStr) : null;

    final holidayTypeValue = specificData?['holiday_type'];
    final String? holidayType = holidayTypeValue is String ? holidayTypeValue : null;

    final transportationDetailsValue = specificData?['transportation_details'];
    final String? transportationDetails = transportationDetailsValue is String ? transportationDetailsValue : null;

    final accommodationDetailsValue = specificData?['accommodation_details'];
    final String? accommodationDetails = accommodationDetailsValue is String ? accommodationDetailsValue : null;

    final budgetValue = specificData?['budget'];
    final double? budget = budgetValue is double ? budgetValue : (budgetValue is String ? double.tryParse(budgetValue) : null);
    // Note: budget was already handled safely, this is just for consistency in variable naming if desired.

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${entity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Subtype: ${entity.subtype.name}'), 
            if (destination != null) Text('Destination: $destination'),
            if (startDate != null) Text('Start Date: ${startDate.toLocal().toShortDateString()}'),
            if (endDate != null) Text('End Date: ${endDate.toLocal().toShortDateString()}'),
            if (holidayType != null) Text('Type: $holidayType'),
            if (transportationDetails != null) Text('Transport: $transportationDetails'),
            if (accommodationDetails != null) Text('Accommodation: $accommodationDetails'),
            if (budget != null) Text('Budget: \$${budget.toStringAsFixed(2)}'),
            Text('Notes: ${entity.description ?? 'N/A'}'),
            // TODO: Display common entity fields like image
          ],
        ),
      ),
    );
  }
}

// Default widget for entities without a specific subtype widget
class DefaultEntityWidget extends StatelessWidget {
  final BaseEntityModel entity; 

  const DefaultEntityWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${entity.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Subtype: ${entity.subtype.name}'), 
            Text('Notes: ${entity.description ?? 'N/A'}'),
            // TODO: Display image and potentially raw subtypeDetails from entity.additionalProperties
          ],
        ),
      ),
    );
  }
}


// Mapping from entity subtype to form widget
Widget getEntityFormWidget(BaseEntityModel? entity, {required ValueChanged<Map<String, dynamic>> onFormValuesChange, required Map<String, dynamic> initialValues}) { 
  EntitySubtype? entitySubtype;
  if (entity != null) {
    entitySubtype = entity.subtype;
  } else if (initialValues['entitySubtype'] != null) {
    try {
      entitySubtype = EntitySubtype.values.byName(initialValues['entitySubtype'] as String);
    } catch (_) {
      entitySubtype = EntitySubtype.car; // Default if parsing fails
    }
  } else {
    entitySubtype = EntitySubtype.car; // Default if not found
  }

  switch (entitySubtype) {
    case EntitySubtype.pet:
      return PetEntityForm(onFormValuesChange: onFormValuesChange, initialValues: initialValues);
    case EntitySubtype.car:
      return CarEntityForm(onFormValuesChange: onFormValuesChange, initialValues: initialValues);
    case EntitySubtype.holiday:
      return HolidayEntityForm(onFormValuesChange: onFormValuesChange, initialValues: initialValues);
    case EntitySubtype.appliance: 
      return HomeApplianceEntityForm(onFormValuesChange: onFormValuesChange, initialValues: initialValues);
    default:
      return DefaultEntityForm(onFormValuesChange: onFormValuesChange, initialValues: initialValues);
  }
}

// Example of a form widget for a specific entity subtype
class PetEntityForm extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFormValuesChange;
  final Map<String, dynamic> initialValues;

  const PetEntityForm({super.key, required this.onFormValuesChange, required this.initialValues});

  @override
  PetEntityFormState createState() => PetEntityFormState();
}

class PetEntityFormState extends State<PetEntityForm> {
  late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = Map<String, dynamic>.from(widget.initialValues); 
    
    _formValues.putIfAbsent('petType', () => _formValues['pet_type'] ?? ''); 
    _formValues.putIfAbsent('breed', () => _formValues['breed'] ?? '');
    _formValues.putIfAbsent('dateOfBirth', () => _formValues['date_of_birth'] ?? ''); 
    _formValues.putIfAbsent('vetName', () => _formValues['vet_name'] ?? '');
    _formValues.putIfAbsent('vetPhoneNumber', () => _formValues['vet_phone_number'] ?? '');
    _formValues.putIfAbsent('microchipId', () => _formValues['microchip_id'] ?? '');
    _formValues.putIfAbsent('insurancePolicyNumber', () => _formValues['insurance_policy_number'] ?? '');
    // 'notes' for PetSpecificDataModel is distinct from BaseEntityModel.notes
    // Let's use 'petSpecificNotes' as the key in _formValues to avoid collision if BaseEntityModel.notes is also directly in _formValues.
    _formValues.putIfAbsent('petSpecificNotes', () => _formValues['notes'] ?? ''); // This 'notes' is from PetSpecificDataModel
  }

  void _updateFormValues(String key, dynamic value) {
    setState(() {
      _formValues[key] = value;
    });
    widget.onFormValuesChange(_formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _formValues['name'] as String?,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (value) => _updateFormValues('name', value),
        ),
        TextFormField(
          initialValue: _formValues['petType'] as String?,
          decoration: InputDecoration(labelText: 'Pet Type'),
          onChanged: (value) => _updateFormValues('petType', value),
        ),
        TextFormField(
          initialValue: _formValues['breed'] as String?,
          decoration: InputDecoration(labelText: 'Breed'),
          onChanged: (value) => _updateFormValues('breed', value),
        ),
        TextFormField(
          initialValue: _formValues['dateOfBirth'] as String?,
          decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('dateOfBirth', value),
        ),
        TextFormField(
          initialValue: _formValues['vetName'] as String?,
          decoration: InputDecoration(labelText: 'Vet Name'),
          onChanged: (value) => _updateFormValues('vetName', value),
        ),
        TextFormField(
          initialValue: _formValues['vetPhoneNumber'] as String?,
          decoration: InputDecoration(labelText: 'Vet Phone Number'),
          onChanged: (value) => _updateFormValues('vetPhoneNumber', value),
        ),
        TextFormField(
          initialValue: _formValues['microchipId'] as String?,
          decoration: InputDecoration(labelText: 'Microchip ID'),
          onChanged: (value) => _updateFormValues('microchipId', value),
        ),
        TextFormField(
          initialValue: _formValues['insurancePolicyNumber'] as String?,
          decoration: InputDecoration(labelText: 'Insurance Policy Number'),
          onChanged: (value) => _updateFormValues('insurancePolicyNumber', value),
        ),
        TextFormField(
          initialValue: _formValues['notes'] as String?, // Base notes
          decoration: InputDecoration(labelText: 'General Notes'),
          onChanged: (value) => _updateFormValues('notes', value),
          maxLines: 3,
        ),
         TextFormField(
          initialValue: _formValues['petSpecificNotes'] as String?, 
          decoration: InputDecoration(labelText: 'Pet Specific Notes'),
          onChanged: (value) => _updateFormValues('petSpecificNotes', value),
          maxLines: 3,
        ),
        TextFormField(
          initialValue: _formValues['imageUrl'] as String?,
          decoration: InputDecoration(labelText: 'Image URL'),
          onChanged: (value) => _updateFormValues('imageUrl', value),
        ),
        SwitchListTile(
          title: const Text('Favourite'),
          value: _formValues['isFavourite'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isFavourite', value),
        ),
        SwitchListTile(
          title: const Text('Archived'),
          value: _formValues['isArchived'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isArchived', value),
        ),
      ],
    );
  }
}

class CarEntityForm extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFormValuesChange;
  final Map<String, dynamic> initialValues;

  const CarEntityForm({super.key, required this.onFormValuesChange, required this.initialValues});

  @override
  CarEntityFormState createState() => CarEntityFormState();
}

class CarEntityFormState extends State<CarEntityForm> {
   late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = Map<String, dynamic>.from(widget.initialValues);
    _formValues.putIfAbsent('make', () => _formValues['make'] ?? '');
    _formValues.putIfAbsent('model', () => _formValues['model'] ?? '');
    _formValues.putIfAbsent('registration', () => _formValues['registration'] ?? '');
    _formValues.putIfAbsent('motDueDate', () => _formValues['mot_due_date'] ?? '');
    _formValues.putIfAbsent('insuranceDueDate', () => _formValues['insurance_due_date'] ?? '');
    _formValues.putIfAbsent('serviceDueDate', () => _formValues['service_due_date'] ?? '');
  }

  void _updateFormValues(String key, dynamic value) {
    setState(() {
      _formValues[key] = value;
    });
    widget.onFormValuesChange(_formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _formValues['name'] as String?,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (value) => _updateFormValues('name', value),
        ),
        TextFormField(
          initialValue: _formValues['make'] as String?,
          decoration: InputDecoration(labelText: 'Make'),
          onChanged: (value) => _updateFormValues('make', value),
        ),
         TextFormField(
          initialValue: _formValues['model'] as String?,
          decoration: InputDecoration(labelText: 'Model'),
          onChanged: (value) => _updateFormValues('model', value),
        ),
         TextFormField(
          initialValue: _formValues['registration'] as String?,
          decoration: InputDecoration(labelText: 'Registration'),
          onChanged: (value) => _updateFormValues('registration', value),
        ),
        TextFormField(
          initialValue: _formValues['motDueDate'] as String?,
          decoration: InputDecoration(labelText: 'MOT Due Date (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('motDueDate', value),
        ),
        TextFormField(
          initialValue: _formValues['insuranceDueDate'] as String?,
          decoration: InputDecoration(labelText: 'Insurance Due Date (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('insuranceDueDate', value),
        ),
        TextFormField(
          initialValue: _formValues['serviceDueDate'] as String?,
          decoration: InputDecoration(labelText: 'Service Due Date (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('serviceDueDate', value),
        ),
        TextFormField(
          initialValue: _formValues['notes'] as String?,
          decoration: InputDecoration(labelText: 'Notes'),
          onChanged: (value) => _updateFormValues('notes', value),
          maxLines: 3,
        ),
        TextFormField(
          initialValue: _formValues['imageUrl'] as String?,
          decoration: InputDecoration(labelText: 'Image URL'),
          onChanged: (value) => _updateFormValues('imageUrl', value),
        ),
        SwitchListTile(
          title: const Text('Favourite'),
          value: _formValues['isFavourite'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isFavourite', value),
        ),
        SwitchListTile(
          title: const Text('Archived'),
          value: _formValues['isArchived'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isArchived', value),
        ),
      ],
    );
  }
}

class HomeApplianceEntityForm extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFormValuesChange;
  final Map<String, dynamic> initialValues;

  const HomeApplianceEntityForm({super.key, required this.onFormValuesChange, required this.initialValues});

  @override
  HomeApplianceEntityFormState createState() => HomeApplianceEntityFormState();
}

class HomeApplianceEntityFormState extends State<HomeApplianceEntityForm> {
   late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = Map<String, dynamic>.from(widget.initialValues);
    _formValues.putIfAbsent('applianceType', () => _formValues['appliance_type'] ?? ''); 
    _formValues.putIfAbsent('brand', () => _formValues['brand'] ?? '');
    _formValues.putIfAbsent('modelNumber', () => _formValues['model_number'] ?? ''); 
    _formValues.putIfAbsent('serialNumber', () => _formValues['serial_number'] ?? '');
    _formValues.putIfAbsent('purchaseDate', () => _formValues['purchase_date'] ?? '');
    _formValues.putIfAbsent('warrantyExpiryDate', () => _formValues['warranty_expiry_date'] ?? '');
    _formValues.putIfAbsent('manualUrl', () => _formValues['manual_url'] ?? '');
    // Fields like 'address' and 'homeType' were in an old 'HomeEntityModel', 
    // but HomeApplianceSpecificDataModel doesn't have them.
    // If they are needed for home appliances, they should be added to HomeApplianceSpecificDataModel
    // or handled as general additionalProperties. For now, only using fields from HomeApplianceSpecificDataModel.
  }

  void _updateFormValues(String key, dynamic value) {
    setState(() {
      _formValues[key] = value;
    });
    widget.onFormValuesChange(_formValues);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _formValues['name'] as String?,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (value) => _updateFormValues('name', value),
        ),
        TextFormField(
          initialValue: _formValues['applianceType'] as String?,
          decoration: InputDecoration(labelText: 'Appliance Type'),
          onChanged: (value) => _updateFormValues('applianceType', value),
        ),
         TextFormField(
          initialValue: _formValues['brand'] as String?,
          decoration: InputDecoration(labelText: 'Brand'),
          onChanged: (value) => _updateFormValues('brand', value),
        ),
        TextFormField(
          initialValue: _formValues['modelNumber'] as String?,
          decoration: InputDecoration(labelText: 'Model Number'),
          onChanged: (value) => _updateFormValues('modelNumber', value),
        ),
        TextFormField(
          initialValue: _formValues['serialNumber'] as String?,
          decoration: InputDecoration(labelText: 'Serial Number'),
          onChanged: (value) => _updateFormValues('serialNumber', value),
        ),
        TextFormField(
          initialValue: _formValues['purchaseDate'] as String?,
          decoration: InputDecoration(labelText: 'Purchase Date (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('purchaseDate', value),
        ),
        TextFormField(
          initialValue: _formValues['warrantyExpiryDate'] as String?,
          decoration: InputDecoration(labelText: 'Warranty Expiry (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('warrantyExpiryDate', value),
        ),
        TextFormField(
          initialValue: _formValues['manualUrl'] as String?,
          decoration: InputDecoration(labelText: 'Manual URL'),
          onChanged: (value) => _updateFormValues('manualUrl', value),
        ),
        TextFormField(
          initialValue: _formValues['notes'] as String?,
          decoration: InputDecoration(labelText: 'Notes'),
          onChanged: (value) => _updateFormValues('notes', value),
          maxLines: 3,
        ),
        TextFormField(
          initialValue: _formValues['imageUrl'] as String?,
          decoration: InputDecoration(labelText: 'Image URL'),
          onChanged: (value) => _updateFormValues('imageUrl', value),
        ),
        SwitchListTile(
          title: const Text('Favourite'),
          value: _formValues['isFavourite'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isFavourite', value),
        ),
        SwitchListTile(
          title: const Text('Archived'),
          value: _formValues['isArchived'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isArchived', value),
        ),
      ],
    );
  }
}

class DefaultEntityForm extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFormValuesChange;
  final Map<String, dynamic> initialValues;

  const DefaultEntityForm({super.key, required this.onFormValuesChange, required this.initialValues});

  @override
  DefaultEntityFormState createState() => DefaultEntityFormState();
}

class DefaultEntityFormState extends State<DefaultEntityForm> {
   late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = Map<String, dynamic>.from(widget.initialValues);
    _formValues.putIfAbsent('name', () => ''); 
    _formValues.putIfAbsent('notes', () => '');
    _formValues.putIfAbsent('imageUrl', () => '');
    _formValues.putIfAbsent('isFavourite', () => false);
    _formValues.putIfAbsent('isArchived', () => false);
  }

  void _updateFormValues(String key, dynamic value) {
    setState(() {
      _formValues[key] = value;
    });
    widget.onFormValuesChange(_formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _formValues['name'] as String?,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (value) => _updateFormValues('name', value),
        ),
        TextFormField(
          initialValue: _formValues['notes'] as String?,
          decoration: InputDecoration(labelText: 'Notes'),
          onChanged: (value) => _updateFormValues('notes', value),
          maxLines: 3,
        ),
        TextFormField(
          initialValue: _formValues['imageUrl'] as String?,
          decoration: InputDecoration(labelText: 'Image URL'),
          onChanged: (value) => _updateFormValues('imageUrl', value),
        ),
        SwitchListTile(
          title: const Text('Favourite'),
          value: _formValues['isFavourite'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isFavourite', value),
        ),
        SwitchListTile(
          title: const Text('Archived'),
          value: _formValues['isArchived'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isArchived', value),
        ),
        // TODO: Add other common form fields like category, parent
      ],
    );
  }
}

class HolidayEntityForm extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFormValuesChange;
  final Map<String, dynamic> initialValues;

  const HolidayEntityForm({super.key, required this.onFormValuesChange, required this.initialValues});

  @override
  HolidayEntityFormState createState() => HolidayEntityFormState();
}

class HolidayEntityFormState extends State<HolidayEntityForm> {
  late Map<String, dynamic> _formValues;

  @override
  void initState() {
    super.initState();
    _formValues = Map<String, dynamic>.from(widget.initialValues);
    _formValues.putIfAbsent('destination', () => _formValues['destination'] ?? '');
    _formValues.putIfAbsent('startDate', () => _formValues['start_date'] ?? DateTime.now().toIso8601String().substring(0,10));
    _formValues.putIfAbsent('endDate', () => _formValues['end_date'] ?? DateTime.now().add(const Duration(days: 7)).toIso8601String().substring(0,10));
    _formValues.putIfAbsent('holidayType', () => _formValues['holiday_type'] ?? '');
    _formValues.putIfAbsent('transportationDetails', () => _formValues['transportation_details'] ?? '');
    _formValues.putIfAbsent('accommodationDetails', () => _formValues['accommodation_details'] ?? '');
    _formValues.putIfAbsent('budget', () => _formValues['budget']?.toString() ?? '');
    _formValues.putIfAbsent('stringId', () => _formValues['string_id'] ?? ''); 
    _formValues.putIfAbsent('countryCode', () => _formValues['country_code'] ?? ''); 
  }

  void _updateFormValues(String key, dynamic value) {
    setState(() {
      _formValues[key] = value;
    });
    widget.onFormValuesChange(_formValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: _formValues['name'] as String?,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (value) => _updateFormValues('name', value),
        ),
        TextFormField(
          initialValue: _formValues['destination'] as String?,
          decoration: InputDecoration(labelText: 'Destination'),
          onChanged: (value) => _updateFormValues('destination', value),
        ),
        TextFormField(
          initialValue: _formValues['startDate'] as String?,
          decoration: InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('startDate', value),
        ),
        TextFormField(
          initialValue: _formValues['endDate'] as String?,
          decoration: InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
          onChanged: (value) => _updateFormValues('endDate', value),
        ),
        TextFormField(
          initialValue: _formValues['holidayType'] as String?,
          decoration: InputDecoration(labelText: 'Holiday Type'),
          onChanged: (value) => _updateFormValues('holidayType', value),
        ),
        TextFormField(
          initialValue: _formValues['transportationDetails'] as String?,
          decoration: InputDecoration(labelText: 'Transportation Details'),
          onChanged: (value) => _updateFormValues('transportationDetails', value),
          maxLines: 2,
        ),
        TextFormField(
          initialValue: _formValues['accommodationDetails'] as String?,
          decoration: InputDecoration(labelText: 'Accommodation Details'),
          onChanged: (value) => _updateFormValues('accommodationDetails', value),
          maxLines: 2,
        ),
        TextFormField(
          initialValue: _formValues['budget'] as String?,
          decoration: InputDecoration(labelText: 'Budget'),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => _updateFormValues('budget', value),
        ),
        TextFormField(
          initialValue: _formValues['notes'] as String?,
          decoration: InputDecoration(labelText: 'Notes'),
          onChanged: (value) => _updateFormValues('notes', value),
          maxLines: 3,
        ),
        TextFormField(
          initialValue: _formValues['imageUrl'] as String?,
          decoration: InputDecoration(labelText: 'Image URL'),
          onChanged: (value) => _updateFormValues('imageUrl', value),
        ),
        SwitchListTile(
          title: const Text('Favourite'),
          value: _formValues['isFavourite'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isFavourite', value),
        ),
        SwitchListTile(
          title: const Text('Archived'),
          value: _formValues['isArchived'] as bool? ?? false,
          onChanged: (bool value) => _updateFormValues('isArchived', value),
        ),
      ],
    );
  }
}

// EntityTaggingWidget has been moved to entity_tagging_widget.dart
