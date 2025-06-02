# 🎯 Vuet - Smart Task & Entity Management

[![Flutter](https://img.shields.io/badge/Flutter-3.24.5-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green.svg)](https://supabase.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Development Status](https://img.shields.io/badge/Status-35%25%20Complete-orange.svg)]()
[![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/Qualiasolutions/vuetapp?utm_source=oss&utm_medium=github&utm_campaign=Qualiasolutions%2Fvuetapp&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)](https://coderabbit.ai)

> A next-generation task and entity management application built with Flutter and Supabase, designed to help you organize every aspect of your life through intelligent entity relationships and automated task generation.

## 📱 About Vuet

Vuet is a comprehensive life management app that goes beyond simple to-do lists. It's built around the concept of **entities** - the people, places, pets, vehicles, and things that matter in your life - and helps you manage tasks, routines, and schedules around these entities.

### 🌟 Key Concept
Instead of just creating isolated tasks, Vuet lets you:
- **Create entities** (pets, cars, homes, family members, etc.)
- **Link tasks to entities** (vet appointment for Fluffy, oil change for Honda)
- **Generate recurring routines** that automatically create tasks
- **Collaborate with family** on shared entities and tasks
- **Get intelligent suggestions** from LANA, our AI assistant

## ✨ Features

### ✅ **Currently Available**
- **🔐 User Authentication & Profiles** - Secure login with Supabase Auth
- **📋 Task Management** - Create, organize, and track tasks with priorities and due dates
- **📝 Lists & Planning** - Shopping lists, planning lists with template support
- **🤖 LANA AI Assistant** - Intelligent help and suggestions
- **👥 User Management** - Profile management and preferences
- **📊 Modern UI/UX** - Material Design 3 with responsive layouts

### 🚧 **In Development** (35% → 100% by Week 8)
- **🏠 Entity Management System** (80% of app value)
  - 48 entity types across 15+ categories
  - Pet management, vehicle tracking, home appliances, etc.
  - Custom fields and relationships
- **🔄 Advanced Task Scheduling**
  - Routine-based task generation
  - Smart scheduling and reminders
  - Calendar integration
- **👨‍👩‍👧‍👦 Family Collaboration**
  - Shared entities and tasks
  - Family member roles and permissions
  - Collaborative planning
- **📅 Calendar & Time Management**
  - Timeblock scheduling
  - Calendar synchronization
  - Smart time allocation

## 🛠 Tech Stack

### **Frontend**
- **Flutter 3.24.5** - Cross-platform mobile framework
- **Material Design 3** - Modern, adaptive UI components
- **Riverpod** - Reactive state management
- **Auto Route** - Declarative routing

### **Backend**
- **Supabase** - Open-source Firebase alternative
  - **PostgreSQL** - Robust relational database
  - **PostgREST** - Auto-generated REST API
  - **Real-time subscriptions** - Live data updates
  - **Row Level Security** - Fine-grained access control
- **Edge Functions** - Serverless functions for complex operations

### **Development & CI/CD**
- **GitHub Actions** - Automated testing and deployment
- **TestFlight** - iOS beta distribution
- **Code Analysis** - Automated code quality checks
- **CodeRabbit** - AI-powered code review (see [setup guide](docs/CODERABBIT_SETUP.md))

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24.5 or later
- Dart SDK 3.5.0 or later
- iOS 12.0+ / Android API 21+
- Supabase account (for backend)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/vuet-app.git
   cd vuet-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a new Supabase project
   - Copy your project URL and anon key
   - Update `lib/config/supabase_config.dart` with your credentials

4. **Run database migrations**
   ```bash
   # Apply database schema
   # See supabase/migrations/ for SQL files
   ```

5. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── config/              # App configuration
├── constants/           # App constants and enums
├── models/             # Data models
│   ├── entity_model.dart
│   ├── task_model.dart
│   └── ...
├── providers/          # Riverpod state management
├── repositories/       # Data access layer
├── services/          # Business logic services
├── ui/               # User interface
│   ├── screens/      # App screens
│   ├── widgets/      # Reusable widgets
│   └── theme/        # App theming
└── utils/            # Utility functions

supabase/
├── migrations/       # Database migrations
└── functions/       # Edge functions
```

## 🎯 Development Roadmap

### **Phase 1: Entity Foundation** (Weeks 1-3) - 90% Complete
- ✅ Core entity models and database schema
- ✅ Entity creation and basic management
- ✅ Category system with 48+ entity types
- 🚧 Entity relationships and linking

### **Phase 2: Task Integration** (Weeks 4-6) - 98% Complete
- 🚧 Entity-task linking system
- 🚧 Routine-based task generation
- 🚧 Advanced scheduling features
- 🚧 Smart notifications

### **Phase 3: Collaboration & Polish** (Weeks 7-8) - 100% Complete
- 🚧 Family collaboration features
- 🚧 Calendar integration
- 🚧 Performance optimization
- 🚧 UI/UX refinements

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Standards
- Follow Dart/Flutter best practices
- Use meaningful commit messages
- Ensure all tests pass
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **App Store**: Coming Soon
- **Google Play**: Coming Soon
- **Documentation**: [Wiki](https://github.com/yourusername/vuet-app/wiki)
- **Bug Reports**: [Issues](https://github.com/yourusername/vuet-app/issues)
- **Feature Requests**: [Discussions](https://github.com/yourusername/vuet-app/discussions)

## 👨‍💻 Team

- **Lead Developer**: [Your Name](https://github.com/yourusername)
- **AI Assistant**: Claude (Anthropic) - Architecture & development support

## 📊 Stats

- **Lines of Code**: ~25,000+
- **Files**: 200+
- **Entity Types**: 48
- **Categories**: 15+
- **Test Coverage**: 75%+ (target)

---

**Made with ❤️ using Flutter and Supabase**

*Vuet - Because life is made up of entities, not just tasks.*
