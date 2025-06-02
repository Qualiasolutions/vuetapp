-- Migration to populate entity_subcategories

-- Clear existing data to prevent duplicates if script is re-run during development
-- DELETE FROM public.entity_subcategories;

INSERT INTO public.entity_subcategories (id, category_id, name, display_name, icon, entity_types, created_at, updated_at, color, tag_name)
VALUES
-- Pets (Category UUID: 550e8400-e29b-41d4-a716-446655440010)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'pet', 'Pet', 'pet_entity_icon', '{"pet"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'vet', 'Vet', 'vet_entity_icon', '{"vet"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'pet_walker', 'Pet Walker', 'walker_entity_icon', '{"pet_walker"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'pet_groomer', 'Pet Groomer', 'groomer_entity_icon', '{"pet_groomer"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'pet_sitter', 'Pet Sitter', 'sitter_entity_icon', '{"pet_sitter"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'microchip_company', 'Microchip Company', NULL, '{"microchip_company"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'insurance_company_pet', 'Pet Insurance Company', NULL, '{"insurance_company_pet"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440010', 'insurance_policy_pet', 'Pet Insurance Policy', NULL, '{"insurance_policy_pet"}', NOW(), NOW(), NULL, NULL),

-- Social Interests (Category UUID: c0ae5333-45c7-418c-99a7-5a681f8b2129)
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'event', 'Event', 'event_entity_icon', '{"event"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'hobby', 'Hobby', 'hobby_entity_icon', '{"hobby"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'holiday', 'Holiday', 'holiday_entity_icon', '{"holiday"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'holiday_plan', 'Holiday Plan', NULL, '{"holiday_plan"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'social_plan', 'Social Plan', NULL, '{"social_plan"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'social_media', 'Social Media', NULL, '{"social_media"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'anniversary_plan', 'Anniversary Plan', NULL, '{"anniversary_plan"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'birthday', 'Birthday', NULL, '{"birthday"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'anniversary', 'Anniversary', NULL, '{"anniversary"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'c0ae5333-45c7-418c-99a7-5a681f8b2129', 'guest_list_invite', 'Guest List Invite', NULL, '{"guest_list_invite"}', NOW(), NOW(), NULL, NULL),

-- Education (Category UUID: d7784cf4-7204-47f5-a756-bdb435e0a6db)
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'school', 'School', 'school_entity_icon', '{"school"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'subject', 'Subject', NULL, '{"subject"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'course_work', 'Course Work', NULL, '{"course_work"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'teacher', 'Teacher', NULL, '{"teacher"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'tutor', 'Tutor', NULL, '{"tutor"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'academic_plan', 'Academic Plan', NULL, '{"academic_plan"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'extracurricular_plan', 'Extracurricular Plan', NULL, '{"extracurricular_plan"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'd7784cf4-7204-47f5-a756-bdb435e0a6db', 'student', 'Student', NULL, '{"student"}', NOW(), NOW(), NULL, NULL),

-- Career (Category UUID: 876e7c22-b5e1-4bb4-b1e0-272be372ce97)
(uuid_generate_v4(), '876e7c22-b5e1-4bb4-b1e0-272be372ce97', 'work', 'Work', 'work_entity_icon', '{"work"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '876e7c22-b5e1-4bb4-b1e0-272be372ce97', 'colleague', 'Colleague', NULL, '{"colleague"}', NOW(), NOW(), NULL, NULL),

-- Travel (Category UUID: 550e8400-e29b-41d4-a716-446655440013)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440013', 'trip', 'Trip', 'trip_entity_icon', '{"trip"}', NOW(), NOW(), NULL, NULL),

-- Health & Beauty (Category UUID: f651311c-7d92-44ce-bd85-9b47c8381cec)
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'doctor', 'Doctor', 'doctor_entity_icon', '{"doctor"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'dentist', 'Dentist', 'dentist_entity_icon', '{"dentist"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'beauty_salon', 'Beauty Salon', NULL, '{"beauty_salon"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'stylist', 'Stylist', NULL, '{"stylist"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'document', 'Document', 'description', '{"document"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'passport', 'Passport', 'flight_takeoff', '{"passport"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'license', 'License', 'card_membership', '{"license"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'bank_statement', 'Bank Statement', 'account_balance', '{"bank_statement"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'tax_document', 'Tax Document', 'receipt', '{"tax_document"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'contract', 'Contract', 'article', '{"contract"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'will', 'Will', 'gavel', '{"will"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'medical_record', 'Medical Record', 'medical_services', '{"medical_record"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'prescription', 'Prescription', 'medication', '{"prescription"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'resume', 'Resume', 'person', '{"resume"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'certificate', 'Certificate', 'emoji_events', '{"certificate"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'therapist', 'Therapist', 'psychology', '{"therapist"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'physiotherapist', 'Physiotherapist', 'fitness_center', '{"physiotherapist"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'specialist', 'Medical Specialist', 'science', '{"specialist"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'f651311c-7d92-44ce-bd85-9b47c8381cec', 'surgeon', 'Surgeon', 'healing', '{"surgeon"}', NOW(), NOW(), NULL, NULL),

-- Home (Category UUID: 550e8400-e29b-41d4-a716-446655440011)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'home', 'Home', 'home_entity_icon', '{"home"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'room', 'Room', NULL, '{"room"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'furniture', 'Furniture', NULL, '{"furniture"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'appliance', 'Appliance', NULL, '{"appliance"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'contractor', 'Contractor', NULL, '{"contractor"}', NOW(), NOW(), NULL, NULL),

-- Garden (under Home category) (Category UUID: 550e8400-e29b-41d4-a716-446655440011)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'plant', 'Plant', 'plant_entity_icon', '{"plant"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'garden_tool', 'Garden Tool', NULL, '{"garden_tool"}', NOW(), NOW(), NULL, NULL),

-- Food (under Home category) (Category UUID: 550e8400-e29b-41d4-a716-446655440011)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'food_plan', 'Food Plan', 'food_plan_entity_icon', '{"food_plan"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'recipe', 'Recipe', NULL, '{"recipe"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'restaurant', 'Restaurant', NULL, '{"restaurant"}', NOW(), NOW(), NULL, NULL),

-- Laundry (under Home category) (Category UUID: 550e8400-e29b-41d4-a716-446655440011)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'laundry_item', 'Laundry Item', NULL, '{"laundry_item"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440011', 'dry_cleaners', 'Dry Cleaners', NULL, '{"dry_cleaners"}', NOW(), NOW(), NULL, NULL),

-- Finance (Category UUID: a0fb4f84-5805-4236-bcd9-ccaa34ccde81)
(uuid_generate_v4(), 'a0fb4f84-5805-4236-bcd9-ccaa34ccde81', 'bank', 'Bank', 'bank_entity_icon', '{"bank"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'a0fb4f84-5805-4236-bcd9-ccaa34ccde81', 'credit_card', 'Credit Card', NULL, '{"credit_card"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), 'a0fb4f84-5805-4236-bcd9-ccaa34ccde81', 'bank_account', 'Bank Account', NULL, '{"bank_account"}', NOW(), NOW(), NULL, NULL),

-- Transport (Category UUID: 550e8400-e29b-41d4-a716-446655440012)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'vehicle_car', 'Car', 'car_entity_icon', '{"vehicle_car"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'vehicle_boat', 'Boat', 'boat_entity_icon', '{"vehicle_boat"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'public_transport', 'Public Transport', NULL, '{"public_transport"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'motorcycle', 'Motorcycle', 'two_wheeler', '{"motorcycle"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'bicycle', 'Bicycle', 'pedal_bike', '{"bicycle"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'truck', 'Truck', 'local_shipping', '{"truck"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'van', 'Van', 'airport_shuttle', '{"van"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'rv', 'RV', 'rv_hookup', '{"rv"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'atv', 'ATV', 'terrain', '{"atv"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440012', 'jet_ski', 'Jet Ski', 'waves', '{"jet_ski"}', NOW(), NOW(), NULL, NULL),

-- Documents (Category UUID: 550e8400-e29b-41d4-a716-446655440014)
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'document', 'Document', 'description', '{"document"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'passport', 'Passport', 'flight_takeoff', '{"passport"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'license', 'License', 'card_membership', '{"license"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'bank_statement', 'Bank Statement', 'account_balance', '{"bank_statement"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'tax_document', 'Tax Document', 'receipt', '{"tax_document"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'contract', 'Contract', 'article', '{"contract"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'will', 'Will', 'gavel', '{"will"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'medical_record', 'Medical Record', 'medical_services', '{"medical_record"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'prescription', 'Prescription', 'medication', '{"prescription"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'resume', 'Resume', 'person', '{"resume"}', NOW(), NOW(), NULL, NULL),
(uuid_generate_v4(), '550e8400-e29b-41d4-a716-446655440014', 'certificate', 'Certificate', 'emoji_events', '{"certificate"}', NOW(), NOW(), NULL, NULL)
ON CONFLICT (name) DO NOTHING;

-- Optional: Add comments to columns
COMMENT ON TABLE public.entity_subcategories IS 'Stores specific entity subtypes, linking them to a broader entity_category.';
COMMENT ON COLUMN public.entity_subcategories.name IS 'The unique string identifier for the subcategory, matching EntitySubtype enum values (e.g., ''pet'', ''course_work'').';
COMMENT ON COLUMN public.entity_subcategories.category_id IS 'FK to public.entity_categories table, defining the main category this subcategory belongs to.';
COMMENT ON COLUMN public.entity_subcategories.entity_types IS 'Array of entity type string identifiers this subcategory represents. Typically a single entry matching the ''name'' column.'; 