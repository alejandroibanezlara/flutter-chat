// third_start_day_page.dart
import 'package:chat/models/serInvencibleData.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/usuarioData/serInvencibleData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThirdStartDayPage extends StatefulWidget {
  const ThirdStartDayPage({Key? key}) : super(key: key);

  @override
  State<ThirdStartDayPage> createState() => _ThirdStartDayPageState();
}

class _ThirdStartDayPageState extends State<ThirdStartDayPage> {
  int? selectedMantra;
  List<MindsetEntry> _displayMantras = [];
  // late List<String> _displayMantras = [];

  final List<String> mantras = [
  'Soy capaz de superar cualquier obstáculo',
  'Cada día es una nueva oportunidad',
  'Confío en mi potencial y en mis habilidades',
  'Hoy elijo la positividad y el crecimiento',
  'Mi mente es fuerte y mi corazón valiente',
  'Abrazo el cambio con entusiasmo',
  'Mi esfuerzo me acerca a mis metas',
  'Cada paso me conduce al éxito',
  'Estoy creando la vida que deseo',
  'Mi actitud define mis resultados',
  'Creo en mi capacidad para triunfar',
  'Tengo el poder de elegir mi actitud',
  'Soy dueño de mi destino',
  'Abro mi mente a nuevas posibilidades',
  'Mi perseverancia rompe barreras',
  'Soy un imán para las oportunidades',
  'El éxito es el resultado de mi constancia',
  'Cada desafío fortalece mi carácter',
  'Mi confianza es inquebrantable',
  'Transformo mis sueños en realidad',
  'Agradezco cada logro, grande o pequeño',
  'Elijo enfocarme en soluciones',
  'Mantengo mi mirada en el objetivo',
  'Supero mis límites día a día',
  'Mi energía positiva atrae lo mejor',
  'Mi pasión impulsa mi progreso',
  'Soy resiliente ante la adversidad',
  'Aprendo y crezco de cada experiencia',
  'Estoy comprometido con mi evolución',
  'Mi mente clara genera acciones efectivas',
  'Tengo la fuerza para seguir adelante',
  'Mis acciones hablan más que mis palabras',
  'Sueño en grande y actúo con determinación',
  'Soy dueño de mis pensamientos',
  'Mi disciplina me guía al éxito',
  'Confío en el proceso de mi crecimiento',
  'Encuentro oportunidad en cada reto',
  'Me esfuerzo hoy para agradecer mañana',
  'La gratitud nutre mi bienestar',
  'Celebro mis avances con orgullo',
  'Mantengo mi visión y construyo mi camino',
  'Aprovecho cada momento con intención',
  'Mi fortaleza interior es mi mayor recurso',
  'Soy imparable cuando me enfoco',
  'La excelencia es mi estándar diario',
  'Mi creatividad abre nuevos caminos',
  'Acojo la calma en medio del caos',
  'Mi voluntad supera cualquier duda',
  'Estoy en paz con mi progreso',
  'Cada día soy más fuerte y sabio',
  ];

  Future<void> _loadMantras() async {
    final _authService = Provider.of<AuthService>(context, listen: false);
    final _serInvencibleService = Provider.of<SerInvencibleService>(context, listen: false);

    final serInvencibleData = await _serInvencibleService.getDataByUserId(_authService.usuario!.uid);

    if (mounted) {
      setState(() {
        _displayMantras = List<MindsetEntry>.from(serInvencibleData.mindset)..shuffle();
        _displayMantras = _displayMantras.take(5).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Barajamos la lista completa y tomamos los primeros 5
    _loadMantras();
    // _displayMantras = (List<String>.from(mantras)..shuffle()).sublist(0, 5);
  }

   @override
  Widget build(BuildContext context) {
    final currentStep = 2;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 40,
              height: 1,
              color: (index <= currentStep) ? Colors.white : Colors.grey[800],
            );
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_displayMantras.isEmpty) ...[
              const SizedBox(height: 80),
              const Text(
                'Puedes añadir tus motivaciones en el apartado Ser invencible, Mindset',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
            ] else ...[
              ...List.generate(_displayMantras.length, (index) {
                return Card(
                  color: (selectedMantra == index) ? rojoBurdeos : Colors.grey[900],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: RadioListTile<int>(
                    value: index,
                    groupValue: selectedMantra,
                    activeColor: Colors.white,
                    selectedTileColor: Colors.transparent,
                    title: Text(
                      _displayMantras[index].texto, // Usa el campo correcto del objeto MindsetEntry
                      style: const TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) => setState(() => selectedMantra = value),
                  ),
                );
              }),
              const SizedBox(height: 40),
            ],
            Center(
              child: ElevatedButton(
                onPressed: (_displayMantras.isEmpty || selectedMantra != null)
                    ? () => Navigator.pushNamed(context, 'cuestionario_inicial_4')
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Siguiente', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}