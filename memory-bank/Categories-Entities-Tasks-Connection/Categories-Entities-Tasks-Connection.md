# Vuet Legacy Application: Domain Model Documentation

## Overview
This document provides comprehensive details about the core domain model of the Vuet legacy application, focusing on the relationships between Categories, Entities, and Tasks. Understanding this structure is critical for successfully implementing the Flutter/Supabase remake.

## 1. Core Components

### 1.1 Categories
The application uses 12 predefined categories to organize all entities:

1. **PETS** (ID: 1)
2. **SOCIAL_INTERESTS** (ID: 2)
3. **EDUCATION** (ID: 3)
4. **CAREER** (ID: 4)
5. **TRAVEL** (ID: 5)
6. **HEALTH_BEAUTY** (ID: 6) 
7. **HOME** (ID: 7)
8. **GARDEN** (ID: 8)
9. **FOOD** (ID: 9)
10. **LAUNDRY** (ID: 10)
11. **FINANCE** (ID: 11)
12. **TRANSPORT** (ID: 12)

Categories are presented to users in grouped "tiles" on the main Categories screen:
- PETS
- SOCIAL_INTERESTS
- EDUCATION_CAREER (combines Education and Career categories)
- TRAVEL
- HEALTH_BEAUTY
- HOME_GARDEN (combines Home, Garden, Food, and Laundry)
- FINANCE
- TRANSPORT
- REFERENCES (special premium feature)

### 1.2 Entities
Entities are the "things" users manage in their lives. Each entity:
- Belongs to a specific category
- Has a name, notes, and optional image
- Can have an owner and members (shared access)
- Can have a parent entity (hierarchical structure)
- Has type-specific fields based on its nature

### 1.3 Tasks
Tasks represent actions that need to be completed. They can be:
- Fixed (specific time) or Flexible (schedulable based on constraints)
- One-time or Recurring (with various recurrence patterns)
- Assigned to one or more users
- Connected to one or more entities
- Tagged for organization

## 2. Detailed Entity Types by Category

### 2.1 PETS (Category ID: 1)
- **Pet**
  - Fields: type, breed, dob, microchip_number, image
  - Relations: microchip_company, pet_vet, pet_walker, pet_groomer, pet_sitter, insurance_policy
- **Vet** - Fields: phone_number, email
- **Walker** - Fields: phone_number, email
- **Groomer** - Fields: phone_number, email
- **Sitter** - Fields: phone_number, email
- **MicrochipCompany** - Fields: account_number, phone_number, email
- **InsuranceCompany** - Fields: phone_number, email
- **InsurancePolicy** - Fields: account_number, company relation

### 2.2 SOCIAL_INTERESTS (Category ID: 2)
- **Event** (AutoSubentity - creates sub-entities automatically)
  - Fields: start_datetime, end_datetime
  - Auto-creates: Food/Cake, Activities/Venue, Party Favours, Gifts, Music, Decorations
- **Hobby**
- **Holiday** - Fields: string_id, country_code, start_date, end_date, custom
- **HolidayPlan** (AutoSubentity)
- **SocialPlan**
- **SocialMedia**
- **AnniversaryPlan** (AutoSubentity)
- **Birthday** - Fields: date
- **Anniversary** - Fields: date, type
- **EventSubentity** - For auto-created sub-entities
- **GuestListInvite** - Fields: name, phone_number, email, accepted, rejected, maybe, sent

### 2.3 EDUCATION (Category ID: 3)
- **School** - Fields: address, phone_number, email, website
- **Subject**
- **CourseWork** - Fields: subject, due_date
- **Teacher** - Fields: subject, phone_number, email
- **Tutor** - Fields: subject, phone_number, email
- **AcademicPlan**
- **ExtracurricularPlan**
- **Student** - Relations: school_attended
- **SchoolYear** - Fields: start_date, end_date, year, show_on_calendars
- **SchoolTerm** - Fields: name, start_date, end_date, show_on_calendars
- **SchoolBreak** - Fields: name, start_date, end_date, show_on_calendars

### 2.4 CAREER (Category ID: 4)
- **Work**
- **Colleague** - Fields: phone_number, email

### 2.5 TRAVEL (Category ID: 5)
- **Trip** - Fields: start_date, end_date

### 2.6 HEALTH_BEAUTY (Category ID: 6, Premium)
- **Doctor** - Fields: phone_number, email
- **Dentist** - Fields: phone_number, email
- **BeautySalon** - Fields: phone_number, email
- **Stylist** - Fields: phone_number, email

### 2.7 HOME (Category ID: 7)
- **Home** - Fields: address, residence_type, house_type, has_outside_area
- **Room**
- **Furniture**
- **Appliance**
- **Contractor** - Fields: phone_number, email, website

### 2.8 GARDEN (Category ID: 8)
- **Plant**
- **Tool**

### 2.9 FOOD (Category ID: 9)
- **FoodPlan**
- **Recipe**
- **Restaurant**

### 2.10 LAUNDRY (Category ID: 10)
- **Item**
- **DryCleaners** - Fields: phone_number, email

### 2.11 FINANCE (Category ID: 11)
- **Bank**
- **CreditCard**
- **BankAccount**

### 2.12 TRANSPORT (Category ID: 12)
- **Vehicle** (abstract)
  - Fields: make, model, registration, date_registered, service_due_date, insurance_due_date
- **Car** - Fields: vehicle_type (Car/Motorbike)
- **Boat** - Fields: vehicle_type (Boat/Other)
- **PublicTransport**

## 3. Task System

### 3.1 Task Types
- **FixedTask**
  - Fields: start_datetime, end_datetime, start_timezone, end_timezone
  - Or: start_date, end_date
  - Or: date, duration

- **FlexibleTask**
  - Fields: earliest_action_date, due_date, duration, urgency

### 3.2 Task Classification
Tasks have a "type" field with options:
- TASK
- APPOINTMENT
- DUE_DATE
- FLIGHT
- TRAIN
- RENTAL_CAR
- TAXI
- DRIVE_TIME
- HOTEL
- STAY_WITH_FRIEND
- ACTIVITY
- FOOD_ACTIVITY
- OTHER_ACTIVITY
- ANNIVERSARY
- BIRTHDAY
- USER_BIRTHDAY
- HOLIDAY
- ICAL_EVENT

### 3.3 Recurrence System
- **Recurrence Types**:
  - DAILY
  - WEEKDAILY
  - WEEKLY
  - MONTHLY
  - YEARLY
  - MONTH_WEEKLY
  - YEAR_MONTH_WEEKLY
  - MONTHLY_LAST_WEEK

- **RecurrentTaskOverwrite**: Allows modifying specific occurrences of recurring tasks

### 3.4 Task Scheduling
- Flexible tasks are placed on the calendar by a scheduling engine
- The engine considers:
  - Blocked days for the task's category
  - Preferred days for the task's category
  - User's routines and time blocks
  - Due dates and earliest action dates

## 4. Special Features

### 4.1 References (Premium Feature)
- **ReferenceGroup** - Fields: name, tags
- **Reference** - Fields: name, value, type, created_at
- Types: NAME, ACCOUNT_NUMBER, USERNAME, PASSWORD, WEBSITE, NOTE, ADDRESS, PHONE_NUMBER, DATE, OTHER

### 4.2 Lists
- **List** (entity)
- **ListEntry** - Fields: title, selected, image, notes, phone_number
- **PlanningList** - Fields: name, category, is_template
- **PlanningSublist** - Fields: title
- **PlanningListItem** - Fields: title, checked
- **ShoppingList** - Fields: name
- **ShoppingListStore** - Fields: name
- **ShoppingListItem** - Fields: title, checked

### 4.3 TimeBlocks (Premium Feature)
- **TimeBlock** - Fields: day, start_time, end_time
- Days: MONDAY through SUNDAY

### 4.4 Routines (Premium Feature)
- **Routine** - Fields for each day of week (boolean), start_time, end_time

## 5. Key Relationships

### 5.1 Entity-Task Connection
```
Task <----> Entity (Many-to-Many)
```

### 5.2 User-Entity-Task Relationship
```
User <----> Entity <----> Task
```

### 5.3 Category-Entity-Task Connection
Tasks and scheduling decisions are influenced by entity categories:
- BlockedCategory models define when tasks of certain categories can't be scheduled
- PreferredDays models define preferred days for tasks of certain categories

## 6. Implementation Considerations for Flutter/Supabase

### 6.1 Database Schema
- Consider implementing polymorphic entities using one of these approaches:
  - Single table inheritance with type column and JSON fields
  - Table per type with foreign key relationships
  - Hybrid approach with common fields in base table and type-specific tables

### 6.2 Row Level Security
- Implement RLS policies for entity and task access based on:
  - Ownership
  - Membership
  - Family relationships

### 6.3 Real-time Features
- Use Supabase Realtime for:
  - Task updates between family members
  - Entity sharing
  - Calendar synchronization

### 6.4 Complex Business Logic
- The scheduling engine should be implemented using:
  - Supabase Edge Functions for server-side scheduling
  - Or client-side logic in Flutter for offline support

### 6.5 Offline Functionality
- Implement:
  - Local storage with SQLite or Hive
  - Conflict resolution for offline changes
  - Sync strategies when connection is restored

### 6.6 Migration Strategy
- Consider how to handle:
  - Data migration from legacy system
  - User onboarding for existing users

## 7. Legacy Code References

For detailed implementation examples, refer to these files in the legacy codebase:

### Backend
- **Categories**: `.idx/react-old-vuet/old-backend/core/utils/categories.py`
- **Entity Models**: `.idx/react-old-vuet/old-backend/core/models/entities/`
- **Task Models**: `.idx/react-old-vuet/old-backend/core/models/tasks/base.py`
- **API Views**: `.idx/react-old-vuet/old-backend/core/views/entity_viewsets.py`

### Frontend
- **Category Grid**: `.idx/react-old-vuet/old-frontend/screens/Categories/CategoriesGrid.tsx`
- **Entity Lists**: `.idx/react-old-vuet/old-frontend/screens/Categories/CategoryListScreen.tsx`
- **API Integration**: `.idx/react-old-vuet/old-frontend/reduxStore/services/api/categories.js` 