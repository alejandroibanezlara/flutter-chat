
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
                                        usuario!.nombre,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '4 active habits • 3 identities',
                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                      ),
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
                                    // Ejemplo de "Accountability partner"
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black87,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: const [
                                              Icon(Icons.person,
                                                  color: Colors.orange, size: 24),
                                              SizedBox(width: 8),
                                              Text(
                                                'Accountability partner',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'You are more likely to stick to your habits if someone else knows about them.',
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              // onPrimary: Colors.black87,
                                              shape: const StadiumBorder(),
                                            ),
                                            child: const Text('Invite someone'),
                                          ),
                                          const SizedBox(height: 12),
                                          OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              side: const BorderSide(color: Colors.white70),
                                              shape: const StadiumBorder(),
                                            ),
                                            child: const Text('Have an invite from someone?'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Agrega más secciones o widgets según tu necesidad
                                    // Sección "Account information"
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16.0),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Account information',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                                          // Botón "Account plan" con "Trial"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: [
                                                  const Expanded(child: Text('Account plan')),
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
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // Botón "Connect on web"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(child: Text('Connect on web')),
                                                  Icon(Icons.chevron_right),
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
                                            'Notifications',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Botón "Habit reminder"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(child: Text('Habit reminder')),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // Botón "Additional daily reminder"
                                          InkWell(
                                            onTap: () {
                                              // Navegar o mostrar algo al pulsar
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: const [
                                                      Expanded(child: Text('Additional daily reminder')),
                                                      Icon(Icons.chevron_right),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  const Text(
                                                    'An all-in-one reminder to do your habits every day',
                                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),
                                          // "App suggestions" con Switch
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                                            child: Row(
                                              children: [
                                                const Expanded(child: Text('App suggestions')),
                                                // Puedes guardar el estado del switch en una variable
                                                Switch(
                                                  value: true, 
                                                  onChanged: (bool newValue) {
                                                    // Lógica para habilitar/deshabilitar
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                                            child: Row(
                                              children: [
                                                const Expanded(child: Text('Play sounds')),
                                                // Puedes guardar el estado del switch en una variable
                                                Switch(
                                                  value: true, 
                                                  onChanged: (bool newValue) {
                                                    // Lógica para habilitar/deshabilitar
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),

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
                                            'Settings',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // "Language preferences"
                                          InkWell(
                                            onTap: () {
                                              // Acción o navegación
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Language preferences'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "Tutorials"
                                          InkWell(
                                            onTap: () {
                                              // Acción o navegación
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('👋 Tutorials'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "FAQ's"
                                          InkWell(
                                            onTap: () {
                                              // Acción o navegación
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text("FAQ's"),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(color: Colors.grey[300], height: 0, thickness: 1),

                                          // "Help and support"
                                          InkWell(
                                            onTap: () {
                                              // Acción o navegación
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Help and support'),
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
                                              // Acción o navegación
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Privacy Policy'),
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
                                              // Acción o navegación
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                                              child: Row(
                                                children: const [
                                                  Text('Terms and Conditions'),
                                                  Spacer(),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          // "Log out"
                                          InkWell(
                                            onTap: () {
                                              // Acción de cierre de sesión
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                    child: Text(
                                                      'Log out',
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
                                                      'Delete account and data',
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
