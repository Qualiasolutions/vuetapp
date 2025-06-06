# Project Brief - Vuet Flutter Migration
*Last Updated: January 7, 2025*

## Project Overview
**Vuet** is a comprehensive life management application that helps users organize their personal and professional lives through a sophisticated entity-based system. The project involves migrating from a React/Django architecture to a modern Flutter frontend with Supabase backend.

## Core Mission
Transform how people manage their daily lives by providing an intelligent, category-based system that automatically generates tasks, manages relationships between entities, and adapts to user preferences and family dynamics.

## Project Scope

### Primary Objective
Achieve full feature parity with the legacy 'OLDBACK' Django/React application while modernizing the user experience and leveraging Flutter's cross-platform capabilities.

### Key Migration Goals
1. **Frontend Migration**: React → Flutter (Dart)
2. **Backend Migration**: Django → Supabase (PostgreSQL, Auth, Storage, Realtime, Edge Functions)
3. **Architecture Modernization**: Implement schema-driven, polymorphic entity system
4. **UI/UX Enhancement**: Apply Modern Palette design system and contemporary patterns

## Target Users

### Primary Users
- **Busy Professionals**: Need to manage work and personal life efficiently
- **Families**: Require shared planning and coordination tools
- **Students**: Academic planning and life organization
- **Small Business Owners**: Professional and personal task management

### User Personas
1. **Sarah (Working Parent)**: Manages family schedules, kids' activities, household tasks
2. **Marcus (Student)**: Academic planning, social events, part-time work coordination
3. **Elena (Freelancer)**: Client projects, personal goals, financial tracking
4. **The Johnson Family**: Shared calendar, chores, family events, pet care

## Core Features

### Entity Management System
- **13+ Categories**: Family, Pets, Social, Education, Career, Travel, Health, Home, Garden, Food, Laundry, Finance, Transport
- **50+ Entity Types**: From birthdays and cars to academic plans and travel itineraries
- **Polymorphic Architecture**: Type-specific data with shared base functionality

### Intelligent Task Generation
- **Automatic Tasks**: Birthday reminders, MOT due dates, academic deadlines
- **Recurrence Patterns**: Daily, weekly, monthly, yearly with complex rules
- **Smart Scheduling**: Considers user preferences, blocked days, task limits

### Family & Sharing
- **Family Groups**: Shared entities, tasks, and calendars
- **Permission System**: View, edit, admin levels for different family members
- **Delegation**: Assign tasks and lists to family members

### Calendar Integration
- **External Sync**: Google Calendar, iCloud, Outlook integration
- **Timeblocks**: Visual time management with routine linking
- **Event Management**: Family events, appointments, recurring activities

### Advanced Features
- **Professional Mode**: Separate categories for business users
- **Reference Groups**: Structured tagging and organization system
- **List Management**: Templates, categories, shopping lists, planning lists
- **LANA AI Assistant**: Intelligent task and schedule optimization

## Technical Architecture

### Frontend Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **UI Components**: Custom widget library with Modern Palette
- **Platform Support**: iOS, Android, Web

### Backend Stack
- **Database**: Supabase PostgreSQL with RLS
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage for files/images
- **Realtime**: Supabase Realtime for live updates
- **Functions**: Supabase Edge Functions for business logic

### Modern Palette Design System
- **Dark Jungle Green** (#202827): Headers, primary text, navigation
- **Medium Turquoise** (#55C6D6): Secondary accents, links, toggles
- **Orange** (#E49F2F): Primary brand, buttons, highlights
- **Steel** (#798D8E): Outlines, disabled states, secondary text
- **White** (#FFFFFF): Cards, backgrounds, form surfaces

## Current Status

### Backend Status ✅ MATURE
- **Database Schema**: 80+ tables with comprehensive entity system
- **Categories**: 14 implemented (vs 13 in original plan)
- **Entity Types**: 50+ polymorphic entity types
- **Core Systems**: Tasks, families, calendar, lists, routines all functional

### Frontend Status ⚠️ NEEDS ALIGNMENT
- **Architecture Gap**: Hardcoded categories vs. schema-driven approach
- **Design Gap**: Current theme doesn't match Modern Palette
- **Component Gap**: Missing modern widget library
- **Integration Gap**: Not fully leveraging backend capabilities

## Success Criteria

### Phase 1: Foundation (Current)
- [ ] Modern Palette theme implementation
- [ ] Modern widget library creation
- [ ] Schema-driven category system
- [ ] Backend-frontend alignment

### Phase 2: Feature Parity
- [ ] All entity types supported
- [ ] Automatic task generation working
- [ ] Family sharing functional
- [ ] Calendar integration complete

### Phase 3: Enhancement
- [ ] LANA AI assistant integration
- [ ] Advanced timeblock features
- [ ] Professional mode
- [ ] Performance optimization

## Key Challenges

### Technical Challenges
1. **Category System Alignment**: Backend has 14 categories vs. 13 in guides
2. **FAMILY Category**: Missing from backend categories but exists as separate system
3. **Migration Strategy**: Gradual vs. complete rebuild approach
4. **State Management**: Complex entity relationships in Flutter

### User Experience Challenges
1. **Complexity Management**: Powerful features without overwhelming users
2. **Family Coordination**: Intuitive sharing and permission management
3. **Cross-Platform Consistency**: Unified experience across devices
4. **Performance**: Smooth experience with large datasets

## Timeline & Milestones

### Immediate (Current Session)
- Memory bank initialization
- Backend analysis and gap identification
- Modern Palette theme implementation
- Modern widget library creation

### Short Term (Next 2-3 Sessions)
- Category system alignment
- Core entity management screens
- Basic task functionality
- Family sharing foundation

### Medium Term (Next 5-10 Sessions)
- Complete entity type support
- Advanced task automation
- Calendar integration
- List management system

### Long Term (Future Phases)
- LANA AI integration
- Advanced features
- Performance optimization
- Platform-specific enhancements

## Risk Mitigation

### Technical Risks
- **Schema Complexity**: Use memory bank guides as single source of truth
- **Performance**: Implement pagination and lazy loading early
- **State Management**: Establish clear patterns with Riverpod

### Project Risks
- **Scope Creep**: Focus on feature parity before enhancements
- **Complexity**: Implement incrementally with working prototypes
- **Consistency**: Regular alignment checks with memory bank guides

---

*This project brief serves as the north star for all development decisions and should be referenced when making architectural choices.*
