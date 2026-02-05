import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/permission/permission_guard.dart';
import '../core/localization/locale_controller.dart';
import '../core/background/background_service.dart';
import '../features/integration/emergency_ble_listener.dart';
import '../features/emergency/emergency_contacts_controller.dart';
import '../features/ble/ble_auto_reconnector.dart';
import '../ui/screens/main_menu_screen.dart';
import '../ui/actions/emergency_countdown_action.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    ref.watch(emergencyBleListenerProvider);
    ref.watch(emergencyContactsProvider);
    ref.watch(bleAutoReconnectProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundServiceProvider.notifier).startService();
    });

    return MaterialApp(
      title: 'Smart ECG App',
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('de'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark(),
      
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            const EmergencyCountdownOverlay(),
          ],
        );
      },
      
      home: const PermissionGuard(
        child: MainMenuScreen()
      ),
    );
  }
}