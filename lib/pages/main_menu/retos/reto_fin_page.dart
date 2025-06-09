import 'package:chat/pages/main_menu/retos/cuadro_metricas.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chat/pages/shared/colores.dart';


class RetoFinPage extends StatelessWidget {
  const RetoFinPage({Key? key}) : super(key: key);


  /// Tarjeta informativa para el scroll horizontal
  Widget buildInfoCard({
    required String title,
    required String subtitle,
    IconData? icon,
    Color? backgroundColor,
  }) {


return Container(
  width: 250,
  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
  padding: const EdgeInsets.all(16.0),
  // Se establece una altura máxima para evitar que el contenido se salga
  constraints: const BoxConstraints(
    maxHeight: 350, // Ajusta este valor según tus necesidades
  ),
  decoration: BoxDecoration(
    color: dorado.withOpacity(0.9),
    borderRadius: BorderRadius.circular(16.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 8,
        offset: Offset(0, 4),
      )
    ],
  ),
  // Se utiliza Stack para elementos decorativos y se evita que el contenido cause overflow.
  child: Stack(
    clipBehavior: Clip.none, // Permite que los elementos posicionados puedan salir sin recortar (si es deseado)
    children: [
      // Elemento decorativo en la esquina superior derecha
      // Positioned(
      //   top: -10,
      //   right: -10,
      //   child: FaIcon(
      //     FontAwesomeIcons.solidStar,
      //     size: 50,
      //     color: Colors.white.withOpacity(0.2),
      //   ),
      // ),
      // Contenido principal que se adapta al espacio disponible gracias a un SingleChildScrollView
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: muestra el icono (si existe) y el título
            if (icon != null)
              Row(
                children: [
                  FaIcon(icon, size: 28, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            else
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 8),
            // Subtítulo
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            // const SizedBox(height: 12),
            // // Fila de iconos decorativos usando Wrap para evitar overflow horizontal
            // Wrap(
            //   alignment: WrapAlignment.center,
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: [
            //     Container(
            //       width: 40,
            //       height: 40,
            //       decoration: BoxDecoration(
            //         color: Colors.white24,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: const Center(
            //         child: FaIcon(FontAwesomeIcons.crown, size: 20, color: Colors.yellow),
            //       ),
            //     ),
            //     Container(
            //       width: 40,
            //       height: 40,
            //       decoration: BoxDecoration(
            //         color: Colors.white24,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: const Center(
            //         child: FaIcon(FontAwesomeIcons.solidClock, size: 20, color: Colors.white),
            //       ),
            //     ),
            //     Container(
            //       width: 40,
            //       height: 40,
            //       decoration: BoxDecoration(
            //         color: Colors.white24,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: const Center(
            //         child: FaIcon(FontAwesomeIcons.chartLine, size: 20, color: Colors.greenAccent),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 12),
            // // Botón "Compartir" opcional
            // TextButton.icon(
            //   onPressed: () {
            //     // Lógica para compartir
            //   },
            //   icon: const Icon(Icons.share, color: Colors.blue),
            //   label: const Text(
            //     'Compartir',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
          ],
        ),
      ),
    ],
  ),
);
    
  }

  /// Sección de contactos: muestra varios CircleAvatars en fila
  Widget buildContactSection() {
    // Lista de identificadores de los contactos
    final List<String> contactos = ['AL', 'BE', 'CR', 'DI', 'EV', 'AL', 'BE', 'CR', 'DI', 'EV'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tus Invencibles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: blancoSuave,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          // Se aumenta la altura a 80 para dar más espacio
          height: 80,
          child: ListView.separated(
            shrinkWrap: true, // Permite que la lista se ajuste a sus hijos
            scrollDirection: Axis.horizontal,
            itemCount: contactos.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: grisClaro,
                    child: Text(
                      contactos[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: negroAbsoluto,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   'Amigo ${index + 1}',
                  //   style: const TextStyle(
                  //     fontSize: 12,
                  //     color: negroAbsoluto,
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Cuadro con métricas adicionales
  Widget buildMetricBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: grisClaro,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Métricas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: negroAbsoluto,
                  ),
                ),
              ),
              Icon(Icons.assessment, color: negroAbsoluto),
            ],
          ),
          const SizedBox(height: 12),
          // Lista de métricas en filas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Días Activo', '15'),
              _buildMetricItem('Reto Total', '20'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Puntos', '345'),
              _buildMetricItem('Niveles', '5'),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para un item de métrica
  static Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: negroAbsoluto,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: negroAbsoluto,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final currentStep = 2;
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // Flecha a la izquierda (atras minimalista)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Acción para ir atrás
            Navigator.of(context).pushNamedAndRemoveUntil(
              'home',                           // Nombre de tu ruta Home
              (Route<dynamic> route) => false,  // Elimina todo lo anterior
            );
          },
        ),
        // 5 barras centrales para indicar el paso actual
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              // Cambia 'currentStep' por la variable que controla en qué paso estás (0..4)
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        // Botón "X" a la derecha para volver al inicio
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Acción para volver al inicio
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
           body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de scroll horizontal de tarjetas informativas con paginación
              SizedBox(
                height: 180,
                child: PageView(
                  physics: const PageScrollPhysics(),
                  children: [
                    buildInfoCard(
                      title: '¡Estás a tope!',
                      subtitle:
                          'Racha: 7 días consecutivos cumpliendo retos',
                      icon: FontAwesomeIcons.fire,
                      backgroundColor: dorado.withValues(alpha:0.9),
                    ),
                    buildInfoCard(
                      title: 'Tiempo vs Competencia',
                      subtitle:
                          'Tardaste 3m 45s en completar el reto\nPromedio de otros: 4m 10s',
                      icon: FontAwesomeIcons.stopwatch,
                      backgroundColor: dorado.withValues(alpha:0.9),
                    ),
                    buildInfoCard(
                      title: 'Tu Percentil',
                      subtitle:
                          'Estás en el 85º percentil\nrespecto a los jugadores',
                      icon: FontAwesomeIcons.chartPie,
                      backgroundColor: dorado.withValues(alpha:0.9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Sección de contactos de "tus invencibles"
              buildContactSection(),
              const SizedBox(height: 24),
              // Cuadro con métricas adicionales
              RetoMetricas(),
            ],
          ),
        ),
      ),
    );
  }
}





