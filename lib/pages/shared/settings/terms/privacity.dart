import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

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
        title: const Text('Política de Privacidad'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidad de Ser Invencible APP',
              style: headerStyle,
            ),
            const SizedBox(height: 4),
            Text('Última actualización: 23 de mayo de 2025', style: bodyStyle),
            const Divider(color: Colors.grey),

            // 1. Responsable del Tratamiento
            Text('1. Responsable del Tratamiento', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Denominación social: Ser Invencible APP, S.L.\n'
              'Dirección: Ronda de l\'Est, 87, 08210 Barcelona, España\n'
              'Correo de contacto: privacidad@serinvencible.es\n\n'
              'Ser Invencible APP, S.L. (en adelante, "la Empresa" o "nosotros") es el Responsable del '
              'Tratamiento de sus datos personales, de conformidad con el Reglamento (UE) 2016/679 ("RGPD") '
              'y la Ley Orgánica 3/2018, de Protección de Datos Personales y garantía de los derechos '
              'digitales ("LOPDGDD").',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 2. Datos que Recogemos y Finalidades
            Text('2. Datos que Recogemos y Finalidades', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Recogemos y tratamos los siguientes tipos de datos personales:\n\n'
              '• Identificativos: dirección IP, identificadores de usuario anónimos.\n'
              '• De contacto: correo electrónico cuando se registre en la newsletter.\n'
              '• De uso y analítica: estadísticas de sesión, páginas visitadas, eventos dentro de la App.\n'
              '• Trackers y Cookies: identificadores de seguimiento para optimizar experiencia y seguridad.\n\n'
              'Finalidades del tratamiento:\n'
              '• Prestación del servicio: gestión de cuentas, funcionalidades de la App.\n'
              '• Análisis y mejora: monitorización de uso, detección de errores y mejora de la experiencia.\n'
              '• Comunicación promocional: envío de newsletters y ofertas solo si se ha dado consentimiento.\n'
              '• Seguridad y prevención de fraudes: análisis de patrones de uso y detección de comportamientos anómalos.\n'
              '• Cumplimiento legal: obligaciones fiscales, contables y regulatorias.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 3. Base Jurídica y Plazos de Conservación
            Text('3. Base Jurídica y Plazos de Conservación', style: headerStyle),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[800]),
                dataRowColor: MaterialStateProperty.all(Colors.grey[900]),
                columns: [
                  DataColumn(label: Text('Finalidad', style: bodyStyle)),
                  DataColumn(label: Text('Base jurídica', style: bodyStyle)),
                  DataColumn(label: Text('Plazo de conservación', style: bodyStyle)),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Prestación del servicio', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Ejecución de contrato', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Hasta la finalización del servicio', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Análisis y mejora', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Interés legítimo', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Revisión anual, máximo 2 años', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Comunicación promocional', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Consentimiento del usuario', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Hasta revocación del consentimiento', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Seguridad y prevención de fraudes', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Interés legítimo', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Mientras persista el fin; revisión anual', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Cumplimiento legal', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Obligación legal', style: TextStyle(color: Colors.white))),
                    DataCell(Text('5 años (fiscal/contable)', style: TextStyle(color: Colors.white))),
                  ]),
                ],
              ),
            ),
            const Divider(color: Colors.grey),

            // 4. Proveedores y Transferencias Internacionales
            Text('4. Proveedores y Transferencias Internacionales', style: headerStyle),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[800]),
                dataRowColor: MaterialStateProperty.all(Colors.grey[900]),
                columns: [
                  DataColumn(label: Text('Proveedor / Servicio', style: bodyStyle)),
                  DataColumn(label: Text('Tipo', style: bodyStyle)),
                  DataColumn(label: Text('Datos tratados', style: bodyStyle)),
                  DataColumn(label: Text('Ubicación', style: bodyStyle)),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Google Analytics 4', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Analítica web', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Número de usuarios, sesiones, trackers, Usage Data', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Estados Unidos', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Webflow', style: TextStyle(color: Colors.white))),
                    DataCell(Text('CMS y hosting', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Registro, comentarios, base de datos, e-commerce', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Estados Unidos', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('jsDelivr CDN', style: TextStyle(color: Colors.white))),
                    DataCell(Text('CDN / tráfico', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Usage Data', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Polonia', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Cloudflare', style: TextStyle(color: Colors.white))),
                    DataCell(Text('CDN / firewall / seguridad', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Trackers y datos de tráfico', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Estados Unidos', style: TextStyle(color: Colors.white))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando sus datos se transfieren fuera de la UE, aplicamos las Cláusulas Contractuales Tipo de la Comisión Europea como garantía adecuada.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 5. Derechos de los Interesados y Ejercicio
            Text('5. Derechos de los Interesados y Ejercicio', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Usted tiene derecho a:\n'
              '• Acceder a sus datos.\n'
              '• Solicitar su rectificación o supresión.\n'
              '• Limitar u oponerse al tratamiento.\n'
              '• Portar sus datos.\n'
              '• Retirar el consentimiento en cualquier momento sin afectar la licitud del tratamiento previo.\n\n'
              'Para ejercer estos derechos, puede enviar su solicitud a privacidad@serinvencible.es '
              'Responderemos en el plazo de un mes (prorrogable dos meses si la complejidad lo requiere), según lo establecido en el RGPD.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 6. Cambios en la Política
            Text('6. Cambios en la Política', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Podemos actualizar esta política periódicamente. Publicaremos la versión revisada en esta misma página con la fecha de la última actualización. '
              'Se recomienda revisarla con regularidad.\n\n'
              'Ser Invencible APP, S.L. agradece su confianza en el tratamiento de sus datos. '
              'Si tiene cualquier duda, contáctenos en privacidad@serinvencible.es',
              style: bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}
