import 'package:flutter/material.dart';
import 'package:vuet_app/ui/screens/timeblocks/timeblocks_screen.dart';
import 'package:vuet_app/ui/screens/timeblocks/create_edit_timeblock_screen.dart';
import 'package:vuet_app/ui/screens/timeblocks/timeblock_detail_screen.dart';

/// Navigator for the Timeblocks feature with its own routes
class TimeblockNavigator extends StatelessWidget {
  const TimeblockNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = const TimeblocksScreen();
            break;
          case '/create':
            page = const CreateEditTimeblockScreen();
            break;
          case '/edit':
            final args = settings.arguments as Map<String, dynamic>;
            page = CreateEditTimeblockScreen(timeblockId: args['id'] as String);
            break;
          case '/detail':
            final args = settings.arguments as Map<String, dynamic>;
            page = TimeblockDetailScreen(timeblockId: args['id'] as String);
            break;
          default:
            page = const TimeblocksScreen();
        }
        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }
}
