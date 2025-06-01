import 'package:flutter/material.dart';
import 'package:vuet_app/ui/screens/auth/login_screen.dart';
import 'package:vuet_app/ui/screens/auth/register_screen.dart';
import 'package:vuet_app/ui/screens/auth/password_reset_screen.dart';

/// Navigation controller for authentication-related screens
class AuthNavigator extends StatefulWidget {
  /// Constructor
  const AuthNavigator({super.key});

  @override
  State<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  // Used to track which auth screen is currently shown
  final _navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Handle system back button navigation within the nested navigator
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        
        final navigatorState = _navigatorKey.currentState;
        if (navigatorState == null) {
          Navigator.of(context).pop();
          return;
        }
        
        if (navigatorState.canPop()) {
          navigatorState.pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Navigator(
        key: _navigatorKey,
        initialRoute: 'login',
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          
          // Auth screen routes
          switch (settings.name) {
            case 'login':
              builder = (_) => LoginScreen(
                onRegisterPressed: () => _navigatorKey.currentState?.pushNamed('register'),
                onForgotPasswordPressed: () => _navigatorKey.currentState?.pushNamed('password-reset'),
              );
              break;
            
            case 'register':
              builder = (_) => RegisterScreen(
                onLoginPressed: () => _navigatorKey.currentState?.pop(),
              );
              break;
            
            case 'password-reset':
              builder = (_) => PasswordResetScreen(
                onBackToLoginPressed: () => _navigatorKey.currentState?.pop(),
              );
              break;
            
            default:
              // Default to login if route not recognized
              builder = (_) => LoginScreen(
                onRegisterPressed: () => _navigatorKey.currentState?.pushNamed('register'),
                onForgotPasswordPressed: () => _navigatorKey.currentState?.pushNamed('password-reset'),
              );
          }
          
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }
}
