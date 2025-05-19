

import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/main_menu/inicio/focus_page.dart';
import 'package:chat/pages/main_menu/retos/reto_checklist_page.dart';
import 'package:chat/pages/main_menu/retos/reto_contador_page.dart';
import 'package:chat/pages/main_menu/retos/reto_crono_page.dart';
import 'package:chat/pages/main_menu/retos/reto_fin_page.dart';
import 'package:chat/pages/main_menu/retos/reto_introduccion_page.dart';
import 'package:chat/pages/main_menu/retos/reto_texto_page.dart';
import 'package:chat/pages/main_menu/retos/reto_unico_page.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/goal_page.dart';
import 'package:chat/pages/main_menu/home_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/main_menu/progress_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/main_menu/rutinas_page.dart';
import 'package:chat/pages/main_menu/rutinas/rutinas/new_habit_page.dart';
import 'package:chat/pages/main_menu/ser_invencible_page.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_1.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_2.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_3.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_4.dart';
import 'package:chat/pages/shared/cuestionarios/fin_dia/cuestionario_fin_dia_page_5.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_1.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_2.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_3.dart';
import 'package:chat/pages/shared/cuestionarios/inicio_dia/cuestionario_inicio_dia_page_4.dart';
import 'package:chat/pages/shared/juegos/connect.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)>  appRoutes = {

  'usuarios'  : ( _ ) => UsuariosPage(),
  'chat'      : ( _ ) => ChatsPage(),

  
  'register'  : ( _ ) => RegisterPage(),
  'login'     : ( _ ) => LoginPage(),
  'loading'   : ( _ ) => LoadingPage(),
  'home'      : ( _ ) => HomePage(),
  'focus'      : ( _ ) => FocusModulePage(),
  // 'countdown'      : ( _ ) => CountdownTimerDisplayPage(),
  // 'tabata'      : ( _ ) => TabataTimerPage(),
  //RUTINAS
  'rutinas'   : ( _ ) => RutinasPage(),
  'habits'   : ( _ ) => RutinasPage(),
  'newHabit'   : ( _ ) => NewHabitPage(),
  'habitSummary'   : ( _ ) => HabitSummaryPage(habito: '', timePlace: '', personType: '',),
  

  //PROGRESO
  'progress'  : ( _ ) => ProgressPage(),
  'firstgoal'  : ( _ ) => FirstGoalScreen(),
  'namegoal'  : ( _ ) => NameGoalScreen(),

  //SER INVENCIBLE
  'ser_invencible'  : ( _ ) => SerInvenciblePage(),
  'connect'      : ( _ ) => ConnectTheDotsGame(),

  //Retos
  'reto_introduccion' : ( _ ) => RetoIntroduccionPage(),
  'reto_contador' : ( _ ) => RetoContadorPage(),
  'reto_checklist' : ( _ ) => RetoChecklistPage(),
  'reto_crono' : ( _ ) => RetoCronoPage(),
  'reto_cuestionario' : ( _ ) => RetoIntroduccionPage(),
  'reto_texto' : ( _ ) => RetoTextoPage(),
  'reto_unico' : ( _ ) => RetoUnicoPage(),
  'reto_fin' : ( _ ) => RetoFinPage(),

  //CUESTIONARIO inicial
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
  // Pequeños textos para enseñar las claves para ser invencible
  // 'mindset'  : ( _ ) => SerInvenciblePage(),
  // añadir amigos para competicion sana
  // 'comunidad'  : ( _ ) => SerInvenciblePage(),
};