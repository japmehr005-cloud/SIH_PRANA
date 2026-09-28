import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/features/assistant/presentation/assistant_screen.dart';
import 'package:aarogya/features/auth/presentation/account_screen.dart';
import 'package:aarogya/features/auth/presentation/login_screen.dart';
import 'package:aarogya/features/auth/presentation/register_screen.dart';
import 'package:aarogya/features/demo/presentation/demo_screen.dart';
import 'package:aarogya/features/devices/presentation/devices_screen.dart';
import 'package:aarogya/features/disaster/presentation/disaster_screen.dart';
import 'package:aarogya/features/health/presentation/home_overview_screen.dart';
import 'package:aarogya/features/health/presentation/home_screen.dart';
import 'package:aarogya/features/rescue/presentation/survival_screen.dart';
import 'package:aarogya/features/settings/presentation/settings_screen.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class AppPaths {
  static const home = '/';
  static const health = '/health';
  static const assistant = '/assistant';
  static const disaster = '/disaster';
  static const demo = '/demo';
  static const rescue = '/rescue';
  static const devices = '/devices';
  static const account = '/account';
  static const settings = '/settings';
  static const login = '/login';
  static const register = '/register';
}

String? authRedirect({AccountService? accounts, required String path}) {
  if (accounts == null || !accounts.isConfigured) {
    return null;
  }
  final signedIn = accounts.current != null;
  final authRoute = path == AppPaths.login || path == AppPaths.register;
  if (!signedIn && !authRoute) {
    return AppPaths.login;
  }
  if (signedIn && authRoute) {
    return AppPaths.home;
  }
  return null;
}

GoRouter createRouter({AccountService? accounts}) {
  return GoRouter(
    initialLocation: AppPaths.home,
    refreshListenable: accounts is Listenable ? accounts as Listenable : null,
    redirect: (context, state) =>
        authRedirect(accounts: accounts, path: state.uri.path),
    routes: [
      GoRoute(
        path: AppPaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppPaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.home,
                builder: (context, state) => const HomeOverviewScreen(),
                routes: [
                  GoRoute(
                    path: 'demo',
                    builder: (context, state) => const DemoScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.assistant,
                builder: (context, state) => const AssistantScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.disaster,
                builder: (context, state) => const DisasterScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.rescue,
                builder: (context, state) => const SurvivalScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.devices,
                builder: (context, state) => const DevicesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.health,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.account,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppPaths.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final primaryIndex = navigationShell.currentIndex <= 4
        ? navigationShell.currentIndex
        : 5;
    if (!wide) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: primaryIndex,
          onDestinationSelected: (index) {
            if (index < 5) {
              navigationShell.goBranch(index);
            } else {
              _showMore(context, l10n);
            }
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              label: l10n.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              label: l10n.assistantNav,
            ),
            NavigationDestination(
              icon: const Icon(Icons.warning_amber_outlined),
              label: l10n.disasterNav,
            ),
            NavigationDestination(
              icon: const Icon(Icons.health_and_safety_outlined),
              label: l10n.survivalNav,
            ),
            NavigationDestination(
              icon: const Icon(Icons.devices_outlined),
              label: l10n.devicesNav,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu),
              label: l10n.moreNav,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: primaryIndex,
            onDestinationSelected: (index) {
              if (index < 5) {
                navigationShell.goBranch(index);
              } else {
                _showMore(context, l10n);
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                label: Text(l10n.home),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.auto_awesome_outlined),
                label: Text(l10n.assistantNav),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.warning_amber_outlined),
                label: Text(l10n.disasterNav),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.health_and_safety_outlined),
                label: Text(l10n.survivalNav),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.devices_outlined),
                label: Text(l10n.devicesNav),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.menu),
                label: Text(l10n.moreNav),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  void _showMore(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.monitor_heart_outlined),
                title: Text(l10n.healthNav),
                onTap: () {
                  Navigator.pop(context);
                  navigationShell.goBranch(5);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(l10n.accountNav),
                onTap: () {
                  Navigator.pop(context);
                  navigationShell.goBranch(6);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(l10n.settings),
                onTap: () {
                  Navigator.pop(context);
                  navigationShell.goBranch(7);
                },
              ),
              ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(l10n.continueDemonstration),
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).go(AppPaths.demo);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
