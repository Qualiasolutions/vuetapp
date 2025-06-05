import 'package:vuet_app/models/entity_model.dart'; // For EntitySubtype

// Defines the mapping from specific EntitySubtype enums to their
// main integer-based AppCategory ID (from lib/config/app_categories.dart).
class EntityTypeHelper {
  static const Map<EntitySubtype, int> categoryMapping = {
    // Category 1: PETS
    EntitySubtype.pet: 1,
    EntitySubtype.vet: 1,
    EntitySubtype.walker: 1,
    EntitySubtype.groomer: 1,
    EntitySubtype.sitter: 1,
    EntitySubtype.microchipCompany: 1,
    EntitySubtype.insuranceCompany: 1, 
    EntitySubtype.insurancePolicy: 1,
    EntitySubtype.petBirthday: 1,

    // Category 2: SOCIAL_INTERESTS
    EntitySubtype.anniversary: 2,
    EntitySubtype.anniversaryPlan: 2,
    EntitySubtype.birthday: 2,
    EntitySubtype.event: 2,
    EntitySubtype.guestListInvite: 2,
    EntitySubtype.hobby: 2,
    EntitySubtype.holiday: 2,
    EntitySubtype.holidayPlan: 2,
    EntitySubtype.socialMedia: 2,
    EntitySubtype.socialPlan: 2,
    EntitySubtype.eventSubentity: 2,

    // Category 3: EDUCATION
    EntitySubtype.academicPlan: 3,
    EntitySubtype.courseWork: 3,
    EntitySubtype.extracurricularPlan: 3,
    EntitySubtype.school: 3,
    EntitySubtype.student: 3,
    EntitySubtype.subject: 3,
    EntitySubtype.teacher: 3,
    EntitySubtype.tutor: 3,
    EntitySubtype.schoolBreak: 3,
    EntitySubtype.schoolTerm: 3,
    EntitySubtype.schoolTermEnd: 3,
    EntitySubtype.schoolTermStart: 3,
    EntitySubtype.schoolYearEnd: 3,
    EntitySubtype.schoolYearStart: 3,

    // Category 4: CAREER
    EntitySubtype.colleague: 4,
    EntitySubtype.work: 4,
    EntitySubtype.careerGoal: 4,
    EntitySubtype.daysOff: 4,
    EntitySubtype.employee: 4,

    // Category 5: TRAVEL
    EntitySubtype.trip: 5,
    EntitySubtype.accommodation: 5,
    EntitySubtype.place: 5,
    EntitySubtype.driveTime: 5,
    EntitySubtype.flight: 5,
    EntitySubtype.hotelOrRental: 5,
    EntitySubtype.rentalCar: 5,
    EntitySubtype.stayWithFriend: 5,
    EntitySubtype.taxiOrTransfer: 5,
    EntitySubtype.trainBusFerry: 5,
    EntitySubtype.travelPlan: 5,

    // Category 6: HEALTH_BEAUTY
    EntitySubtype.beautySalon: 6,
    EntitySubtype.dentist: 6,
    EntitySubtype.doctor: 6,
    EntitySubtype.stylist: 6,
    EntitySubtype.therapist: 6,
    EntitySubtype.physiotherapist: 6,
    EntitySubtype.specialist: 6, 
    EntitySubtype.surgeon: 6,
    EntitySubtype.appointment: 6,
    EntitySubtype.beauty: 6,
    EntitySubtype.fitnessActivity: 6,
    EntitySubtype.healthGoal: 6,
    EntitySubtype.medical: 6,
    EntitySubtype.patient: 6,

    // Category 7: HOME
    EntitySubtype.appliance: 7,
    EntitySubtype.contractor: 7,
    EntitySubtype.furniture: 7,
    EntitySubtype.home: 7,
    EntitySubtype.room: 7,
    EntitySubtype.cleaning: 7,
    EntitySubtype.cooking: 7,
    EntitySubtype.homeMaintenance: 7,

    // Category 8: GARDEN
    EntitySubtype.tool: 8,
    EntitySubtype.plant: 8,
    EntitySubtype.garden: 8,
    EntitySubtype.gardening: 8,

    // Category 9: FOOD
    EntitySubtype.foodPlan: 9,
    EntitySubtype.recipe: 9,
    EntitySubtype.restaurant: 9,
    EntitySubtype.food: 9,

    // Category 10: LAUNDRY
    EntitySubtype.dryCleaners: 10,
    EntitySubtype.item: 10,
    EntitySubtype.clothing: 10,
    EntitySubtype.laundryPlan: 10,

    // Category 11: FINANCE
    EntitySubtype.bank: 11,
    EntitySubtype.bankAccount: 11,
    EntitySubtype.creditCard: 11,
    EntitySubtype.finance: 11,
    
    // Category 12: TRANSPORT
    EntitySubtype.boat: 12,
    EntitySubtype.car: 12,
    EntitySubtype.vehicleCar: 12, 
    EntitySubtype.publicTransport: 12,
    EntitySubtype.motorcycle: 12,
    EntitySubtype.other: 12,

    // Category 14: DOCUMENTS (Note: AppCategory ID 14 is not in main appCategories list)
    EntitySubtype.document: 14,
    EntitySubtype.passport: 14,
    EntitySubtype.license: 14, 
    EntitySubtype.bankStatement: 14,
    EntitySubtype.taxDocument: 14,
    EntitySubtype.contract: 14,
    EntitySubtype.will: 14,
    EntitySubtype.medicalRecord: 14,
    EntitySubtype.prescription: 14,
  };

  static int? getAppCategoryId(EntitySubtype subtype) {
    return categoryMapping[subtype];
  }
}
