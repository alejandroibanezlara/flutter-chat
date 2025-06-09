import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/models/personal_data.dart';
import 'package:chat/pages/shared/colores.dart';

class InitialQuestionnairePage extends StatefulWidget {
  const InitialQuestionnairePage({Key? key}) : super(key: key);

  @override
  _InitialQuestionnairePageState createState() => _InitialQuestionnairePageState();
}

enum QuestionType { time, singleChoice }

class _Question {
  final String text;
  final QuestionType type;
  final List<String>? options;
  _Question({required this.text, required this.type, this.options});
}

class _InitialQuestionnairePageState extends State<InitialQuestionnairePage> {
  // Preguntas
  late final List<_Question> _questions = [
    _Question(text: '¿A qué hora inicias el día?', type: QuestionType.time),
    _Question(text: '¿A qué hora finalizas tu jornada?', type: QuestionType.time),
    _Question(text: '¿A qué hora del día te sientes con más energía?', type: QuestionType.time),
    _Question(text: '¿Tienes una rutina diaria establecida?', type: QuestionType.singleChoice, options: ['Sí', 'No']),
    _Question(text: '¿Sueles practicar algún deporte o actividad física?', type: QuestionType.singleChoice, options: ['Sí', 'No']),
    _Question(text: '¿Cuál es tu género?', type: QuestionType.singleChoice, options: ['Hombre', 'Mujer', 'Prefiero no decirlo']),
    _Question(text: '¿Cuánto tiempo tienes al día para reflexionar o pensar en ti?', type: QuestionType.singleChoice, options: ['15 mins', '30 mins', 'más de 1h']),
    _Question(text: '¿Cómo prefieres aprender cosas nuevas?', type: QuestionType.singleChoice, options: ['Leyendo', 'Escuchando', 'Viendo vídeos']),
    _Question(text: '¿Cuál es tu nivel de disciplina personal?', type: QuestionType.singleChoice, options: ['Alta', 'Media', 'Baja']),
    _Question(text: '¿Qué tan satisfecho estás con tu situación actual?', type: QuestionType.singleChoice, options: ['Muy satisfecho', 'Algo satisfecho', 'Poco satisfecho']),
  ];

  // Respuestas
  final List<int?> _timeHour = List.filled(3, null);
  final List<int?> _timeMinute = List.filled(3, null);
  final List<int?> _choiceAnswers = List.filled(7, null);

  bool _isLoading = true;
  PersonalData? _pd;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = Provider.of<AuthService>(context, listen: false).usuario!.uid;
    final pd = await Provider.of<PersonalDataService>(context, listen: false)
        .getPersonalDataByUserId(userId);
    if (pd.preguntasInicialesRespondidas) {
      // Inicializar horas
      final inicio = pd.inicioDia;
      final fin    = pd.finJornada;
      final pico   = pd.picoEnergia;
      if (inicio != null) {
        _timeHour[0]   = inicio.hour;
        _timeMinute[0] = (inicio.minute ~/ 15) * 15;
      }
      if (fin != null) {
        _timeHour[1]   = fin.hour;
        _timeMinute[1] = (fin.minute ~/ 15) * 15;
      }
      if (pico != null) {
        _timeHour[2]   = pico.hour;
        _timeMinute[2] = (pico.minute ~/ 15) * 15;
      }
      // Inicializar choices
      final List<String> opts = [];
      // Mapear cada choice
      _choiceAnswers[0] = (pd.rutinaDiaria ?? false) ? 0 : 1;
      _choiceAnswers[1] = (pd.actividadFisica ?? false) ? 0 : 1;
      _choiceAnswers[2] = _questions[5].options!.indexOf(pd.genero ?? '');
      _choiceAnswers[3] = _questions[6].options!.indexOf(pd.tiempoReflexion ?? '');
      _choiceAnswers[4] = _questions[7].options!.indexOf(pd.prefAprendizaje ?? '');
      _choiceAnswers[5] = _questions[8].options!.indexOf(pd.nivelDisciplina ?? '');
      _choiceAnswers[6] = _questions[9].options!.indexOf(pd.satisfaccionActual ?? '');
    }
    setState(() {
      _pd = pd;
      _isLoading = false;
    });
  }

  bool get _allAnswered {
    final timesOk = List.generate(3, (i) => _timeHour[i] != null && _timeMinute[i] != null)
        .every((ok) => ok);
    final choicesOk = _choiceAnswers.every((c) => c != null && c! >= 0);
    return timesOk && choicesOk;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: negroAbsoluto,
        title: const Text('Cuestionario Inicial', style: TextStyle(color: blancoSuave)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Responde las siguientes preguntas:',
                textAlign: TextAlign.center,
                style: TextStyle(color: blancoSuave, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'La información solo se utilizará para personalizar y recomendarte mejores retos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 24),
                  itemBuilder: (context, i) {
                    final q = _questions[i];
                    if (q.type == QuestionType.time) {
                      final h = _timeHour[i];
                      final m = _timeMinute[i];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.text, style: const TextStyle(color: blancoSuave, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Hora',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.grey[900],
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  dropdownColor: Colors.grey[900],
                                  style: const TextStyle(color: Colors.white),
                                  items: List.generate(24, (h) => h).map((hour) => DropdownMenuItem(
                                    value: hour,
                                    child: Text(hour.toString().padLeft(2, '0')),
                                  )).toList(),
                                  value: h,
                                  onChanged: (val) => setState(() => _timeHour[i] = val),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Minutos',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.grey[900],
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  dropdownColor: Colors.grey[900],
                                  style: const TextStyle(color: Colors.white),
                                  items: [0, 15, 30, 45].map((min) => DropdownMenuItem(
                                    value: min,
                                    child: Text(min.toString().padLeft(2, '0')),
                                  )).toList(),
                                  value: m,
                                  onChanged: (val) => setState(() => _timeMinute[i] = val),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      final indexChoice = i - 3;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.text, style: const TextStyle(color: blancoSuave, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(q.options!.length, (ai) {
                              final selected = _choiceAnswers[indexChoice] == ai;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: ElevatedButton(
                                    onPressed: () => setState(() => _choiceAnswers[indexChoice] = ai),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selected ? rojoBurdeos : grisClaro,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child: Text(
                                      q.options![ai],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: blancoSuave, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _allAnswered ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoBurdeos,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _pd!.preguntasInicialesRespondidas ? 'Actualizar respuestas' : 'Guardar respuestas',
                  style: const TextStyle(color: blancoSuave, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final userId = Provider.of<AuthService>(context, listen: false).usuario!.uid;
    final service = Provider.of<PersonalDataService>(context, listen: false);

    final today = DateTime.now();
    DateTime buildDate(int i) => DateTime(today.year, today.month, today.day, _timeHour[i]!, _timeMinute[i]!);

    final payload = {
      'inicioDia': buildDate(0).toUtc().toIso8601String(),
      'finJornada': buildDate(1).toUtc().toIso8601String(),
      'picoEnergia': buildDate(2).toUtc().toIso8601String(),
      'rutinaDiaria': _choiceAnswers[0] == 0,
      'actividadFisica': _choiceAnswers[1] == 0,
      'genero': _questions[5].options![_choiceAnswers[2]!],
      'tiempoReflexion': _questions[6].options![_choiceAnswers[3]!],
      'prefAprendizaje': _questions[7].options![_choiceAnswers[4]!],
      'nivelDisciplina': _questions[8].options![_choiceAnswers[5]!],
      'satisfaccionActual': _questions[9].options![_choiceAnswers[6]!],
      'preguntasInicialesRespondidas': true,
      'fechaCuestionarioInicial': DateTime.now().toUtc().toIso8601String(),
    };

    await service.updatePersonalDataByUserId(userId, payload);
    Navigator.pop(context);
  }
}
