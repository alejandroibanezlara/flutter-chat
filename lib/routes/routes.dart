

import 'package:chat/maintenance/microlearning/maintenance_web_page.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/pages/main_menu/_old/chat_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_counter_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_crono_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_inverse_counter_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_math_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_questionnaire_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_tempo_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_single_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_writting_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/tools/breathe/breathe_setup_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/tools/focus/focus_page.dart';
import 'package:chat/pages/main_menu/retos/tipos/reto_checklist_page.dart';
import 'package:chat/pages/main_menu/retos/reto_fin_page.dart';
import 'package:chat/pages/main_menu/retos/reto_introduccion_page.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/goal_page.dart';
import 'package:chat/pages/main_menu/home_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/main_menu/progress_page.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/reason_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/tools/meditation/meditation_page.dart';
import 'package:chat/pages/main_menu/ser_invencible/tools/meditation/meditation_setup_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/main_menu/rutinas_page.dart';
import 'package:chat/pages/main_menu/rutinas/rutinas/new_habit_page.dart';
import 'package:chat/pages/main_menu/ser_invencible_page.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_1.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_2.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_3.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_4.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_5.dart';
import 'package:chat/pages/shared/cuestionarios/inicial/cuestionario_inicial_page.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_1.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_2.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_3.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_4.dart';
// import 'package:chat/pages/shared/juegos/connect.dart';
import 'package:chat/pages/main_menu/_old/usuarios_page.dart';
import 'package:flutter/material.dart';


final Map<String, Widget Function(BuildContext)>  appRoutes = {

  'usuarios'  : ( _ ) => UsuariosPage(),
  'chat'      : ( _ ) => ChatsPage(),

  
  'register'  : ( _ ) => RegisterPage(),
  'login'     : ( _ ) => LoginPage(),
  'loading'   : ( _ ) => LoadingPage(),
  'home'      : ( _ ) => HomePage(),
  // 'countdown'      : ( _ ) => CountdownTimerDisplayPage(),
  // 'tabata'      : ( _ ) => TabataTimerPage(),
  //RUTINAS
  'rutinas'   : ( _ ) => RutinasPage(),
  'habits'   : ( _ ) => RutinasPage(),
  'newHabit'   : ( _ ) => NewHabitPage(),
  'habitSummary'   : ( _ ) => HabitSummaryPage(habito: '', timePlace: '', personType: '',),
  

  //PROGRESO
  'progress'  : ( _ ) => ProgressPage(),
  // 'firstgoal'  : ( _ ) => FirstGoalScreen(),
  'namegoal'  : ( _ ) => NameGoalScreen(tipo: 1),
  'benefit'  : ( _ ) => BenefitGoalScreen(),

  //SER INVENCIBLE
  'ser_invencible'  : ( _ ) => SerInvenciblePage(),
  // 'connect'      : ( _ ) => ConnectTheDotsGame(),

  //Retos
  
  'reto_introduccion': (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoIntroduccionPage(reto: reto);
  },


  'reto_counter' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoCounterPage(reto: reto);
  },
  'reto_inverse_counter' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoInverseCounterPage(reto: reto);
  },
  'reto_checklist' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoChecklistPage(reto: reto);
  },
  'reto_crono' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoCronoPage(reto: reto);
  },
  'reto_tempo' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoTempoPage(reto: reto);
  },
  // 'reto_cuestionario' : ( _ ) => RetoIntroduccionPage(),
  'reto_writing' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoWritingPage(reto: reto);
  },
  'reto_math' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoMathPage(reto: reto);
  },
  'reto_unico' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoSinglePage(reto: reto);
  },
  'reto_questionnaire' : (context) {
    final reto = ModalRoute.of(context)!.settings.arguments as Challenge;
    return RetoQuestionnairePage(reto: reto);
  },
  'reto_fin' : ( _ ) => RetoFinPage(),

  //CUESTIONARIO INICIAL APP
  'cuestionario_inicial_app'  : ( _ ) => InitialQuestionnairePage(),


  //CUESTIONARIO INICIO DIA
  'cuestionario_inicial_1'  : ( _ ) => FirstStartDayPage(),
  'cuestionario_inicial_2'  : ( _ ) => SecondStartDayPage(),
  'cuestionario_inicial_3'  : ( _ ) => ThirdStartDayPage(),
  'cuestionario_inicial_4'  : ( _ ) => FourthStartDayPage(),


  //CUESTIONARIO FINAL
  'cuestionario_final_1'  : ( _ ) => FirstQuestionPage(),
  'cuestionario_final_2'  : ( _ ) => SecondQuestionPage(),
  'cuestionario_final_3'  : ( _ ) => ThirdQuestionPage(),
  'cuestionario_final_4'  : ( _ ) => FourthQuestionPage(),
  'cuestionario_final_5'  : ( _ ) => FifthQuestionPage(),



  //TOOLS
  'focus'      : ( _ ) => FocusModulePage(),
  'meditation'      : ( _ ) => MeditationSetupPage(),
  'breathing'      : ( _ ) => BreathingWelcomePage(),

  
  // 'meditation'      : ( _ ) => MeditationWidget(meditationDuration: Duration(seconds: 30),),
  
  

  // Pequeños textos para enseñar las claves para ser invencible
  // 'mindset'  : ( _ ) => SerInvenciblePage(),
  // añadir amigos para competicion sana
  // 'comunidad'  : ( _ ) => SerInvenciblePage(),


  ///ADMIN
  ///MicrolearningAdminPage
  ///
  'admin_microlearning'  : ( _ ) => MicrolearningAdminPage(),
  ///MicrolearningAdminPage
};