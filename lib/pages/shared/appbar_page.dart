
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/pages/shared/cuestionarios/inicial/cuestionario_inicial_page.dart';
import 'package:chat/pages/shared/settings/terms/cookies.dart';
import 'package:chat/pages/shared/settings/terms/privacity.dart';
import 'package:chat/pages/shared/settings/terms/terms_and_condition.dart';
import 'package:chat/pages/shared/settings/tutorial/tutorial.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  String getInitials(String nombre) {
    if (nombre.trim().isEmpty) return "";
    
    // Dividir el nombre en palabras y eliminar espacios adicionales
    List<String> palabras = nombre.split(" ").where((p) => p.isNotEmpty).toList();
    
    // Caso: Nombre compuesto, tomar la inicial de los dos primeros nombres
    if (palabras.length > 1) {
      return palabras[0][0].toUpperCase() + palabras[1][0].toUpperCase();
    } else {
      // Caso: Solo un nombre, se utiliza la primera letra mayúscula y la segunda letra minúscula
      String primerNombre = palabras[0];
      if (primerNombre.length >= 2) {
        return primerNombre.substring(0, 1).toUpperCase() + primerNombre.substring(1, 2).toLowerCase();
      } else {
        return primerNombre.toUpperCase();
      }
    }
  }

   // Define la altura del AppBar, por lo general se utiliza kToolbarHeight.
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
  final authService = Provider.of<AuthService>(context);
  final usuario = authService.usuario;

  // Obtenemos el servicio una vez (reconstruye el widget cuando cambie)
  final pds = Provider.of<PersonalDataService>(context);

  final notificationCount = 0;
    return AppBar(
      backgroundColor: Colors.black,
      leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      // Ajusta la altura si quieres que ocupe casi toda la pantalla
                      height: MediaQuery.of(context).size.height * 0.9,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          // Sección superior (fija)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                // Datos del usuario (nombre, etc.)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        usuario!.nombre ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 4),

                                    ],
                                  ),
                                ),
                                // Botón de cerrar
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          
                          // Contenido con scroll
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [                                    
                                    // Agrega más secciones o widgets según tu necesidad
                                    // Sección "Account information"
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Configuración',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Botón "Email"
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => InitialQuestionnairePage(),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(child: Text('Información personal')),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Separador
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          const SizedBox(height: 8),
                                          // Botón "Email"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(child: Text('Email')),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Separador
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          
                                          // Botón "Cambiar nombre"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(child: Text('Nombre')),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Separador
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // Botón "Cambiar idioma"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(child: Text('Idioma')),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Separador
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // Botón "Account plan" con "Trial"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: [
                                                  const Expanded(child: Text('Plan')),
                                                  // Etiqueta "Trial"
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    child: const Text(
                                                      'Trial',
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  const Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Sección "Notifications"
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Notificaciones',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Botón "Habit reminder"
                                          // InkWell(
                                          //   onTap: () {
                                          //     // Navegar o mostrar algo al pulsar
                                          //   },
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          //     child: Row(
                                          //       children: const [
                                          //         Expanded(child: Text('Habit reminder')),
                                          //         Icon(Icons.chevron_right),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          // Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // // Botón "Additional daily reminder"
                                          // InkWell(
                                          //   onTap: () {
                                          //     // Navegar o mostrar algo al pulsar
                                          //   },
                                          //   child: Padding(
                                          //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          //     child: Column(
                                          //       crossAxisAlignment: CrossAxisAlignment.start,
                                          //       children: [
                                          //         Row(
                                          //           children: const [
                                          //             Expanded(child: Text('Additional daily reminder')),
                                          //             Icon(Icons.chevron_right),
                                          //           ],
                                          //         ),
                                          //         const SizedBox(height: 4),
                                          //         const Text(
                                          //           'An all-in-one reminder to do your habits every day',
                                          //           style: TextStyle(fontSize: 12, color: Colors.grey),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // "App suggestions" con Switch
                                          // ENVOLVEMOS en un Consumer para que solo esta parte "escuche"
                                          Consumer<PersonalDataService>(
                                            builder: (context, pds, _) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                child: Row(
                                                  children: [

                                                    if(pds.notificacionesActivadas) const Expanded(child: Text('Activadas')),
                                                    if(!pds.notificacionesActivadas) const Expanded(child: Text('Desactivadas')),
                                                    Switch(
                                                      value: pds.notificacionesActivadas,
                                                      activeColor: rojoBurdeos,
                                                      onChanged: (bool newValue) async {
                                                        final uid = Provider.of<AuthService>(context, listen: false).usuario!.uid;
                                                        // Llamamos a nuestro método optimista o directamente al backend
                                                        await pds.updatePersonalDataByUserId(
                                                          uid,
                                                          {'notificacionesActivadas': newValue},
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),

                                          

                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          //   child: Row(
                                          //     children: [
                                          //       const Expanded(child: Text('Play sounds')),
                                          //       // Puedes guardar el estado del switch en una variable
                                          //       Switch(
                                          //         value: true, 
                                          //         onChanged: (bool newValue) {
                                          //           // Lógica para habilitar/deshabilitar
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),

                                        ],
                                      ),
                                    ),

                                    // Sección "Settings" (opcional)

                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Información',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // "Tutorial"
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TutorialPage(),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Tutorial'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "Cookies"
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CookiePolicyPage(), // Ajusta el nombre si tu widget es otro
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Política de cookies'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "Privacy Policy"
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PrivacyPolicyPage(), // Ajusta el nombre si tu widget es otro
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Política de privacidad'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "Terms and Conditions"
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TermsAndConditionsPage(), // Ajusta el nombre si tu widget es otro
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                            
                                              child: Row(
                                                children: const [
                                                  Text('Términos y condiciones'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          // "Log out"
                                          InkWell(
                                            onTap: () async {
                                              final authService = Provider.of<AuthService>(context, listen: false);
                                              // await authService.logout();
                                              Navigator.pushReplacementNamed(context, 'login');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                    child: Text(
                                                      'Cerrar sesión',
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons.chevron_right, color: Colors.redAccent),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "Delete account and data"
                                          InkWell(
                                            onTap: () {
                                              // Acción para eliminar cuenta
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                    child: Text(
                                                      'Borrar cuenta',
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons.chevron_right, color: Colors.redAccent),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                backgroundColor: const Color(0xFFCCCCCC),
                child: Text(
                  getInitials(usuario?.nombre ?? ""),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
    ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Acción para el botón de notificaciones
              },
            ),
            if (notificationCount > 0)
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
