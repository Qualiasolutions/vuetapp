import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/form_field_definition.dart';

final Map<EntitySubtype, List<FormFieldDefinition>> entityFormFields = {
  // ========== PETS CATEGORY (Category 1) - 8 entity types ==========
  EntitySubtype.pet: [
    const FormFieldDefinition(name: 'type', label: 'Pet Type', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Dog, Cat, Bird'),
    const FormFieldDefinition(name: 'breed', label: 'Breed', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'dob', label: 'Date of Birth', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'microchip_number', label: 'Microchip ID', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'notes', label: 'Notes', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.vet: [
    const FormFieldDefinition(name: 'clinic_name', label: 'Clinic Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'vet_name', label: 'Veterinarian Name', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
    const FormFieldDefinition(name: 'address', label: 'Address', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.walker: [
    const FormFieldDefinition(name: 'walker_name', label: 'Walker Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
    const FormFieldDefinition(name: 'rate', label: 'Rate per Walk', type: FormFieldType.number, isRequired: false),
  ],

  EntitySubtype.groomer: [
    const FormFieldDefinition(name: 'groomer_name', label: 'Groomer Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
    const FormFieldDefinition(name: 'services', label: 'Services Offered', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.sitter: [
    const FormFieldDefinition(name: 'sitter_name', label: 'Sitter Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
    const FormFieldDefinition(name: 'rate_per_day', label: 'Rate per Day', type: FormFieldType.number, isRequired: false),
  ],

  EntitySubtype.microchipCompany: [
    const FormFieldDefinition(name: 'company_name', label: 'Company Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
    const FormFieldDefinition(name: 'website', label: 'Website', type: FormFieldType.url, isRequired: false),
  ],

  EntitySubtype.insuranceCompany: [
    const FormFieldDefinition(name: 'company_name', label: 'Insurance Company', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
    const FormFieldDefinition(name: 'coverage_types', label: 'Coverage Types', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.insurancePolicy: [
    const FormFieldDefinition(name: 'policy_number', label: 'Policy Number', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'coverage_amount', label: 'Coverage Amount', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'premium', label: 'Monthly Premium', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'start_date', label: 'Policy Start Date', type: FormFieldType.date, isRequired: false),
  ],

  // ========== SOCIAL CATEGORY (Category 2) - 10 entity types ==========
  EntitySubtype.anniversary: [
    const FormFieldDefinition(name: 'anniversary_type', label: 'Anniversary Type', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Wedding, First Date'),
    const FormFieldDefinition(name: 'date', label: 'Anniversary Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'people_involved', label: 'People Involved', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.anniversaryPlan: [
    const FormFieldDefinition(name: 'plan_title', label: 'Plan Title', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'anniversary_date', label: 'Anniversary Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'activities', label: 'Planned Activities', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.birthday: [
    const FormFieldDefinition(name: 'person_name', label: 'Person Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'birthday_date', label: 'Birthday Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'age', label: 'Age (this year)', type: FormFieldType.number, isRequired: false),
  ],

  EntitySubtype.event: [
    const FormFieldDefinition(name: 'start_datetime', label: 'Start Date & Time', type: FormFieldType.dateTime, isRequired: true),
    const FormFieldDefinition(name: 'location', label: 'Location', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'attendees', label: 'Attendees', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.guestListInvite: [
    const FormFieldDefinition(name: 'guest_name', label: 'Guest Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'email', label: 'Email', type: FormFieldType.email, isRequired: false),
    const FormFieldDefinition(name: 'rsvp_status', label: 'RSVP Status', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'pending', label: 'Pending'),
      FormFieldOption(value: 'attending', label: 'Attending'),
      FormFieldOption(value: 'not_attending', label: 'Not Attending'),
    ]),
  ],

  EntitySubtype.hobby: [
    const FormFieldDefinition(name: 'hobby_type', label: 'Hobby Type', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Photography, Painting'),
    const FormFieldDefinition(name: 'skill_level', label: 'Skill Level', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'beginner', label: 'Beginner'),
      FormFieldOption(value: 'intermediate', label: 'Intermediate'),
      FormFieldOption(value: 'advanced', label: 'Advanced'),
    ]),
  ],

  EntitySubtype.holiday: [
    const FormFieldDefinition(name: 'destination', label: 'Destination', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'start_date', label: 'Start Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'end_date', label: 'End Date', type: FormFieldType.date, isRequired: true),
  ],

  EntitySubtype.holidayPlan: [
    const FormFieldDefinition(name: 'plan_title', label: 'Plan Title', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'destination', label: 'Destination', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'activities', label: 'Planned Activities', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.socialMedia: [
    const FormFieldDefinition(name: 'platform', label: 'Platform', type: FormFieldType.dropdown, isRequired: true, options: [
      FormFieldOption(value: 'facebook', label: 'Facebook'),
      FormFieldOption(value: 'instagram', label: 'Instagram'),
      FormFieldOption(value: 'twitter', label: 'Twitter'),
      FormFieldOption(value: 'linkedin', label: 'LinkedIn'),
    ]),
    const FormFieldDefinition(name: 'username', label: 'Username/Handle', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.socialPlan: [
    const FormFieldDefinition(name: 'plan_type', label: 'Plan Type', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Dinner Party, Game Night'),
    const FormFieldDefinition(name: 'date', label: 'Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'location', label: 'Location', type: FormFieldType.text, isRequired: false),
  ],

  // ========== EDUCATION CATEGORY (Category 3) - 8 entity types ==========
  EntitySubtype.academicPlan: [
    const FormFieldDefinition(name: 'plan_title', label: 'Plan Title', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'institution', label: 'Institution', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'start_date', label: 'Start Date', type: FormFieldType.date, isRequired: false),
  ],

  EntitySubtype.courseWork: [
    const FormFieldDefinition(name: 'course_name', label: 'Course Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'instructor', label: 'Instructor', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'semester', label: 'Semester/Term', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.extracurricularPlan: [
    const FormFieldDefinition(name: 'activity_name', label: 'Activity Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'organization', label: 'Organization/Club', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'schedule', label: 'Schedule', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.school: [
    const FormFieldDefinition(name: 'school_type', label: 'School Type', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'elementary', label: 'Elementary School'),
      FormFieldOption(value: 'high', label: 'High School'),
      FormFieldOption(value: 'university', label: 'University'),
    ]),
    const FormFieldDefinition(name: 'address', label: 'Address', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.student: [
    const FormFieldDefinition(name: 'student_name', label: 'Student Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'grade_level', label: 'Grade Level', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'student_id', label: 'Student ID', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.subject: [
    const FormFieldDefinition(name: 'subject_name', label: 'Subject Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'subject_code', label: 'Subject Code', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'grade_level', label: 'Grade Level', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.teacher: [
    const FormFieldDefinition(name: 'teacher_name', label: 'Teacher Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'subject_taught', label: 'Subject Taught', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'contact_email', label: 'Contact Email', type: FormFieldType.email, isRequired: false),
  ],

  EntitySubtype.tutor: [
    const FormFieldDefinition(name: 'tutor_name', label: 'Tutor Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'subject_speciality', label: 'Subject Speciality', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'hourly_rate', label: 'Hourly Rate', type: FormFieldType.number, isRequired: false),
  ],

  // ========== CAREER CATEGORY (Category 4) - 2 entity types ==========
  EntitySubtype.colleague: [
    const FormFieldDefinition(name: 'colleague_name', label: 'Colleague Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'position', label: 'Position/Role', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'department', label: 'Department', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.work: [
    const FormFieldDefinition(name: 'company_name', label: 'Company Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'job_title', label: 'Job Title', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'start_date', label: 'Start Date', type: FormFieldType.date, isRequired: false),
  ],

  // ========== TRAVEL CATEGORY (Category 5) - 1 entity type ==========
  EntitySubtype.trip: [
    const FormFieldDefinition(name: 'destination', label: 'Destination', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'start_date', label: 'Start Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'end_date', label: 'End Date', type: FormFieldType.date, isRequired: true),
  ],

  // ========== HEALTH CATEGORY (Category 6) - 4 entity types ==========
  EntitySubtype.beautySalon: [
    const FormFieldDefinition(name: 'salon_name', label: 'Salon Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'services', label: 'Services Offered', type: FormFieldType.multilineText, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.dentist: [
    const FormFieldDefinition(name: 'dentist_name', label: 'Dentist Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'practice_name', label: 'Practice Name', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.doctor: [
    const FormFieldDefinition(name: 'doctor_name', label: 'Doctor Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'specialty', label: 'Specialty', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'practice_name', label: 'Practice/Hospital Name', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.stylist: [
    const FormFieldDefinition(name: 'stylist_name', label: 'Stylist Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'salon_name', label: 'Salon Name', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'specialties', label: 'Specialties', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.therapist: [
    const FormFieldDefinition(name: 'therapist_name', label: 'Therapist Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'specialty', label: 'Specialty', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'practice_name', label: 'Practice Name', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.physiotherapist: [
    const FormFieldDefinition(name: 'physio_name', label: 'Physiotherapist Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'clinic_name', label: 'Clinic Name', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.specialist: [
    const FormFieldDefinition(name: 'specialist_name', label: 'Specialist Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'specialty', label: 'Specialty', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'hospital', label: 'Hospital/Practice', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.surgeon: [
    const FormFieldDefinition(name: 'surgeon_name', label: 'Surgeon Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'specialty', label: 'Specialty', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'hospital', label: 'Hospital', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  // ========== HOME CATEGORY (Category 7) - 5 entity types ==========
  EntitySubtype.appliance: [
    const FormFieldDefinition(name: 'appliance_type', label: 'Appliance Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'brand', label: 'Brand', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'model_number', label: 'Model Number', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.contractor: [
    const FormFieldDefinition(name: 'contractor_name', label: 'Contractor Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'trade_type', label: 'Trade Type', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.furniture: [
    const FormFieldDefinition(name: 'furniture_type', label: 'Furniture Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'brand', label: 'Brand', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'room_location', label: 'Room Location', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.home: [
    const FormFieldDefinition(name: 'home_type', label: 'Home Type', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'house', label: 'House'),
      FormFieldOption(value: 'apartment', label: 'Apartment'),
      FormFieldOption(value: 'condo', label: 'Condo'),
    ]),
    const FormFieldDefinition(name: 'address', label: 'Address', type: FormFieldType.multilineText, isRequired: false),
  ],

  EntitySubtype.room: [
    const FormFieldDefinition(name: 'room_name', label: 'Room Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'room_type', label: 'Room Type', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'bedroom', label: 'Bedroom'),
      FormFieldOption(value: 'kitchen', label: 'Kitchen'),
      FormFieldOption(value: 'living_room', label: 'Living Room'),
    ]),
  ],

  // ========== GARDEN CATEGORY (Category 8) - 2 entity types ==========
  EntitySubtype.plant: [
    const FormFieldDefinition(name: 'plant_name', label: 'Plant Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'plant_type', label: 'Plant Type', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'flower', label: 'Flower'),
      FormFieldOption(value: 'vegetable', label: 'Vegetable'),
      FormFieldOption(value: 'herb', label: 'Herb'),
    ]),
    const FormFieldDefinition(name: 'location', label: 'Location', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.tool: [
    const FormFieldDefinition(name: 'tool_name', label: 'Tool Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'brand', label: 'Brand', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'maintenance_schedule', label: 'Maintenance Schedule', type: FormFieldType.text, isRequired: false),
  ],

  // ========== FOOD CATEGORY (Category 9) - 3 entity types ==========
  EntitySubtype.foodPlan: [
    const FormFieldDefinition(name: 'plan_type', label: 'Plan Type', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'weekly_meal_plan', label: 'Weekly Meal Plan'),
      FormFieldOption(value: 'diet_plan', label: 'Diet Plan'),
      FormFieldOption(value: 'grocery_plan', label: 'Grocery Plan'),
    ]),
    const FormFieldDefinition(name: 'start_date', label: 'Start Date', type: FormFieldType.date, isRequired: false),
  ],

  EntitySubtype.recipe: [
    const FormFieldDefinition(name: 'recipe_name', label: 'Recipe Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'cuisine_type', label: 'Cuisine Type', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'ingredients', label: 'Ingredients', type: FormFieldType.multilineText, isRequired: true),
  ],

  EntitySubtype.restaurant: [
    const FormFieldDefinition(name: 'restaurant_name', label: 'Restaurant Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'cuisine_type', label: 'Cuisine Type', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'address', label: 'Address', type: FormFieldType.multilineText, isRequired: false),
  ],

  // ========== LAUNDRY CATEGORY (Category 10) - 2 entity types ==========
  EntitySubtype.item: [
    const FormFieldDefinition(name: 'item_name', label: 'Item Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'care_instructions', label: 'Care Instructions', type: FormFieldType.multilineText, isRequired: false),
    const FormFieldDefinition(name: 'color', label: 'Color', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.dryCleaners: [
    const FormFieldDefinition(name: 'business_name', label: 'Business Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'address', label: 'Address', type: FormFieldType.multilineText, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  // ========== FINANCE CATEGORY (Category 11) - 3 entity types ==========
  EntitySubtype.bank: [
    const FormFieldDefinition(name: 'bank_name', label: 'Bank Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'branch_address', label: 'Branch Address', type: FormFieldType.multilineText, isRequired: false),
    const FormFieldDefinition(name: 'phone_number', label: 'Phone Number', type: FormFieldType.phone, isRequired: false),
  ],

  EntitySubtype.bankAccount: [
    const FormFieldDefinition(name: 'account_type', label: 'Account Type', type: FormFieldType.dropdown, isRequired: false, options: [
      FormFieldOption(value: 'checking', label: 'Checking'),
      FormFieldOption(value: 'savings', label: 'Savings'),
      FormFieldOption(value: 'investment', label: 'Investment'),
    ]),
    const FormFieldDefinition(name: 'account_number', label: 'Account Number', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.creditCard: [
    const FormFieldDefinition(name: 'card_name', label: 'Card Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'last_four_digits', label: 'Last Four Digits', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'expiry_date', label: 'Expiry Date', type: FormFieldType.date, isRequired: false),
  ],

  // ========== TRANSPORT CATEGORY (Category 12) - Enhanced with user invitations & photo upload ==========
  EntitySubtype.car: [
    const FormFieldDefinition(name: 'photo', label: 'Vehicle Photo', type: FormFieldType.imagePicker, isRequired: false, hintText: '1- TAKE PHOTO  2- CHOOSE PHOTO'),
    const FormFieldDefinition(name: 'make', label: 'Make', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Toyota, Honda'),
    const FormFieldDefinition(name: 'model', label: 'Model', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Camry, Accord'),
    const FormFieldDefinition(name: 'year', label: 'Year', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'registration', label: 'Registration/License Plate', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'color', label: 'Color', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'vin', label: 'VIN Number', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'insurance_expiry', label: 'Insurance Expiry', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'registration_expiry', label: 'Registration Expiry', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'members', label: 'Invite Users', type: FormFieldType.memberPicker, isRequired: false, hintText: 'Share this car with family members'),
  ],

  EntitySubtype.motorcycle: [
    const FormFieldDefinition(name: 'photo', label: 'Vehicle Photo', type: FormFieldType.imagePicker, isRequired: false, hintText: '1- TAKE PHOTO  2- CHOOSE PHOTO'),
    const FormFieldDefinition(name: 'make', label: 'Make', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'model', label: 'Model', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'year', label: 'Year', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'registration', label: 'Registration/License Plate', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'engine_size', label: 'Engine Size (cc)', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'insurance_expiry', label: 'Insurance Expiry', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'members', label: 'Invite Users', type: FormFieldType.memberPicker, isRequired: false, hintText: 'Share this motorcycle with family members'),
  ],

  EntitySubtype.boat: [
    const FormFieldDefinition(name: 'photo', label: 'Boat Photo', type: FormFieldType.imagePicker, isRequired: false, hintText: '1- TAKE PHOTO  2- CHOOSE PHOTO'),
    const FormFieldDefinition(name: 'boat_type', label: 'Boat Type', type: FormFieldType.text, isRequired: true, hintText: 'e.g., Sailboat, Speedboat'),
    const FormFieldDefinition(name: 'make', label: 'Make', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'model', label: 'Model', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'length', label: 'Length (ft)', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'registration_number', label: 'Registration Number', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'hull_id', label: 'Hull ID', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'dock_location', label: 'Dock/Storage Location', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'insurance_expiry', label: 'Insurance Expiry', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'members', label: 'Invite Users', type: FormFieldType.memberPicker, isRequired: false, hintText: 'Share this boat with family members'),
  ],

  EntitySubtype.publicTransport: [
    const FormFieldDefinition(name: 'photo', label: 'Transport Photo', type: FormFieldType.imagePicker, isRequired: false, hintText: '1- TAKE PHOTO  2- CHOOSE PHOTO'),
    const FormFieldDefinition(name: 'transport_type', label: 'Transport Type', type: FormFieldType.dropdown, isRequired: true, options: [
      FormFieldOption(value: 'bus', label: 'Bus'),
      FormFieldOption(value: 'train', label: 'Train'),
      FormFieldOption(value: 'subway', label: 'Subway/Metro'),
      FormFieldOption(value: 'tram', label: 'Tram'),
      FormFieldOption(value: 'taxi', label: 'Taxi'),
      FormFieldOption(value: 'rideshare', label: 'Rideshare'),
      FormFieldOption(value: 'other', label: 'Other'),
    ]),
    const FormFieldDefinition(name: 'route_number', label: 'Route/Line Number', type: FormFieldType.text, isRequired: false, hintText: 'e.g., Route 42, Line A'),
    const FormFieldDefinition(name: 'operator', label: 'Operator/Company', type: FormFieldType.text, isRequired: false, hintText: 'e.g., Metro Transit, Uber'),
    const FormFieldDefinition(name: 'description', label: 'Description', type: FormFieldType.multilineText, isRequired: false, hintText: 'Describe your public transport details'),
    const FormFieldDefinition(name: 'members', label: 'Invite Users', type: FormFieldType.memberPicker, isRequired: false, hintText: 'Share this transport info with family members'),
  ],

  EntitySubtype.other: [
    const FormFieldDefinition(name: 'photo', label: 'Vehicle Photo', type: FormFieldType.imagePicker, isRequired: false, hintText: '1- TAKE PHOTO  2- CHOOSE PHOTO'),
    const FormFieldDefinition(name: 'vehicle_type', label: 'Vehicle Type', type: FormFieldType.dropdown, isRequired: true, options: [
      FormFieldOption(value: 'other', label: 'Other Vehicle'),
    ]),
    const FormFieldDefinition(name: 'make', label: 'Make/Brand', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'model', label: 'Model', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'year', label: 'Year', type: FormFieldType.number, isRequired: false),
    const FormFieldDefinition(name: 'registration', label: 'Registration/License Plate', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'serial_number', label: 'Serial/VIN Number', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'specifications', label: 'Specifications', type: FormFieldType.multilineText, isRequired: false, hintText: 'Engine size, capacity, dimensions, etc.'),
    const FormFieldDefinition(name: 'insurance_expiry', label: 'Insurance Expiry', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'members', label: 'Invite Users', type: FormFieldType.memberPicker, isRequired: false, hintText: 'Share this vehicle with family members'),
  ],

  // ========== DOCUMENTS CATEGORY (Category 14) - 11 entity types ==========
  EntitySubtype.document: [
    const FormFieldDefinition(name: 'doc_type', label: 'Document Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'date_issued', label: 'Date Issued', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'expiry_date', label: 'Expiry Date', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'reference_number', label: 'Reference Number', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'location', label: 'Storage Location', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.passport: [
    const FormFieldDefinition(name: 'passport_number', label: 'Passport Number', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'country', label: 'Country of Issue', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'issue_date', label: 'Issue Date', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'expiry_date', label: 'Expiry Date', type: FormFieldType.date, isRequired: true),
  ],

  EntitySubtype.license: [
    const FormFieldDefinition(name: 'license_type', label: 'License Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'license_number', label: 'License Number', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'issuing_authority', label: 'Issuing Authority', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'issue_date', label: 'Issue Date', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'expiry_date', label: 'Expiry Date', type: FormFieldType.date, isRequired: true),
  ],

  EntitySubtype.bankStatement: [
    const FormFieldDefinition(name: 'bank_name', label: 'Bank Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'account_number', label: 'Account Number', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'statement_date', label: 'Statement Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'statement_period', label: 'Statement Period', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.taxDocument: [
    const FormFieldDefinition(name: 'tax_year', label: 'Tax Year', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'document_type', label: 'Document Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'filing_date', label: 'Filing Date', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'reference_number', label: 'Reference Number', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.contract: [
    const FormFieldDefinition(name: 'contract_type', label: 'Contract Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'parties_involved', label: 'Parties Involved', type: FormFieldType.multilineText, isRequired: true),
    const FormFieldDefinition(name: 'start_date', label: 'Start Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'end_date', label: 'End Date', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'value', label: 'Contract Value', type: FormFieldType.number, isRequired: false),
  ],

  EntitySubtype.will: [
    const FormFieldDefinition(name: 'creation_date', label: 'Creation Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'executor', label: 'Executor', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'attorney', label: 'Attorney', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'storage_location', label: 'Storage Location', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.medicalRecord: [
    const FormFieldDefinition(name: 'patient_name', label: 'Patient Name', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'record_type', label: 'Record Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'date', label: 'Record Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'provider', label: 'Healthcare Provider', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.prescription: [
    const FormFieldDefinition(name: 'medication', label: 'Medication', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'doctor', label: 'Prescribing Doctor', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'issue_date', label: 'Issue Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'dosage', label: 'Dosage', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'refills', label: 'Refills', type: FormFieldType.number, isRequired: false),
  ],

  EntitySubtype.resume: [
    const FormFieldDefinition(name: 'version', label: 'Version/Revision', type: FormFieldType.text, isRequired: false),
    const FormFieldDefinition(name: 'last_updated', label: 'Last Updated', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'target_job', label: 'Target Job/Industry', type: FormFieldType.text, isRequired: false),
  ],

  EntitySubtype.certificate: [
    const FormFieldDefinition(name: 'certificate_type', label: 'Certificate Type', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'issuing_organization', label: 'Issuing Organization', type: FormFieldType.text, isRequired: true),
    const FormFieldDefinition(name: 'issue_date', label: 'Issue Date', type: FormFieldType.date, isRequired: true),
    const FormFieldDefinition(name: 'expiry_date', label: 'Expiry Date', type: FormFieldType.date, isRequired: false),
    const FormFieldDefinition(name: 'credential_id', label: 'Credential ID', type: FormFieldType.text, isRequired: false),
  ],

  // ========== GENERAL ENTITY TYPE ==========
  EntitySubtype.general: [
    const FormFieldDefinition(name: 'photo', label: 'Photo', type: FormFieldType.imagePicker, isRequired: false, hintText: '1- Take Photo  2- Choose Photo'),
    const FormFieldDefinition(name: 'category', label: 'Category', type: FormFieldType.text, isRequired: false, hintText: 'What type of item is this?'),
    const FormFieldDefinition(name: 'location', label: 'Location', type: FormFieldType.text, isRequired: false, hintText: 'Where is this stored or located?'),
    const FormFieldDefinition(name: 'notes', label: 'Notes', type: FormFieldType.multilineText, isRequired: false, hintText: 'Additional details or information'),
    const FormFieldDefinition(name: 'members', label: 'Invite Users', type: FormFieldType.memberPicker, isRequired: false, hintText: 'Share this item with family members'),
  ],
};
