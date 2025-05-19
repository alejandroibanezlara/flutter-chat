import 'dart:async';

import 'package:chat/pages/main_menu/rutinas/rutinas/crear_actualizar_rutina_page.dart';
import 'package:chat/pages/shared/appbar/scroll_appbar.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';

class NewHabitPage extends StatefulWidget {
  const NewHabitPage({Key? key}) : super(key: key);

  @override
  _NewHabitPageState createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  final TextEditingController _habitController = TextEditingController();
  String _habit = '';

  // Lista de sugerencias de hábito (10 ejemplos)
  final List<String> _habitSuggestions = [
    'ponerme mis zapatillas',
    'respirar profundamente',
    'meditar 5 minutos',
    'leer dos páginas',
    'beber un vaso de agua',
    'escribir en mi diario',
    'estirar durante 2 minutos',
    'hacer 5 flexiones',
    'preparar una merienda saludable',
    'practicar gratitud por 1 minuto',
  ];

  // Genera la frase actualizada
  String get _previewText {
    return 'Voy a ${_habit.isEmpty ? 'RUTINA' : _habit}, TIEMPO/LUGAR para convertirme en EL TIPO DE PERSONA QUE QUIERO SER';
  }

  @override
  void initState() {
    super.initState();
    _habitController.addListener(() {
      setState(() {
        _habit = _habitController.text;
      });
    });
  }

  @override
  void dispose() {
    _habitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(currentStep: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Frase dinámica en la parte superior
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _previewText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            // Input siempre visible (por encima de los ejemplos)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _habitController,
                decoration: const InputDecoration(
                  labelText: 'rutina',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Área de sugerencias desplazable (sin scroll visible)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  // Eliminamos la barra de desplazamiento para que no se vea
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _habitSuggestions.map((suggestion) {
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          suggestion,
                          style: TextStyle(
                            color: _habit == suggestion ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _habit == suggestion,
                        onSelected: (bool selected) {
                          setState(() {
                            _habitController.text = selected ? suggestion : '';
                            _habit = selected ? suggestion : '';
                          });
                        },
                        // Estilo cuando NO está seleccionado
                        avatar: null,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: grisClaro,
                            width: 1,
                          ),
                        ),
                        backgroundColor: grisClaro,
                        // Estilo cuando SÍ está seleccionado
                        selectedColor: rojoBurdeos, // Usa tu color personalizado aquí
                        side: _habit == suggestion 
                            ? BorderSide(
                                color: rojoBurdeos.withValues(alpha:0.3),
                                width: 1,
                              ) 
                            : null,
                        elevation: 0,
                        pressElevation: 0,
                      );

                    }).toList(),
                  ),
                ),
              ),
            ),
            // Botón para avanzar a la siguiente página (seleccionar TIEMPO/LUGAR)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: rojoBurdeos,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                  onPressed: () {
                    if (_habit.isNotEmpty) {
                      // Navegamos a la siguiente página, que en este ejemplo es una pantalla vacía para TIEMPO/LUGAR.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimePlaceSelectionPage(habito: _habit),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor ingresa una rutina.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class TimePlaceSelectionPage extends StatefulWidget {
  final String habito;
  const TimePlaceSelectionPage({Key? key, required this.habito}) : super(key: key);

  @override
  _TimePlaceSelectionPageState createState() => _TimePlaceSelectionPageState();
}

class _TimePlaceSelectionPageState extends State<TimePlaceSelectionPage> {

  String _timePlace = ''; // Valor seleccionado o escrito para tiempo/lugar

  final TextEditingController _timePlaceController = TextEditingController();

  // Lista de 10 ejemplos de cuándo y dónde se puede realizar el hábito
  final List<String> _timePlaceSuggestions = [
    'todos los días a las 8:00 am',
    'cada día al mediodía',
    'después de comer',
    'al despertar',
    'antes de acostarme',
    'al terminar de trabajar',
    'en mi descanso de la tarde',
    'a las 7:00 am en el parque',
    'durante mi hora de almuerzo',
    'los fines de semana por la mañana',
  ];

  // Genera la frase dinámica combinando el hábito y el tiempo/lugar
  String get _previewText {
    final timePlacePart = _timePlace.isEmpty ? 'TIEMPO/LUGAR' : _timePlace;
    return 'Voy a ${widget.habito}, $timePlacePart para convertirme en EL TIPO DE PERSONA QUE QUIERO SER';
  }

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el campo de texto
    _timePlaceController.addListener(() {
      setState(() {
        _timePlace = _timePlaceController.text;
      });
    });
  }

  @override
  void dispose() {
    _timePlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(currentStep: 1),
      body: SafeArea(
        child: Column(
          children: [
            // Frase dinámica que muestra el hábito y el tiempo/lugar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _previewText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            // Instrucciones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '¿En qué momento y lugar quieres llevar a cabo tu rutina?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Inspirate con alguna de las opciones o escribe tu tiempo y lugar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ),
            const SizedBox(height: 16),
            // Campo de texto para ingresar el tiempo/lugar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _timePlaceController,
                decoration: const InputDecoration(
                  labelText: 'tiempo/lugar',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de sugerencias desplazable
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _timePlaceSuggestions.map((suggestion) {
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          suggestion,
                          style: TextStyle(
                            color: _timePlace == suggestion ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _timePlace == suggestion,
                        onSelected: (bool selected) {
                          setState(() {
                            _timePlaceController.text = selected ? suggestion : '';
                            _timePlace = selected ? suggestion : '';
                          });
                        },
                        // Estilo cuando NO está seleccionado
                        avatar: null,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: grisClaro,
                            width: 1,
                          ),
                        ),
                        backgroundColor: grisClaro,
                        // Estilo cuando SÍ está seleccionado
                        selectedColor: rojoBurdeos, // Usa tu color personalizado aquí
                        side: _timePlace == suggestion 
                            ? BorderSide(
                                color: rojoBurdeos.withValues(alpha:0.3),
                                width: 1,
                              ) 
                            : null,
                        elevation: 0,
                        pressElevation: 0,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            // Botón para continuar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: rojoBurdeos,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                  onPressed: () {
                    if (_timePlace.isNotEmpty) {
                      // Navegamos a la siguiente pantalla, enviando el hábito y el tiempo/lugar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonTypeSelectionPage(
                            habito: widget.habito,
                            timePlace: _timePlace,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa un tiempo/lugar.')),
                      );
                    }
                  },
                  child: const Text('Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PersonTypeSelectionPage extends StatefulWidget {
  final String habito;
  final String timePlace;

  const PersonTypeSelectionPage({
    Key? key,
    required this.habito,
    required this.timePlace,
  }) : super(key: key);

  @override
  _PersonTypeSelectionPageState createState() => _PersonTypeSelectionPageState();
}

class _PersonTypeSelectionPageState extends State<PersonTypeSelectionPage> {
  String _personType = '';
  final TextEditingController _personTypeController = TextEditingController();

  // Lista de sugerencias sobre "qué tipo de persona quiero ser"
  final List<String> _personTypeSuggestions = [
    'una persona más activa',
    'una persona más disciplinada',
    'una persona más consciente',
    'alguien con más energía',
    'alguien más positivo',
    'una persona más saludable',
    'una persona más organizada',
    'un mejor ejemplo para mi familia',
    'una persona más creativa',
    'alguien con mayor bienestar mental',
  ];

  // Frase dinámica que combina hábito, tiempo/lugar y tipo de persona
  String get _previewText {
    final persona = _personType.isEmpty ? 'EL TIPO DE PERSONA QUE QUIERO SER' : _personType;
    return 'Voy a ${widget.habito}, ${widget.timePlace} para convertirme en $persona';
  }

  @override
  void initState() {
    super.initState();
    _personTypeController.addListener(() {
      setState(() {
        _personType = _personTypeController.text;
      });
    });
  }

  @override
  void dispose() {
    _personTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(currentStep: 2),
      body: SafeArea(
        child: Column(
          children: [
            // Frase dinámica con hábito, tiempo/lugar y tipo de persona
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _previewText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            // Indicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'El objetivo no es solo completar la acción, sino transformarte en la persona que deseas ser.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Inspirate con alguna de las opciones o escribe tu propia identidad',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de texto para ingresar el tipo de persona
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _personTypeController,
                decoration: const InputDecoration(
                  labelText: 'tipo de persona',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sugerencias (ChoiceChips)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _personTypeSuggestions.map((suggestion) {
                      return ChoiceChip(
                        showCheckmark: false,
                        label: Text(
                          suggestion,
                          style: TextStyle(
                            color: _personType == suggestion ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _personType == suggestion,
                        onSelected: (bool selected) {
                          setState(() {
                            _personTypeController.text = selected ? suggestion : '';
                            _personType = selected ? suggestion : '';
                          });
                        },
                        // Estilo cuando NO está seleccionado
                        avatar: null,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: grisClaro,
                            width: 1,
                          ),
                        ),
                        backgroundColor: grisClaro,
                        // Estilo cuando SÍ está seleccionado
                        selectedColor: rojoBurdeos, // Usa tu color personalizado aquí
                        side: _personType == suggestion 
                            ? BorderSide(
                                color: rojoBurdeos.withValues(alpha:0.3),
                                width: 1,
                              ) 
                            : null,
                        elevation: 0,
                        pressElevation: 0,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Botón final para confirmar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rojoBurdeos,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    if (_personType.isNotEmpty) {
                      // Navegamos a la siguiente pantalla, enviando el hábito y el tiempo/lugar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitSummaryPage(
                            habito: widget.habito,
                            timePlace: widget.timePlace,
                            personType: _personType,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa una razón.')),
                      );
                    }
                  },
                  child: const Text('Finalizar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class HabitSummaryPage extends StatefulWidget {
  final String habito;
  final String timePlace;
  final String personType;

  const HabitSummaryPage({
    Key? key,
    required this.habito,
    required this.timePlace,
    required this.personType,
  }) : super(key: key);

  @override
  State<HabitSummaryPage> createState() => _HabitSummaryPageState();
}

class _HabitSummaryPageState extends State<HabitSummaryPage> {
  // Frase final del nuevo hábito
  String get _finalPhrase {
    return 'Voy a ${widget.habito}, ${widget.timePlace} para convertirme en ${widget.personType}';
  }

  Timer? _pressTimer;
  bool _isPressed = false;
  double _pressProgress = 0.0;

  @override
  void dispose() {
    _pressTimer?.cancel();
    super.dispose();
  }

  void _startPressTimer() {
    setState(() {
      _isPressed = true;
      _pressProgress = 0.0;
    });

    const pressDuration = Duration(seconds: 3);
    const updateInterval = Duration(milliseconds: 50);
    int elapsed = 0;

    _pressTimer = Timer.periodic(updateInterval, (timer) {
      elapsed += updateInterval.inMilliseconds;
      setState(() {
        _pressProgress = elapsed / pressDuration.inMilliseconds;
      });

      if (elapsed >= pressDuration.inMilliseconds) {
        timer.cancel();
        _navigateToNextPage();
      }
    });
  }

  void _cancelPressTimer() {
    _pressTimer?.cancel();
    setState(() {
      _isPressed = false;
      _pressProgress = 0.0;
    });
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepeatSettingsPage(
          finalPhrase: _finalPhrase,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(currentStep: 3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contenedor con la frase (ahora sin interacción)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: rojoBurdeos,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _finalPhrase,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 32),

              // Texto instructivo
              Text(
                'Mantén pulsado para firmar con tu huella tu compromiso',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 16),

              // Círculo con huella para pulsación larga
              Center(
                child: GestureDetector(
                  onTapDown: (_) => _startPressTimer(),
                  onTapUp: (_) => _cancelPressTimer(),
                  onTapCancel: _cancelPressTimer,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: _isPressed ? _pressProgress : 0,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(rojoBurdeos),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: _isPressed 
                              ? rojoBurdeos.withOpacity(0.2) 
                              : Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fingerprint,
                          size: 40,
                          color: _isPressed ? rojoBurdeos : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Texto de progreso
              if (_isPressed)
                Text(
                  '${(_pressProgress * 100).toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: rojoBurdeos,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}