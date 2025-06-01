// Defines the default, global entities for each category.
// This data is displayed when a user selects a category,
// showing predefined options rather than user-specific entities.
// Based on the original React app entity structure for 100% feature parity.

// Key: A string representing the category ID.
// Value: A list of strings, where each string is the name of a default entity.

const Map<String, List<String>> defaultGlobalEntities = {
  'pets': [
    "Pet", // Main pet entity
    "Dog",
    "Cat",
    "Bird",
    "Fish",
    "Small Mammal", // e.g., Hamster, Guinea Pig
    "Reptile",      // e.g., Lizard, Turtle
    "Vet", // Pet service providers
    "Walker",
    "Groomer",
    "Pet Sitter",
    "Microchip Company", // From React app
    "Insurance Company", // From React app
    "Insurance Policy", // From React app
    "Pet Birthday", // Special pet dates
    "Other Pet",
  ],
  
  'social_interests': [
    // Anniversary & Birthday entities (matching React app exactly)
    "Anniversary",
    "Birthday",
    "Anniversary Plan",
    
    // Core social event entities (matching React app)
    "Event",
    "Event Subentity", // From React app - for auto-created sub-entities
    "Holiday",
    "Holiday Plan",
    "Social Plan",
    "Social Media",
    "Hobby",
    "Guest List Invite", // From React app
    
    // Auto-created event subentities (from React app AutoSubentity system)
    "Food / Cake / Candles",
    "Activities / Venue", 
    "Party Favours / Games",
    "Gifts / Wrapping",
    "Music",
    "Decorations",
    
    // Extended social activities and contacts
    "Wedding",
    "Party",
    "Concert",
    "Sporting Event",
    "Meetup",
    "Club Activity",
    "Volunteer Event",
    "Contact",
    "Friend",
    "Family Friend",
    "Other Social Event",
  ],
  
  'education': [
    // Education planning entities
    "Academic Plan",
    "Extracurricular Plan",
    
    // School entities (from React app)
    "School", // From React app
    "School Year", // From React app - special calendar entity
    "School Term", // From React app - special calendar entity
    "School Break", // From React app - special calendar entity
    
    // Student entities and records
    "Student",
    "School Course",
    "University Module",
    "Online Course",
    "Workshop",
    "Seminar",
    "Textbook",
    "Study Group",
    "School Project",
    "Assignment",
    "Exam",
    
    // Academic staff (from React app)
    "Teacher", // From React app
    "Tutor", // From React app
    
    // Academic work (from React app)
    "CourseWork", // From React app
    "Subject", // From React app
    
    "Other Educational Item",
  ],
  
  'career': [
    // Career planning entities (matching React app exactly)
    "Career Goal",
    "Days Off",
    "Employee", // Employee records
    "Professional Entity",
    "Job Application",
    "Networking Event",
    "Conference",
    "Training Program",
    "Performance Review",
    "Work Project",
    "Professional Certification",
    "Salary Review",
    "Team Meeting",
    "Client Meeting",
    
    // Work relationships (from React app)
    "Colleague", // From React app
    "Work", // From React app
    
    "Other Career Item",
  ],
  
  'travel': [
    // Travel planning entities (matching React app)
    "Trip", // From React app
    "Travel Plan",
    "Holiday",
    "Holiday Plan",
    
    // Travel booking entities
    "Flight",
    "Train / Bus / Ferry",
    "Rental Car",
    "Taxi or Transfer",
    "Drive Time",
    "Hotel or Rental",
    "Stay with Friend",
    "Hotel Booking",
    "Train Journey",
    "Bus Trip",
    "Cruise",
    "Vacation Package",
    "Activity/Excursion",
    "Travel Visa",
    "Travel Insurance",
    "Other Travel Item",
  ],
  
  'health_beauty': [
    // Health & beauty entities (matching React app)
    "Health Beauty",
    "Health Goal",
    "Patient", // Patient records
    
    // Medical professionals (from React app)
    "Doctor", // From React app
    "Dentist", // From React app
    
    // Beauty professionals (from React app)
    "Beauty Salon", // From React app
    "Stylist", // From React app
    
    // Medical appointments
    "Appointment",
    "Doctor Appointment",
    "Dentist Appointment",
    "Optician Appointment",
    "Specialist Appointment",
    
    // Beauty and wellness
    "Haircut",
    "Spa Treatment",
    "Gym Membership",
    "Fitness Class",
    "Personal Trainer",
    "Medication Prescription",
    "Medical Test",
    "Health Insurance",
    "Other Health/Beauty Item",
  ],
  
  'home': [
    "Home", // Main home entity (matching React app)
    "Room", // From React app
    "Home Appliance",
    "Home Renovation Project",
    "Furniture",
    "Home Decor",
    "Utility Bill", // e.g., Electricity, Water, Gas
    "Internet/Cable Service",
    "Home Insurance",
    "Mortgage/Rent",
    "Home Maintenance",
    "Security System",
    "Cleaning Service",
    
    // Home services (from React app)
    "Contractor", // From React app
    
    "Other Home Item",
  ],
  
  'garden': [
    "Garden", // Main garden entity (matching React app)
    "Plant", // From React app
    "Tree",
    "Flower",
    "Vegetable Garden",
    "Herb Garden",
    "Gardening Tool", // From React app as "Tool"
    "Landscaping Project",
    "Pest Control",
    "Fertilizer/Soil",
    "Irrigation System",
    "Garden Furniture",
    "Other Garden Item",
  ],
  
  'food': [
    "Food", // Food entities (matching React app)
    "Food Plan", // From React app
    "Grocery Shopping List", // Could be an entity that links to a list
    "Meal Plan",
    "Recipe", // From React app
    "Restaurant", // From React app
    "Restaurant Reservation",
    "Food Subscription",
    "Cooking Class",
    "Kitchen Equipment",
    "Dietary Goal",
    "Nutrition Plan",
    "Other Food Item",
  ],
  
  'laundry': [
    "Clothing", // Main clothing entity (matching React app)
    "Item", // From React app
    "Laundry Plan",
    "Dry Cleaning",
    "Dry Cleaners", // From React app
    "Laundry Supplies", // e.g., Detergent, Softener
    "Wash Cycle Reminder",
    "Ironing",
    "Clothing Repair",
    "Wardrobe Organization",
    "Seasonal Clothing Storage",
    "Other Laundry Item",
  ],
  
  'finance': [
    "Finance", // Main finance entity (matching React app)
    "Bank", // From React app
    "Bank Account", // From React app
    "Credit Card", // From React app
    "Investment",
    "Loan",
    "Budget Plan",
    "Tax Return",
    "Subscription",
    "Insurance Policy (General)",
    "Financial Goal",
    "Expense Tracking",
    "Income Source",
    "Financial Advisor",
    "Other Financial Item",
  ],
  
  'transport': [
    // Vehicle entities (matching React app exactly)
    "Vehicle", // General vehicle entity from React app
    "Car", // From React app
    "Boat", // From React app
    "Motorcycle",
    "Bicycle",
    "Electric Scooter",
    
    // Public transport (from React app)
    "Public Transport", // From React app
    "Public Transport Pass", // e.g., Bus Pass, Train Card
    "Ride Sharing",          // e.g., Uber, Lyft account
    
    // Vehicle maintenance
    "Vehicle Insurance",
    "Vehicle Registration",
    "MOT/Inspection",
    "Vehicle Service",
    "Fuel Card",
    "Parking Pass",
    "Other Vehicle",
  ],
};
