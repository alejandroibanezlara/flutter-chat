import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/challenge_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/dailytask/dailytaks_service.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:chat/services/personalData/metaData_User_service.dart';
import 'package:chat/services/personalData/microlearning_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/usuarioData/serInvencibleData_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 1) Inicializar zonas horarias
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Madrid'));

  // 2) Inicializar flutter_local_notifications
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios     = DarwinInitializationSettings();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: android, iOS: ios),
  );



  // 3) Solicitar permisos en iOS (iOS 10+)
  await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(alert: true, badge: true, sound: true);

  // 4) Arranca la app
  runApp(const MyApp());
  
} 



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(),),
        ChangeNotifierProvider(create: (_) => SocketService(),),
        ChangeNotifierProvider(create: (_) => ChatService(),),
        ChangeNotifierProvider(create: (_) => DailyTaskService(),),
        ChangeNotifierProvider(create: (_) => RoutineService()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => PersonalDataService()),
        ChangeNotifierProvider(create: (_) => ObjectivesService()),
        ChangeNotifierProvider(create: (_) => SerInvencibleService()),
        ChangeNotifierProvider(create: (_) => MicrolearningProvider()),
        // ChangeNotifierProvider(create: (_) => ChallengeService()),
        // ChangeNotifierProvider(create: (_) => UserChallengeService()),

        ChangeNotifierProvider(create: (_) => UserChallengeService()),
        
        
        ChangeNotifierProxyProvider<UserChallengeService, ChallengeService>(
          create: (ctx) => ChallengeService(ctx.read<UserChallengeService>()),
          update: (ctx, ucService, previous) {
            previous!..updateUserChallengeService(ucService);
            
            return previous;
          },
        ),

        ChangeNotifierProxyProvider<ChallengeService, UserChallengeService>(
          create: (ctx) =>           // toma la instancia ya creada más arriba
              ctx.read<UserChallengeService>(),
          update: (ctx, challengeSvc, ucSvc) =>
              ucSvc!..setChallengeService(challengeSvc),
        ),


        ChangeNotifierProvider(create: (_) => MetaDataUserService()),
        
      ],
      child: MaterialApp(
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}