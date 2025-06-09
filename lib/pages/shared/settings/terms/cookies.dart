import 'package:flutter/material.dart';

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final bodyStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      height: 1.5,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Política de Cookies'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Cookies y Tecnologías de Seguimiento de Ser Invencible APP',
              style: headerStyle,
            ),
            const SizedBox(height: 4),
            Text('Última actualización: 23 de mayo de 2025', style: bodyStyle),
            const Divider(color: Colors.grey),
            Text('1. Introducción', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Este documento informa sobre las tecnologías ("Trackers") que Ser Invencible APP, S.L. '
              '(en adelante, "la Empresa" o "nosotros") utiliza en la aplicación móvil y web '
              '"Ser Invencible APP" (en adelante, "la Aplicación"). Los Trackers permiten almacenar '
              'y acceder a información en el dispositivo del Usuario para ofrecer y mejorar el Servicio.\n\n'
              'A efectos de esta Política, se incluye bajo el término genérico Trackers tanto las '
              'Cookies (sólo en entornos web) como otras tecnologías análogas (por ejemplo, local storage, '
              'scripts, beacons).',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),
            Text('2. Tipos de Trackers y Finalidades', style: headerStyle),
            const SizedBox(height: 8),
            // Wrap the table in horizontal scroll to avoid truncation
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[800]),
                dataRowColor: MaterialStateProperty.all(Colors.grey[900]),
                columns: [
                  DataColumn(label: Text('Tracker', style: bodyStyle)),
                  DataColumn(label: Text('Tipo', style: bodyStyle)),
                  DataColumn(label: Text('Finalidad', style: bodyStyle)),
                  DataColumn(label: Text('Duración', style: bodyStyle)),
                  DataColumn(label: Text('Gestión', style: bodyStyle)),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Cookie técnica de sesión', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Primera parte', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Soporte de funcionalidades básicas (autenticación, navegación)', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Session (temporal)', style: TextStyle(color: Colors.white))),
                    DataCell(Text('No requiere consentimiento', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Cloudflare', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Tercera parte', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Seguridad, firewall, rendimiento', style: TextStyle(color: Colors.white))),
                    DataCell(Text('7 días', style: TextStyle(color: Colors.white))),
                    DataCell(Text('No requiere consentimiento', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Google Analytics 4', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Tercera parte', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Análisis estadístico de uso, mejora de la Aplicación', style: TextStyle(color: Colors.white))),
                    DataCell(Text('2 años', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Requiere consentimiento; panel de preferencias', style: TextStyle(color: Colors.white))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nota: La tabla anterior resume los Trackers más relevantes; otros Trackers de proveedores pueden aplicarse en módulos específicos (p. ej. mapas, vídeos). Consulte las políticas de cada tercero para más detalles.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),
            Text('3. Gestión de Preferencias', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Puede configurar o modificar sus preferencias de Trackers en cualquier momento a través del panel de privacidad accesible desde la Aplicación:\n\n'
              '1. Abra el menú de configuración.\n'
              '2. Seleccione "Privacidad y cookies".\n'
              '3. Active o desactive categorías de Trackers (Técnicos, Analíticos, Publicitarios).\n\n'
              'La desactivación de Trackers analíticos o publicitarios es un acto de consentimiento que puede retirar libremente.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),
            Text('4. Control y Eliminación a Nivel de Navegador o Dispositivo', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Además del panel anterior, puede gestionar las Cookies y tecnologías similares directamente desde su navegador o dispositivo:\n\n'
              '• Navegadores web: acceda a la sección de Cookies o privacidad en la configuración y elimine, bloquee o visualice las Cookies.\n'
              '• Dispositivos móviles: utilice las opciones de privacidad o anuncios en los ajustes del sistema operativo.\n\n'
              'Consulte los enlaces de ayuda de su navegador: Chrome, Firefox, Safari, Edge, Opera, Brave.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),
            Text('5. Consecuencias de Bloquear Trackers', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Si decide bloquear Trackers técnicos, es posible que algunas funcionalidades esenciales de la Aplicación no estén disponibles o funcionen de forma limitada. '
              'La desactivación de Trackers analíticos o publicitarios no afectará al acceso básico, pero reducirá la capacidad de personalización y mejora continua del Servicio.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),
            Text('6. Responsable del Tratamiento', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              '• Denominación social: Ser Invencible APP, S.L.\n'
              '• Dirección: Ronda de l\'Est, 87, 08210 Barcelona, España\n'
              '• Correo de contacto: privacidad@serinvencible.es',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),
            Text('7. Referencias Legales', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              '• Reglamento (UE) 2016/679 (RGPD)\n'
              '• Ley Orgánica 3/2018 (LOPDGDD)\n'
              '• Ley 34/2002 (LSSI-CE)\n\n'
              'Para cualquier duda o ejercicio de derechos en materia de privacidad: privacidad@serinvencible.com',
              style: bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}