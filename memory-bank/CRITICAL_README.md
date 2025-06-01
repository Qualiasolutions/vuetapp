# 🚨 CRITICAL README - FLUTTER REPLICA PROJECT

## ESSENTIAL UNDERSTANDING FOR ANY AGENT

**THIS IS A MIGRATION PROJECT, NOT A NEW APPLICATION**

The goal is to create a **literal replica** of the React Native app in `react-old-vuet/` using Flutter + Supabase instead of React Native + Django.

---

## PROJECT STATUS: ~25% COMPLETE

### ✅ What Works
- Authentication (Supabase)
- Basic navigation 
- Basic task CRUD
- Basic list management
- LANA AI chat
- UI framework (Material Design 3)

### ❌ What's Missing (75% of functionality)
1. **Entity Management System** (0% complete) - **BIGGEST GAP**
2. **Advanced Task Scheduling** (10% complete) 
3. **Family Collaboration** (5% complete)
4. Calendar integration (0% complete)
5. Routines system (5% complete)
6. Timeblocks system (5% complete)
7. Everything else...

---

## 🚨 CRITICAL PRIORITY FEATURES

**DO NOT IMPLEMENT ANYTHING ELSE** until these 3 features are complete:

### 1. **ENTITY MANAGEMENT SYSTEM** ⚠️ **START HERE**
- **Impact**: 80% of app value comes from entity management
- **Status**: Completely missing
- **Reference**: `/react-old-vuet/old-backend/core/models/entities/`
- **Types**: 15+ entity categories (Pets, Transport, Career, Education, Health, Home, etc.)
- **Integration**: Must link to tasks for app to be useful

### 2. **ADVANCED TASK SCHEDULING** ⚠️ **SECOND PRIORITY**  
- **Impact**: Core task functionality is primitive
- **Status**: Only basic CRUD, missing 90% of features
- **Reference**: `/react-old-vuet/old-backend/core/models/tasks/base.py`
- **Missing**: FlexibleTask, FixedTask, complex recurrence, actions, reminders

### 3. **FAMILY COLLABORATION** ⚠️ **THIRD PRIORITY**
- **Impact**: App designed for families, currently single-user only
- **Status**: Screen exists, no functionality
- **Missing**: Invitations, member management, shared resources

---

## REFERENCE SPECIFICATION

The React app in `react-old-vuet/` is the **complete specification**:

### Key Reference Locations
- **Backend Models**: `/react-old-vuet/old-backend/core/models/` - data structure spec
- **Frontend Screens**: `/react-old-vuet/old-frontend/screens/` - UI flow spec
- **Navigation**: `/react-old-vuet/old-frontend/navigation/` - app structure spec
- **State Management**: `/react-old-vuet/old-frontend/reduxStore/` - data flow spec

### Current Flutter Implementation
- **Running App**: https://qaaaa-448c6.web.app
- **Current Code**: Flutter project in root directory
- **Backend**: Supabase (replacing Django)
- **State Management**: Riverpod (replacing Redux)

---

## IMPLEMENTATION APPROACH

### Phase 1: Entity System (Weeks 1-3) - CRITICAL
1. Implement 15+ entity types with Supabase tables
2. Create entity CRUD operations and repositories  
3. Build entity management UI screens
4. Integrate entities with tasks

### Phase 2: Advanced Tasks (Weeks 4-6) - ESSENTIAL
1. Implement FlexibleTask and FixedTask models
2. Add complex recurrence system (8 types)
3. Implement task actions and reminders
4. Build advanced scheduling logic

### Phase 3: Family Features (Weeks 7-8) - IMPORTANT
1. Implement family management system
2. Add invitation and member management
3. Create shared resource access
4. Build permission system

### Phase 4+: Everything Else
- Calendar integration
- Routines system
- Timeblocks system
- External integrations
- Enhancements

---

## CRITICAL RULES FOR AGENTS

### ✅ DO:
1. **Start with Entity System** - Nothing else works without it
2. **Use React app as exact specification** - Don't innovate, replicate
3. **Implement Supabase tables matching Django models**
4. **Follow existing Flutter patterns** (Riverpod, Freezed, etc.)
5. **Reference memory-bank files** for detailed specifications

### ❌ DO NOT:
1. **Add new features** before achieving parity
2. **Skip entity system** to work on "easier" features
3. **Ignore React app structure** - it's the specification
4. **Overcomplicate** - match React behavior exactly
5. **Work on enhancements** until core features complete

---

## MEMORY BANK NAVIGATION

- **`activeContext.md`** - Current priorities and status
- **`progress.md`** - Honest assessment of what's implemented vs missing
- **`criticalFeatures.md`** - Detailed specs for the 3 critical features
- **`productContext.md`** - Project goals and problems solved
- **`techContext.md`** - Technical architecture decisions
- **`systemPatterns.md`** - Coding patterns and conventions

---

## AGENT QUICK START

1. **Read `criticalFeatures.md`** - Detailed implementation specs
2. **Study React entity models** in `/react-old-vuet/old-backend/core/models/entities/`
3. **Start implementing base Entity model** in Flutter
4. **Create Supabase tables** matching Django schema
5. **Build entity management UI** following React screens
6. **DO NOT** work on anything else until entities are complete

---

## SUCCESS METRICS

### Current State: ~25% Complete
- Basic app infrastructure ✅
- Entity management ❌ (0%)
- Advanced tasks ❌ (10%)
- Family features ❌ (5%)

### Target State: 100% Feature Parity
- All React app features replicated
- Entity system fully functional
- Family collaboration working
- Task scheduling matching React complexity

**The React app is the complete specification. The Flutter app is currently a basic shell missing 75% of functionality.** 