import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

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
        title: const Text('Términos y Condiciones'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TÉRMINOS Y CONDICIONES DE USO DE Ser Invencible APP',
              style: headerStyle,
            ),
            const SizedBox(height: 4),
            Text('Última actualización: 23 de mayo de 2025', style: bodyStyle),
            const Divider(color: Colors.grey),

            // 1. Introducción
            Text('1. Introducción', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Estas condiciones regulan el uso de la aplicación móvil y/o web "Ser Invencible APP" '
              '(en adelante, "la Aplicación" o "el Servicio"), así como cualquier otra relación legal derivada '
              'entre el Usuario y Ser Invencible APP, S.L. (en adelante, "la Empresa").\n\n'
              'Al utilizar la Aplicación, usted acepta quedar vinculado por estos Términos y Condiciones en la versión '
              'publicada en el momento de su acceso. Si ha obtenido la Aplicación a través de tiendas de apps (por ejemplo, '
              'Apple App Store o Google Play Store), también acepta las condiciones de dichas plataformas.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 2. Datos de la Empresa
            Text('2. Datos de la Empresa', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Denominación social: Ser Invencible APP, S.L.\n'
              'Dirección: Ronda de l\'Est, 87, 08210 Barcelona, España\n'
              'Correo de contacto: privacidad@serinvencible.es\n\n'
              'La Empresa se rige por el Reglamento (UE) 2016/679 (RGPD), la Ley Orgánica 3/2018 (LOPDGDD) '
              'y la Ley 34/2002, de Servicios de la Sociedad de la Información y Comercio Electrónico (LSSI-CE).',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 3. Requisitos de Uso y Registro
            Text('3. Requisitos de Uso y Registro', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Usuarios elegibles: Personas físicas mayores de 14 años y Usuarios consumidores.\n\n'
              'Registro: Para acceder a ciertas funcionalidades, es necesario crear una cuenta. Cada Usuario podrá '
              'tener una única cuenta, intransferible y de uso personal.\n\n'
              'Prohibiciones: Queda prohibido el acceso automatizado, uso compartido de credenciales y la creación de '
              'cuentas por bots.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 4. Contenido y Derechos de Propiedad Intelectual
            Text('4. Contenido y Derechos de Propiedad Intelectual', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Toda la información, gráficos, diseños, logos, textos y demás recursos contenidos en la Aplicación '
              'son propiedad de la Empresa o de sus licenciantes, y están protegidos por la normativa internacional '
              'y española sobre propiedad intelectual.\n\n'
              'Se permite la reproducción de contenidos exclusivamente para uso personal y no comercial, siempre que '
              'se respeten los créditos y marcas de la Empresa.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 5. Uso Aceptable
            Text('5. Uso Aceptable', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'El Usuario se compromete a no emplear la Aplicación para actividades ilícitas, difamatorias, de odio, '
              'o que infrinjan derechos de terceros. La Empresa podrá suspender o dar por terminada su cuenta en caso '
              'de violaciones de estos Términos.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 6. Condiciones de Suscripción y Compra
            Text('6. Condiciones de Suscripción y Compra', style: headerStyle),
            const SizedBox(height: 8),
            // Table for subscriptions
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[800]),
                dataRowColor: MaterialStateProperty.all(Colors.grey[900]),
                columns: [
                  DataColumn(label: Text('Modalidad', style: bodyStyle)),
                  DataColumn(label: Text('Canal', style: bodyStyle)),
                  DataColumn(label: Text('Renovación', style: bodyStyle)),
                  DataColumn(label: Text('Cancelación', style: bodyStyle)),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Suscripción mensual', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Apple/Google Play', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Automática, si no cancelada', style: TextStyle(color: Colors.white))),
                    DataCell(Text('24 h antes de fin de periodo', style: TextStyle(color: Colors.white))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Compras puntuales', style: TextStyle(color: Colors.white))),
                    DataCell(Text('Apple/Google Play', style: TextStyle(color: Colors.white))),
                    DataCell(Text('No aplica', style: TextStyle(color: Colors.white))),
                    DataCell(Text('No reembolsable (según plataforma)', style: TextStyle(color: Colors.white))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los pagos se gestionan exclusivamente a través de la tienda de apps correspondiente y están sujetos '
              'a sus políticas.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 7. Responsabilidad e Indemnización
            Text('7. Responsabilidad e Indemnización', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Limitación de responsabilidad: Salvo lo establecido por la legislación de consumidores, la Empresa '
              'no se hace responsable de daños indirectos ni de interrupciones del servicio derivadas de causas '
              'ajenas.\n\n'
              'Garantías: La Aplicación se ofrece "tal cual"; la Empresa no garantiza satisfacción total ni ausencia '
              'de errores.\n\n'
              'Indemnización: El Usuario indemnizará y mantendrá indemne a la Empresa frente a reclamaciones de terceros '
              'por uso indebido de la Aplicación.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 8. Modificaciones y Terminación
            Text('8. Modificaciones y Terminación', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'La Empresa podrá modificar o interrumpir el Servicio en cualquier momento, notificándolo con antelación '
              'razonable. La continuación del uso tras cambios implica aceptación de los nuevos Términos.',
              style: bodyStyle,
            ),
            const Divider(color: Colors.grey),

            // 9. Legislación Aplicable y Jurisdicción
            Text('9. Legislación Aplicable y Jurisdicción', style: headerStyle),
            const SizedBox(height: 8),
            Text(
              'Estos Términos se rigen por la ley española. Para consumidores, prevalecerán las normas de su lugar de '
              'residencia si ofrecen mayor protección. Cualquier controversia se someterá a los Juzgados y Tribunales de '
              'Barcelona, salvo imperativo legal en contrario.\n\n'
              'Contacto:\nPara consultas, envíe un correo a privacidad@serinvencible.es',
              style: bodyStyle,
            ),
          ],
        ),
      ),
    );
  }
}