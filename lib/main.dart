import 'package:edt/firebase_options.dart';
import 'package:edt/pages/authentication/signup/provider/signup_provider.dart';
import 'package:edt/pages/boarding/provider/role_provider.dart';
import 'package:edt/pages/bottom_bar/provider/bottombar_provider.dart';
import 'package:edt/pages/bottom_bar/provider/profile_provider.dart';
import 'package:edt/pages/driver_home/provider/accepted_provider.dart';
import 'package:edt/pages/expense_tracking/provider/expense_provider.dart';
import 'package:edt/pages/home/provider/location_provider.dart';
import 'package:edt/pages/splash/splash.dart';
import 'package:edt/services/paypal_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ChangeNotifierProvider(create: (_) => UserRoleProvider()),
      ChangeNotifierProvider(create: (_) => DriverDetailsProvider()),
      ChangeNotifierProvider(create: (_) => SignupProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ChangeNotifierProvider(create: (context) => PaymentProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      try {
        BuildContext? context = navigatorKey.currentState?.context;

        if (context != null) {
          PayPalService().checkPendingPayments(context);
        }
      } catch (e) {
        print('Error checking pending payments: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.white),
          scaffoldBackgroundColor: Colors.white),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
