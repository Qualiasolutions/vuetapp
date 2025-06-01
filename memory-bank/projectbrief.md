# Project Brief

This project is a complete rebuild of the original React Native/Django application (located in `react-old-vuet` folder) into a modern Flutter application with Supabase backend, achieving 100% feature parity plus enhanced AI capabilities.

## Core Goal
Rebuild the entire React Native application functionality in Flutter with:
- **100% Feature Parity**: All original features fully implemented
- **Enhanced AI Integration**: LANA AI Assistant (new feature not in original)
- **Modern Architecture**: Flutter + Supabase + Riverpod
- **Improved UX**: Modern UI/UX with cross-feature integration

## Key Functional Areas (Based on React App Analysis)

### ✅ COMPLETED (85% of core functionality)
- **Authentication System**: Supabase auth with retry logic
- **Lists System**: Full CRUD with task conversion
- **Routines System**: Complex scheduling with task generation
- **Timeblocks System**: Weekly calendar with routine/task linking
- **LANA AI Assistant**: Chat interface with natural language processing
- **Basic Entity Management**: Entity CRUD operations across categories
- **Basic UI Framework**: Navigation, screens, and components

### 🚨 CRITICAL MISSING FEATURES (Phase 1 Priority)
- **School Terms Management**: Academic planning, terms, breaks integration
- **Link List Functionality**: Anniversaries, holidays, special dates handling
- **Advanced Task Completion**: Specialized completion forms and workflows
- **Reference Management**: Comprehensive reference organization system

### ⚠️ IMPORTANT MISSING FEATURES (Phase 2)
- **Contact Management**: Dedicated contact management screens
- **Help System**: Feature documentation and contextual help
- **Advanced Task Recurrence**: Complex recurrence patterns (monthly-last-week, etc.)
- **Holiday Planning**: Specialized holiday preparation workflows

### 📋 ADDITIONAL MISSING FEATURES (Phase 3)
- **Entity Form Specialization**: Custom forms for each entity type
- **Task Actions & Reminders**: Separate action and reminder systems
- **Family Collaboration Enhancements**: Advanced permission handling

## Implementation Strategy
1. **Phase 1**: Implement critical missing features first
   - School Terms Management
   - Link List Functionality
   - Advanced Task Completion
   - Reference Management

2. **Phase 2**: Add important enhancements
   - Contact Management
   - Help System
   - Advanced Task Recurrence
   - Holiday Planning

3. **Phase 3**: Complete additional features
   - Entity Form Specialization
   - Task Actions & Reminders
   - Family Collaboration Enhancements

## Success Criteria
1. **Feature Parity**: 100% of React app functionality implemented
2. **Enhanced Integration**: Cross-feature data flow and analytics
3. **AI Enhancement**: LANA AI integrated with all features
4. **Modern UX**: Improved user experience over original
5. **Production Ready**: Scalable, maintainable, well-tested

The `react-old-vuet` codebase serves as the definitive functional reference for all missing features. Each implementation should follow the established Flutter architecture patterns while preserving all functionality from the original app.
