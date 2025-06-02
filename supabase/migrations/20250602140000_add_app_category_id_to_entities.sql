-- Add app_category_id column to entities table
ALTER TABLE public.entities
ADD COLUMN IF NOT EXISTS app_category_id INTEGER;

-- Add index for performance
CREATE INDEX IF NOT EXISTS idx_entities_app_category_id
ON public.entities(app_category_id);

COMMENT ON COLUMN public.entities.app_category_id IS 'Numeric identifier for app categories, used for mapping entity subtypes to their categories.';

-- Update existing entities to set app_category_id based on subtype
DO $$
BEGIN
    -- Pet category (1)
    UPDATE public.entities SET app_category_id = 1
    WHERE subtype IN ('Pet', 'Vet', 'Pet Walker', 'Pet Groomer', 'Pet Sitter', 
                    'Microchip Company', 'Pet Insurance Company', 'Pet Insurance Policy');
    
    -- Social category (2)
    UPDATE public.entities SET app_category_id = 2
    WHERE subtype IN ('Anniversary', 'Anniversary Plan', 'Birthday', 'Event', 'Guest List Invite', 
                    'Hobby', 'Holiday', 'Holiday Plan', 'Social Media', 'Social Plan');
    
    -- Education category (3)
    UPDATE public.entities SET app_category_id = 3
    WHERE subtype IN ('Academic Plan', 'Course Work', 'Extracurricular Plan', 'School', 
                    'Student', 'Subject', 'Teacher', 'Tutor');
    
    -- Career category (4)
    UPDATE public.entities SET app_category_id = 4
    WHERE subtype IN ('Colleague', 'Work');
    
    -- Travel category (5)
    UPDATE public.entities SET app_category_id = 5
    WHERE subtype IN ('Trip');
    
    -- Health category (6)
    UPDATE public.entities SET app_category_id = 6
    WHERE subtype IN ('Beauty Salon', 'Dentist', 'Doctor', 'Stylist', 'Therapist', 
                    'Physiotherapist', 'Medical Specialist', 'Surgeon');
    
    -- Home category (7)
    UPDATE public.entities SET app_category_id = 7
    WHERE subtype IN ('Appliance', 'Contractor', 'Furniture', 'Home', 'Room');
    
    -- Garden category (8)
    UPDATE public.entities SET app_category_id = 8
    WHERE subtype IN ('Garden Tool', 'Plant');
    
    -- Food category (9)
    UPDATE public.entities SET app_category_id = 9
    WHERE subtype IN ('Food Plan', 'Recipe', 'Restaurant');
    
    -- Laundry category (10)
    UPDATE public.entities SET app_category_id = 10
    WHERE subtype IN ('Dry Cleaners', 'Laundry Item');
    
    -- Finance category (11)
    UPDATE public.entities SET app_category_id = 11
    WHERE subtype IN ('Bank', 'Bank Account', 'Credit Card');
    
    -- Transport category (12)
    UPDATE public.entities SET app_category_id = 12
    WHERE subtype IN ('Boat', 'Car', 'vehicle_car', 'Public Transport', 'Motorcycle', 
                    'Bicycle', 'Truck', 'Van', 'RV', 'ATV', 'Jet Ski');
    
    -- Documents category (14)
    UPDATE public.entities SET app_category_id = 14
    WHERE subtype IN ('Document', 'Passport', 'License', 'Bank Statement', 'Tax Document',
                    'Contract', 'Will', 'Medical Record', 'Prescription', 'Resume', 'Certificate');
END $$; 