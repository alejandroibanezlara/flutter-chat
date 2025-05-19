import 'package:flutter/material.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class RetoCard extends StatelessWidget {
  final IconData iconData;       // Icono representativo del reto (FontAwesome)
  final String titulo;           // Título del reto
  final String descripcion;      // Descripción del reto
  final List<IconData> iconos;   // Lista de iconos para representar aspectos del reto
  final bool compact;

  const RetoCard({
    Key? key,
    required this.iconData,
    required this.titulo,
    required this.descripcion,
    required this.iconos,
    this.compact = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Se usan márgenes y padding reducidos si compact es true.
    final EdgeInsets margin =
        compact ? const EdgeInsets.all(4.0) : const EdgeInsets.all(16.0);
    final EdgeInsets padding =
        compact ? const EdgeInsets.all(8.0) : const EdgeInsets.all(12.0);
    final double iconContainerSize = compact ? 80 : 100;
    final double iconSize = compact ? 40 : 50;
    final double titleFontSize = compact ? 18 : 22;
    final double descriptionFontSize = compact ? 14 : 16;

    return Container(
      margin: margin,
      padding: padding,
      // Ajustamos la altura a 200 píxeles:
      height: 250,
      decoration: BoxDecoration(
        color: blancoSuave,
        borderRadius: BorderRadius.circular(12.0),
        // Sin sombra para mantener un diseño limpio
      ),
      // La columna se ajusta al contenido, dentro del límite impuesto por height.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila con el ícono y la información del reto.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: grisClaro.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: FaIcon(
                    iconData,
                    size: iconSize,
                    color: grisClaro,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: negroAbsoluto,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: iconos
                          .map((icono) => Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Icon(
                                  icono,
                                  size: 16,
                                  color: grisClaro,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          // Descripción del reto, limitada a 3 líneas.
          Text(
            descripcion,
            style: TextStyle(
              fontSize: descriptionFontSize,
              color: negroAbsoluto,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 35),
          // Fila de botones para acciones relacionadas al reto.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'reto_introduccion');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: negroAbsoluto,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontSize: 14, color: blancoSuave),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: negroAbsoluto, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Rechazar',
                  style: TextStyle(fontSize: 14, color: negroAbsoluto),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}