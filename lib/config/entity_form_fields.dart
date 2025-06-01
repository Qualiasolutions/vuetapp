import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/form_field_definition.dart';

final Map<EntitySubtype, List<FormFieldDefinition>> entityFormFields = {
  EntitySubtype.car: [
    const FormFieldDefinition(
        name: 'make',
        label: 'Make',
        type: FormFieldType.text,
        isRequired: true,
        hintText: 'e.g., Toyota, Honda'),
    const FormFieldDefinition(
        name: 'model',
        label: 'Model',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Camry, Civic'),
    const FormFieldDefinition(
        name: 'registration',
        label: 'Registration/Plate',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'date_registered',
        label: 'Date Registered',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'serviceDueDate',
        label: 'Service Due Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'insuranceDueDate',
        label: 'Insurance Due Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'vehicle_type_car',
        label: 'Vehicle Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'CAR', label: 'Car'),
          FormFieldOption(value: 'MOTORBIKE', label: 'Motorbike'),
        ]),
    const FormFieldDefinition(
        name: 'vin',
        label: 'VIN Number',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'color',
        label: 'Color',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'purchaseDate',
        label: 'Purchase Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'purchasePrice',
        label: 'Purchase Price',
        type: FormFieldType.number,
        isRequired: false,
        hintText: 'e.g., 25000'),
    const FormFieldDefinition(
        name: 'carNotes',
        label: 'Car Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.pet: [
    const FormFieldDefinition(
        name: 'type',
        label: 'Pet Type',
        type: FormFieldType.text,
        isRequired: true,
        hintText: 'e.g., Dog, Cat, Bird'),
    const FormFieldDefinition(
        name: 'breed',
        label: 'Breed',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Labrador, Siamese'),
    const FormFieldDefinition(
        name: 'dob',
        label: 'Date of Birth',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'microchip_number',
        label: 'Microchip ID',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'microchip_company_name',
        label: 'Microchip Company',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'vetName',
        label: 'Vet Name',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'vetPhoneNumber',
        label: 'Vet Phone Number',
        type: FormFieldType.phone,
        isRequired: false),
    const FormFieldDefinition(
        name: 'walker_name',
        label: 'Walker Name',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'groomer_name',
        label: 'Groomer Name',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'sitter_name',
        label: 'Sitter Name',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'insurance_company_name',
        label: 'Insurance Company',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'insurancePolicyNumber',
        label: 'Insurance Policy Number',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'petNotes',
        label: 'Pet Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.homeAppliance: [
    const FormFieldDefinition(
        name: 'applianceType',
        label: 'Appliance Type',
        type: FormFieldType.text,
        isRequired: true,
        hintText: 'e.g., Refrigerator, Washing Machine'),
    const FormFieldDefinition(
        name: 'brand',
        label: 'Brand',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'modelNumber',
        label: 'Model Number',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'serialNumber',
        label: 'Serial Number',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'purchaseDateAppliance',
        label: 'Purchase Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'warrantyExpiryDate',
        label: 'Warranty Expiry Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'manualUrl',
        label: 'Manual URL',
        type: FormFieldType.url,
        hintText: 'Link to online manual if available',
        isRequired: false),
    const FormFieldDefinition(
        name: 'applianceNotes',
        label: 'Appliance Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.event: [
    const FormFieldDefinition(
        name: 'eventStartDate',
        label: 'Start Date & Time',
        type: FormFieldType.dateTime,
        isRequired: true),
    const FormFieldDefinition(
        name: 'eventEndDate',
        label: 'End Date & Time',
        type: FormFieldType.dateTime,
        isRequired: true),
    const FormFieldDefinition(
        name: 'location',
        label: 'Location',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Conference Hall A, Online'),
    const FormFieldDefinition(
      name: 'eventType',
      label: 'Event Type',
      type: FormFieldType.dropdown,
      isRequired: false,
      options: [
        FormFieldOption(value: 'meeting', label: 'Meeting'),
        FormFieldOption(value: 'conference', label: 'Conference'),
        FormFieldOption(value: 'party', label: 'Party'),
        FormFieldOption(value: 'webinar', label: 'Webinar'),
        FormFieldOption(value: 'other', label: 'Other'),
      ],
    ),
    const FormFieldDefinition(
        name: 'agenda',
        label: 'Agenda/Details',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'eventAdditionalDetails',
        label: 'Other Details/Sub-items',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.holiday: [
    const FormFieldDefinition(
        name: 'destination',
        label: 'Destination',
        type: FormFieldType.text,
        isRequired: true),
    const FormFieldDefinition(
        name: 'countryCode',
        label: 'Country Code',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., US, GB, JP'),
    const FormFieldDefinition(
        name: 'startDate',
        label: 'Start Date',
        type: FormFieldType.date,
        isRequired: true),
    const FormFieldDefinition(
        name: 'endDate',
        label: 'End Date',
        type: FormFieldType.date,
        isRequired: true),
    const FormFieldDefinition(
      name: 'holidayType',
      label: 'Type of Holiday',
      type: FormFieldType.dropdown,
      isRequired: false,
      options: [
        FormFieldOption(value: 'vacation', label: 'Vacation'),
        FormFieldOption(value: 'business_trip', label: 'Business Trip'),
        FormFieldOption(value: 'family_visit', label: 'Family Visit'),
        FormFieldOption(value: 'adventure', label: 'Adventure'),
        FormFieldOption(value: 'other', label: 'Other'),
      ],
    ),
    const FormFieldDefinition(
        name: 'transportationDetails',
        label: 'Transportation Details',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'accommodationDetails',
        label: 'Accommodation Details',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'budget',
        label: 'Budget',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'holidayNotes',
        label: 'Holiday Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.school: [
    const FormFieldDefinition(
        name: 'address',
        label: 'Address',
        type: FormFieldType.multilineText,
        isRequired: false,
        hintText: 'Enter school address'),
    const FormFieldDefinition(
        name: 'phone_number',
        label: 'Phone Number',
        type: FormFieldType.phone,
        isRequired: false,
        hintText: 'Enter school phone'),
    const FormFieldDefinition(
        name: 'email',
        label: 'Email',
        type: FormFieldType.email,
        isRequired: false,
        hintText: 'Enter school email'),
    const FormFieldDefinition(
        name: 'schoolNotes',
        label: 'School Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.appointment: [
    const FormFieldDefinition(
        name: 'appointment_with',
        label: 'Appointment With',
        type: FormFieldType.text,
        isRequired: true,
        hintText: 'e.g., Dr. Smith, Dental Clinic'),
    const FormFieldDefinition(
        name: 'appointment_datetime',
        label: 'Date & Time',
        type: FormFieldType.dateTime,
        isRequired: true),
    const FormFieldDefinition(
        name: 'location',
        label: 'Location',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., City Hospital, Room 302'),
    const FormFieldDefinition(
        name: 'reason',
        label: 'Reason for Appointment',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'appointment_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.healthBeauty: [
    const FormFieldDefinition(
        name: 'hb_details',
        label: 'Details',
        type: FormFieldType.multilineText,
        isRequired: false,
        hintText: 'Enter any details for this health & beauty item.'),
  ],
  EntitySubtype.patient: [
    const FormFieldDefinition(
        name: 'patient_dob',
        label: 'Date of Birth',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'patient_conditions',
        label: 'Medical Conditions',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'patient_allergies',
        label: 'Allergies',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'patient_medications',
        label: 'Current Medications',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'patient_notes',
        label: 'Patient Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.healthGoal: [
    const FormFieldDefinition(
        name: 'goal_description',
        label: 'Goal Description',
        type: FormFieldType.multilineText,
        isRequired: true,
        hintText: 'e.g., Run 5km, Drink 8 glasses of water daily'),
    const FormFieldDefinition(
        name: 'target_date',
        label: 'Target Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'status',
        label: 'Status',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'not_started', label: 'Not Started'),
          FormFieldOption(value: 'in_progress', label: 'In Progress'),
          FormFieldOption(value: 'achieved', label: 'Achieved'),
          FormFieldOption(value: 'on_hold', label: 'On Hold'),
        ]),
    const FormFieldDefinition(
        name: 'health_goal_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.academicPlan: [
    const FormFieldDefinition(
        name: 'plan_details',
        label: 'Plan Details',
        type: FormFieldType.multilineText,
        isRequired: false,
        hintText: 'Describe the academic plan or goals.'),
    const FormFieldDefinition(
        name: 'subject_focus',
        label: 'Subject/Focus Area',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'target_qualification',
        label: 'Target Qualification',
        type: FormFieldType.text,
        isRequired: false),
  ],
  EntitySubtype.extracurricularPlan: [
    const FormFieldDefinition(
        name: 'activity_name',
        label: 'Activity Name',
        type: FormFieldType.text,
        isRequired: true,
        hintText: 'e.g., Piano Lessons, Debate Club'),
    const FormFieldDefinition(
        name: 'activity_details',
        label: 'Activity Details',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'schedule_info',
        label: 'Schedule/Frequency',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Tuesdays at 4 PM, Every Saturday'),
  ],
  // Additional entity subtypes
  EntitySubtype.student: [
    const FormFieldDefinition(
        name: 'student_name',
        label: 'Student Name',
        type: FormFieldType.text,
        isRequired: true),
    const FormFieldDefinition(
        name: 'grade_level',
        label: 'Grade Level',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Grade 5, Year 10'),
    const FormFieldDefinition(
        name: 'student_id',
        label: 'Student ID',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'emergency_contact',
        label: 'Emergency Contact',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'student_notes',
        label: 'Student Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.careerGoal: [
    const FormFieldDefinition(
        name: 'goal_title',
        label: 'Career Goal',
        type: FormFieldType.text,
        isRequired: true,
        hintText: 'e.g., Become Senior Developer'),
    const FormFieldDefinition(
        name: 'target_date',
        label: 'Target Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'current_progress',
        label: 'Current Progress',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'action_steps',
        label: 'Action Steps',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'career_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.employee: [
    const FormFieldDefinition(
        name: 'employee_name',
        label: 'Employee Name',
        type: FormFieldType.text,
        isRequired: true),
    const FormFieldDefinition(
        name: 'position',
        label: 'Position/Role',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'department',
        label: 'Department',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'start_date',
        label: 'Start Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'employee_email',
        label: 'Email',
        type: FormFieldType.email,
        isRequired: false),
    const FormFieldDefinition(
        name: 'employee_phone',
        label: 'Phone',
        type: FormFieldType.phone,
        isRequired: false),
    const FormFieldDefinition(
        name: 'employee_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.daysOff: [
    const FormFieldDefinition(
        name: 'leave_type',
        label: 'Leave Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'annual_leave', label: 'Annual Leave'),
          FormFieldOption(value: 'sick_leave', label: 'Sick Leave'),
          FormFieldOption(value: 'personal_leave', label: 'Personal Leave'),
          FormFieldOption(value: 'maternity_leave', label: 'Maternity Leave'),
          FormFieldOption(value: 'study_leave', label: 'Study Leave'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'start_date',
        label: 'Start Date',
        type: FormFieldType.date,
        isRequired: true),
    const FormFieldDefinition(
        name: 'end_date',
        label: 'End Date',
        type: FormFieldType.date,
        isRequired: true),
    const FormFieldDefinition(
        name: 'reason',
        label: 'Reason',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'approved',
        label: 'Approved',
        type: FormFieldType.boolean,
        isRequired: false),
  ],
  EntitySubtype.finance: [
    const FormFieldDefinition(
        name: 'account_type',
        label: 'Account Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'checking', label: 'Checking Account'),
          FormFieldOption(value: 'savings', label: 'Savings Account'),
          FormFieldOption(value: 'investment', label: 'Investment Account'),
          FormFieldOption(value: 'credit_card', label: 'Credit Card'),
          FormFieldOption(value: 'loan', label: 'Loan'),
          FormFieldOption(value: 'mortgage', label: 'Mortgage'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'account_number',
        label: 'Account Number',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'bank_name',
        label: 'Bank/Institution',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'balance',
        label: 'Current Balance',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'interest_rate',
        label: 'Interest Rate (%)',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'finance_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.food: [
    const FormFieldDefinition(
        name: 'food_type',
        label: 'Food Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'recipe', label: 'Recipe'),
          FormFieldOption(value: 'restaurant', label: 'Restaurant'),
          FormFieldOption(value: 'grocery_item', label: 'Grocery Item'),
          FormFieldOption(value: 'meal_plan', label: 'Meal Plan'),
          FormFieldOption(value: 'dietary_restriction', label: 'Dietary Restriction'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'cuisine_type',
        label: 'Cuisine Type',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Italian, Chinese, Mexican'),
    const FormFieldDefinition(
        name: 'ingredients',
        label: 'Ingredients',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'instructions',
        label: 'Instructions/Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'prep_time',
        label: 'Prep Time (minutes)',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'servings',
        label: 'Servings',
        type: FormFieldType.number,
        isRequired: false),
  ],
  EntitySubtype.foodPlan: [
    const FormFieldDefinition(
        name: 'plan_type',
        label: 'Plan Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'weekly_meal_plan', label: 'Weekly Meal Plan'),
          FormFieldOption(value: 'monthly_meal_plan', label: 'Monthly Meal Plan'),
          FormFieldOption(value: 'diet_plan', label: 'Diet Plan'),
          FormFieldOption(value: 'grocery_plan', label: 'Grocery Plan'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'start_date',
        label: 'Start Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'end_date',
        label: 'End Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'plan_details',
        label: 'Plan Details',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'shopping_list',
        label: 'Shopping List',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.garden: [
    const FormFieldDefinition(
        name: 'garden_type',
        label: 'Garden Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'vegetable_garden', label: 'Vegetable Garden'),
          FormFieldOption(value: 'flower_garden', label: 'Flower Garden'),
          FormFieldOption(value: 'herb_garden', label: 'Herb Garden'),
          FormFieldOption(value: 'fruit_garden', label: 'Fruit Garden'),
          FormFieldOption(value: 'indoor_garden', label: 'Indoor Garden'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'location',
        label: 'Location',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Backyard, Balcony, Greenhouse'),
    const FormFieldDefinition(
        name: 'size',
        label: 'Size',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., 10x10 feet, 5 pots'),
    const FormFieldDefinition(
        name: 'plants',
        label: 'Plants/Crops',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'planting_date',
        label: 'Planting Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'harvest_date',
        label: 'Expected Harvest Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'garden_notes',
        label: 'Garden Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.laundryPlan: [
    const FormFieldDefinition(
        name: 'schedule',
        label: 'Laundry Schedule',
        type: FormFieldType.text,
        isRequired: false,
        hintText: 'e.g., Every Monday, Twice a week'),
    const FormFieldDefinition(
        name: 'laundry_type',
        label: 'Laundry Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'regular_wash', label: 'Regular Wash'),
          FormFieldOption(value: 'delicate_wash', label: 'Delicate Wash'),
          FormFieldOption(value: 'dry_cleaning', label: 'Dry Cleaning'),
          FormFieldOption(value: 'hand_wash', label: 'Hand Wash'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'items',
        label: 'Items/Clothing',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'special_instructions',
        label: 'Special Instructions',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'laundry_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  EntitySubtype.home: [
    const FormFieldDefinition(
        name: 'home_type',
        label: 'Home Type',
        type: FormFieldType.dropdown,
        isRequired: false,
        options: [
          FormFieldOption(value: 'house', label: 'House'),
          FormFieldOption(value: 'apartment', label: 'Apartment'),
          FormFieldOption(value: 'condo', label: 'Condo'),
          FormFieldOption(value: 'townhouse', label: 'Townhouse'),
          FormFieldOption(value: 'other', label: 'Other'),
        ]),
    const FormFieldDefinition(
        name: 'address',
        label: 'Address',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'bedrooms',
        label: 'Bedrooms',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'bathrooms',
        label: 'Bathrooms',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'square_footage',
        label: 'Square Footage',
        type: FormFieldType.number,
        isRequired: false),
    const FormFieldDefinition(
        name: 'purchase_date',
        label: 'Purchase/Move-in Date',
        type: FormFieldType.date,
        isRequired: false),
    const FormFieldDefinition(
        name: 'home_notes',
        label: 'Home Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
  // Additional pet-related entities
  EntitySubtype.vet: [
    const FormFieldDefinition(
        name: 'clinic_name',
        label: 'Clinic Name',
        type: FormFieldType.text,
        isRequired: true),
    const FormFieldDefinition(
        name: 'vet_name',
        label: 'Veterinarian Name',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'address',
        label: 'Address',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'phone_number',
        label: 'Phone Number',
        type: FormFieldType.phone,
        isRequired: false),
    const FormFieldDefinition(
        name: 'email',
        label: 'Email',
        type: FormFieldType.email,
        isRequired: false),
    const FormFieldDefinition(
        name: 'emergency_hours',
        label: 'Emergency Hours',
        type: FormFieldType.text,
        isRequired: false),
    const FormFieldDefinition(
        name: 'specialties',
        label: 'Specialties',
        type: FormFieldType.multilineText,
        isRequired: false),
    const FormFieldDefinition(
        name: 'vet_notes',
        label: 'Notes',
        type: FormFieldType.multilineText,
        isRequired: false),
  ],
};
