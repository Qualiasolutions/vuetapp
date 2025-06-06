# flutter-vuet-detailed-category-by-category-guide.md  
Modern Palette Edition — Dark Jungle Green #202827 · Medium Turquoise #55C6D6 · Orange #E49F2F · Steel #798D8E · White #FFFFFF  

---

## 1 · How to Read This File  
Every section below is **copy-paste ready**. When the word *Widget* appears it means “import from `lib/ui/shared/widgets.dart` and paste exactly”.  
Color tokens are constant names (`AppColors.*`).  
All tables must be translated **1-to-1** into `vuet_schema.yaml`, `*.freezed.dart` models, `*.form.json` builder definitions and `GoRouter` routes.

---

## 2 · Global Widgets Snippet (paste once)  

```dart
// lib/ui/shared/widgets.dart
class VuetHeader extends StatelessWidget {
  const VuetHeader(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext c) => AppBar(
        backgroundColor: AppColors.darkJungleGreen,
        title: Text(title, style: const TextStyle(color: AppColors.white)),
      );
}

class VuetTextField extends StatelessWidget {
  const VuetTextField(this.hint, {required this.controller, required this.validator, this.type = TextInputType.text, super.key});
  final String hint;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType type;
  @override
  Widget build(BuildContext c) => TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.steel),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.steel)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.mediumTurquoise)),
        ),
        validator: validator,
      );
}
```

Use `VuetHeader` for every detail screen and `VuetTextField` for every field row.

---

## 3 · Universal Route Pattern  

| Screen | Route Name | Params |
|--------|------------|--------|
| CategoryGrid | `/categories` | – |
| CategoryList | `/category/:id/list` | `id` (int) |
| EntityDetail | `/entity/:id` | `id` (int) |
| EntityForm (Create) | `/entity/create/:type` | `type` (string) |
| EntityForm (Edit) | `/entity/edit/:id` | `id` (int) |

Always push using `context.go()`.

---

## 4 · Validation Cheat-Sheet  
| Type | Validator lambda |
|------|------------------|
| required string | `v!=null && v.trim().isNotEmpty ? null : 'Required'` |
| date iso | `DateTime.tryParse(v??'')!=null?null:'yyyy-MM-dd'` |
| positive int | `int.tryParse(v??'')!=null && int.parse(v!)>0?null:'>0'` |

---

## 5 · Category Specifications  

### 5.1 FAMILY  
| Field | Value |
|-------|-------|
| **Readable Name** | Family |
| **Icon** | `Icons.family_restroom` |
| **Tile BG** | `AppColors.orange.withOpacity(.15)` |
| **Header BG** | `AppColors.darkJungleGreen` |
| **Accent** | `AppColors.mediumTurquoise` |
| **Preferences** | preferred_days, task_limits |
| **Automatic Rules** | `yearly_birthday_task`, `anniversary_task` |

#### 5.1.1 Entities  

1. **Birthday**  
   | Field | Type | Placeholder | Validator |
   |-------|------|-------------|-----------|
   | `name` | string | “Name” | required |
   | `dob` | date | “YYYY-MM-DD” | date iso |
   | `known_year` | bool | – | – |

2. **Anniversary** (same fields as *Birthday* but `dob` renamed `date`)  

3. **Patient**  
   | Field | Type | Placeholder | Validator |
   |-------|------|-------------|-----------|
   | `first_name` | string | “First name” | required |
   | `last_name` | string | “Surname” | required |
   | `medical_number` | string | “Medical ref” | optional |

4. **Appointment**  
   | Field | Type | Placeholder | Validator |
   |-------|------|-------------|-----------|
   | `title` | string | “Dentist” | required |
   | `start_datetime` | datetime | “YYYY-MM-DD HH:MM” | required |
   | `end_datetime` | datetime | – | required |

#### 5.1.2 Create/Edit Form Layout  
```
Column [
  Row [ VuetTextField(name) ]
  Row [ VuetDatePicker(dob) ]
  Divider(color: AppColors.steel)
  FilledButton("Save", bg: AppColors.orange)
]
```

#### 5.1.3 Automatic Task Generation  
| Trigger | Produced Task |
|---------|---------------|
| `Birthday.dob` saved | FixedTask title=`"🎂 {name}"` schedule=YEARLY date=dob |
| `Anniversary.date` saved | FixedTask title=`"💍 Anniversary"` schedule=YEARLY date |

#### 5.1.4 Navigation Flow  
```
/categories → tap “Family” tile  
→ /category/1/list (shows Birthday, Anniversary, Patient, Appointment lists)  
→ “+” FAB opens /entity/create/Birthday
```

#### 5.1.5 Interconnections  
*Appointment.members* auto-prefills with *Patient*’s member list.

---

### 5.2 PETS  
| Field | Value |
| **Entities** | Pet, PetAppointment |
| **Preferences** | blocked_days |
| **Auto Rules** | yearly_pet_vaccination |

*Entity specs*  

1. **Pet**  
   | Field | Type | Placeholder | Validator |
   | `name` | string | “Fluffy” | required |
   | `species` | enum(cat,dog,other) | – | required |
   | `dob` | date | – | optional |
   | `vaccination_due` | date | – | date iso (optional) |

2. **PetAppointment** (inherits Appointment fields)  

*Auto Task* → when `vaccination_due` set generate FixedTask hiddenTag=`VACCINATION_DUE`.

*Color* → Header `AppColors.darkJungleGreen`, card shadows `AppColors.steel`.

---

### 5.3 SOCIAL_INTERESTS  
Entities: Hobby, SocialPlan, Event  
Preferences: preferred_days  
Auto: none  

*Field table omitted here but must be filled in your copy (same pattern).*  

---

### 5.4 EDUCATION  
Entities: School, Student, AcademicPlan, SchoolTerm, SchoolBreak  
Preferences: blocked_days  
Auto: academic_year_tasks (start/end)  
Inter-link: Student.school_attended → School.id  

---

### 5.5 CAREER  
Entities: CareerGoal, Employee  
Preferences: task_limits  
Auto: quarterly_review_task  

---

### 5.6 TRAVEL  
Entities: Trip, Flight, HotelOrRental, TaxiOrTransfer, DriveTime  
Preferences: blocked_days  
Auto: check-in reminder (24 h before Flight.start_datetime)  
HiddenTags: none  

---

### 5.7 HEALTH_BEAUTY  
Entities: HealthGoal, Appointment(Patient)  
Preferences: blocked_days  
Auto: follow-up appointment (30 d after Appointment.end_datetime)  

---

### 5.8 HOME  
Entities: Home, LaundryPlan, CleaningRoutine  
Preferences: task_limits, blocked_days  

---

### 5.9 GARDEN  
Entities: Garden, PlantCarePlan  
Preferences: preferred_days  

---

### 5.10 FOOD  
Entities: FoodPlan, Food  
Preferences: task_limits  
Auto: grocery_task (48 h before FoodPlan.start_date)  

---

### 5.11 LAUNDRY  
Entities: LaundryPlan  
Preferences: blocked_days  
Auto: laundry_reminder (weekly)  

---

### 5.12 FINANCE  
Entities: Finance, Subscription  
Preferences: task_limits  
Auto: subscription_renew_task  

---

### 5.13 TRANSPORT  
Entities: Car, PublicTransport, TrainBusFerry, RentalCar  
Preferences: blocked_days  
HiddenTags used: MOT_DUE, INSURANCE_DUE, SERVICE_DUE, TAX_DUE, WARRANTY_DUE  
Auto: hiddenTagDueDate for every date field in Car.  

*Car form*  

| Row | Widget |
|-----|--------|
| 1 | VuetTextField(make) |
| 2 | VuetTextField(model) |
| 3 | VuetTextField(registration) |
| 4 | VuetDatePicker(mot_due_date) |
| 5 | VuetDatePicker(insurance_due_date) |
| 6 | VuetDatePicker(service_due_date) |

Task creation titles follow pattern `"🚗 {hiddenTag} for {registration}"`.

---

## 6 · Color Usage Summary  

| Component | Color |
|-----------|-------|
| Category Tile BG | `AppColors.orange.withOpacity(.15)` |
| Category Tile Text | `AppColors.darkJungleGreen` |
| Form Divider | `AppColors.steel` |
| FAB | `AppColors.orange` icon white |
| Save Button | bg `AppColors.orange`, fg white |
| Toggle (on) | `AppColors.mediumTurquoise` |
| Toggle Track | `AppColors.mediumTurquoise.withOpacity(.35)` |

---

*End of boring, exhaustive file.*  
