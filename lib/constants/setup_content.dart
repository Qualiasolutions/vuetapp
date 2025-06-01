// Setup content for categories and entity types, based on React app setup flows
// This provides educational content to guide users through proper category usage

class SetupContent {
  // Category setup pages - matches React's SETUP_TEXT_PAGES exactly
  static const Map<String, List<String>> categorySetupPages = {
    'pets': [
      'The Pets Category allows users to keep up with their pets individually or as a group. The first step is to enter the pets as an Entity.',
      'Once Pets are added, users can set up feeding, grooming/cleaning, exercise and health schedules individually or as a group by choosing from the subcategories.'
    ],
    'social_interests': [
      'The Social Category allows users to better organise their social diaries. The first step recommended would be to enter Birthdays and Anniversaries and Holidays I Celebrate using the subcategories provided.',
      'Other examples of items that can be added are listed within each category.'
    ],
    'education': [
      'The Education category allows users to better organise their academic diaries and tasks. The first step recommended would be to enter Students, Schools and School Terms into the subcategories. These will be added as tags and dates added to the calendar.',
      'Once these are added, academic (eg Homework or math) and extracurricular goals (eg swimming) tasks, appointments and due dates can be added and actioned.'
    ],
    'career': [
      'The Career category allows users to better organise their work diaries and tasks. This is meant to be Career goals for growth and tracking days off and important employee details. For work tasks, use the toggle on Categories to switch to the Professional version.'
    ],
    'travel': [
      'The Travel Category allows users to plan travel and bucket lists and once a trip is decided to plan and view the trip at a glance to check that transport, accommodation or activities you want to pre-book are sorted and in the calendar. To get started, add a trip under "My Trips" or add a new entity under "My travel plans" for bucket lists or locations of interest.',
      'My Travel Information is a place to add passport numbers as References and action around expiration dates. Other items that could be added here include Frequent Flier numbers, logins for car rentals, travel membership details and expiration dates.'
    ],
    'health_beauty': [
      'The Health and Beauty category is intended to help users take the best care of themselves. The first step recommended would be to enter People whose appointments are needed to manage. After this, enter Appointment Types. This could be Dental, Eye, Diabetes, Haircuts.',
      'Once these tags are available, start planning and tagging track people and/or appointment types.',
      'For Health & Beauty Goals, you might make a goal to go to the gym every day or measure yourself daily or weekly and track using one of the Lists Templates. Medical information such as insurance can be stored in References.'
    ],
    'transport': [
      'Transport Category allows users to record and action due dates and tasks for automobiles, motorcycles, boats, bicycles and more. Even Public Transportation.',
      'Remember service dates, MOTs, insurance, warranty. Wash the car(s) monthly.',
      'To get started, Choose "Cars & Motorcycles", "Boats & Other" or "Public Transportation" and start added due dates or tasks!',
      'Any tasks that cant be associated with one or more Transport entities can be added in My Transport Information. This includes License numbers and expiration dates for various for multiple family members.'
    ],
    'home': [
      'The Home category helps you manage your living spaces and household items. Start by adding your homes as entities, then organize appliances, maintenance schedules, and household tasks.',
      'Use subcategories to manage different aspects of home life, from appliance maintenance to general home information and references.'
    ],
    'garden': [
      'The Garden category helps you plan and maintain your outdoor spaces. Add your gardens as entities and track planting schedules, maintenance tasks, and seasonal activities.',
      'Keep track of plant care, garden tools, and seasonal planning to maintain beautiful outdoor spaces year-round.'
    ],
    'food': [
      'The Food category helps you plan meals, manage recipes, and organize food-related activities. Create food plans for meal preparation and dietary goals.',
      'Use this category to track favorite recipes, meal planning schedules, and food-related tasks and shopping lists.'
    ],
    'laundry': [
      'The Laundry category helps you organize clothing care and laundry schedules. Create laundry plans for different types of clothing and care routines.',
      'Track laundry schedules, clothing care instructions, and organize your laundry workflow efficiently.'
    ],
    'finance': [
      'The Finance category helps you manage your financial planning and tracking. Add financial entities to organize budgets, investments, and financial goals.',
      'Keep track of financial accounts, budgeting goals, and important financial information and deadlines.'
    ],
  };

  // Entity type setup pages - matches React's entity type setup flows
  static const Map<String, List<String>> entityTypeSetupPages = {
    'SocialPlan': [
      "The Social subcategory allows users to better organise important social activities. Some entities that you might add include 1:1 time with a Family Member, Family Days Out, Supper Club, A Child's Social days if you schedule social activities for young children.",
      'In addition to the tasks and due dates you can add, there are References and List templates to help.'
    ],
    'SocialMedia': [
      'The Social Media subcategory allows users to better organise posts on social media. You can set up an entity for each platform eg Instagram, TikTok etc or based on person/people. "My and my kids" versus "My social interests"',
      'In addition to the tasks and due dates you can add, there are References and List templates to help.'
    ],
    'Event': [
      'The Events subcategory allows users to better organise Events during the year. All Events for the year will be listed and added to the calendar.',
      'When it is time to start planning, use the subcategory to plan location, food, activities. You can even send invites to a shared guest list and manage RSVPs. In addition to the tasks and due dates, there are References, List templates and Shopping lists to help.'
    ],
    'Hobby': [
      'The Interests & Hobbies subcategory allows users to plan and manage the time spent on interests and hobbies. This might be setting aside time to read each day or doing weekend hobbies like sailing or football.',
      'In addition to the tasks, appointments and due dates that are added to the calendar, there are References and List templates to help.'
    ],
  };

  // Helper methods to get setup content
  static List<String>? getCategorySetupPages(String categoryId) {
    return categorySetupPages[categoryId.toLowerCase()];
  }

  static List<String>? getEntityTypeSetupPages(String entityTypeName) {
    return entityTypeSetupPages[entityTypeName];
  }

  // Check if category has setup content
  static bool hasCategorySetup(String categoryId) {
    return categorySetupPages.containsKey(categoryId.toLowerCase());
  }

  // Check if entity type has setup content
  static bool hasEntityTypeSetup(String entityTypeName) {
    return entityTypeSetupPages.containsKey(entityTypeName);
  }
}
