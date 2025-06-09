import 'package:chat/pages/main_menu/home_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chat/models/objective.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:provider/provider.dart';

class ObjectiveDetailPage extends StatefulWidget {
  final ObjetivoPersonal objective;
  const ObjectiveDetailPage({Key? key, required this.objective}) : super(key: key);

  @override
  _ObjectiveDetailPageState createState() => _ObjectiveDetailPageState();
}

class _ObjectiveDetailPageState extends State<ObjectiveDetailPage> {
  final DateFormat _dateFmt = DateFormat('dd MMM yyyy');
  late List<Hito> _hitos;
  int _currentStep = 0;


  double get _progressPercent {
    // Calcular progreso basado en fechas de inicio y fin del objetivo
    final start = widget.objective.fechaCreacion; // fecha de inicio del objetivo
    final end = widget.objective.fechaObjetivo;        // fecha fin del objetivo
    final now = DateTime.now();
    if (now.isBefore(start)) return 0.0;
    if (now.isAfter(end)) return 1.0;
    final totalDays = end.difference(start).inDays;
    if (totalDays == 0) return 1.0;
    final elapsedDays = now.difference(start).inDays;
    return elapsedDays / totalDays;
  }

  @override
  void initState() {
    super.initState();
    _hitos = List.from(widget.objective.hitos);
  }

  /// Sincroniza la lista de hitos con el servidor
  Future<void> _updateHitos() async {
    final _objectiveService = Provider.of<ObjectivesService>(context, listen: false);

    try {
      final id = widget.objective.id;
      await _objectiveService.updateObjectiveMilestones(id, _hitos);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error actualizando hitos: $e')),
      );
    }
  }

  void _onStepContinue() {
    setState(() {
      _hitos[_currentStep].completado = true;
      if (_currentStep < _hitos.length - 1) {
        _currentStep++;
      }
    });
    _updateHitos();
  }

    Future<void> _deleteObjective() async {
    final objectiveService = Provider.of<ObjectivesService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final id = widget.objective.id;
      // Llamada al servicio para eliminar el objetivo
      await objectiveService.deleteObjective(id, authService.usuario!.uid);
      // Mostrar confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objetivo borrado correctamente')),
      );
      // Volver atrás en la navegación

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 1)),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al borrar objetivo: $e')),
      );
    }
  }

  Future<void> _addHito() async {
    String title = '';
    DateTime? start;
    DateTime? end;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Añadir hito'),
        content: StatefulBuilder(
          builder: (c, setD) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (v) => setD(() => title = v),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(start == null ? 'Inicio' : _dateFmt.format(start!)),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final pick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: widget.objective.fechaObjetivo,
                      );
                      if (pick != null) setD(() => start = pick);
                    },
                    child: const Text('Elegir'),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(end == null ? 'Fin' : _dateFmt.format(end!)),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final pick = await showDatePicker(
                        context: context,
                        initialDate: start ?? DateTime.now(),
                        firstDate: start ?? DateTime(2020),
                        lastDate: widget.objective.fechaObjetivo,
                      );
                      if (pick != null) setD(() => end = pick);
                    },
                    child: const Text('Elegir'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: rojoBurdeos),
            onPressed: () async {
              if (title.isNotEmpty && start != null && end != null) {
                setState(() {
                  _hitos.add(Hito(
                    titulo: title,
                    fechaInicioHito: start!,
                    fechaFinHito: end!,
                    completado: false,
                  ));
                });
                Navigator.pop(ctx);
                await _updateHitos();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _editHito(int idx) async {
    final original = _hitos[idx];
    String title = original.titulo;
    DateTime start = original.fechaInicioHito;
    DateTime end   = original.fechaFinHito;
    
    final result = await showDialog<Hito>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar hito'),
        content: StatefulBuilder(
          builder: (c, setD) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de título
              TextField(
                controller: TextEditingController(text: title),
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (v) => setD(() => title = v),
              ),
              const SizedBox(height: 12),
              // Selector de fecha inicio
              Row(
                children: [
                  Expanded(
                    child: Text('Inicio: ${_dateFmt.format(start)}'),
                  ),
                  TextButton(
                    child: const Text('Cambiar'),
                    onPressed: () async {
                      final pick = await showDatePicker(
                        context: ctx,
                        initialDate: start,
                        firstDate: DateTime(2020),
                        lastDate: widget.objective.fechaObjetivo,
                      );
                      if (pick != null) setD(() => start = pick);
                    },
                  ),
                ],
              ),
              // Selector de fecha fin
              Row(
                children: [
                  Expanded(
                    child: Text('Fin: ${_dateFmt.format(end)}'),
                  ),
                  TextButton(
                    child: const Text('Cambiar'),
                    onPressed: () async {
                      final pick = await showDatePicker(
                        context: ctx,
                        initialDate: end,
                        firstDate: start,
                        lastDate: widget.objective.fechaObjetivo,
                      );
                      if (pick != null) setD(() => end = pick);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: rojoBurdeos),
            onPressed: title.trim().isEmpty
                ? null
                : () {
                    Navigator.pop(ctx, Hito(
                      titulo: title.trim(),
                      fechaInicioHito: start,
                      fechaFinHito: end,
                      completado: original.completado,
                    ));
                  },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _hitos[idx] = result);
      await _updateHitos();
    }
  }

  void _markObjectiveCompleted() {
    // Aquí iría la lógica para marcar el objetivo completado
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Objetivo marcado como cumplido')),
    );
  }



  @override
  Widget build(BuildContext context) {
    final o = widget.objective;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 1)),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text('Tu objetivo', style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Título del objetivo (completo)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child:                   Card(
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                            o.titulo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  

                  ),
                  // Progreso circular
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: _progressPercent,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation(rojoBurdeos),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flag, size: 32, color: rojoBurdeos),
                            const SizedBox(height: 4),
                            Text(
                              _dateFmt.format(o.fechaObjetivo),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Beneficio
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tu por qué',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 4),
                          Text(o.beneficios ?? '-',
                              style: const TextStyle(fontSize: 16, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Hitos con línea vertical y status
                  Row(
                    children: [
                      const Text('Hitos',
                          style: TextStyle(color: Colors.white70, fontSize: 18)),
                      const Spacer(),
                      if (_hitos.length < 10)
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: _addHito,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._hitos.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final hito = entry.value;
                    final isActive = idx == _currentStep;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Círculo numérico
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (idx == _currentStep) {
                                    hito.completado = !hito.completado;
                                  } else {
                                    _currentStep = idx;
                                  }
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: hito.completado
                                      ? rojoBurdeos
                                      : (isActive
                                          ? Colors.white24
                                          : Colors.transparent),),
                                  color: hito.completado
                                      ? rojoBurdeos
                                      : (isActive
                                          ? Colors.white24
                                          : Colors.transparent),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${idx + 1}',
                                  style: TextStyle(
                                    color: hito.completado
                                        ? Colors.white
                                        : (isActive
                                            ? Colors.white
                                            : Colors.white70),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Texto y fechas con status
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _editHito(idx),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hito.titulo,
                                      style: TextStyle(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.white70,
                                        fontSize: 16,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _dateFmt.format(hito.fechaInicioHito),
                                          style: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 12),
                                        ),
                                        const Text(' → ',
                                            style: TextStyle(
                                                color: Colors.white38,
                                                fontSize: 12)),
                                        Text(
                                          _dateFmt.format(hito.fechaFinHito),
                                          style: const TextStyle(
                                              color: Colors.white38,
                                              fontSize: 12),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          hito.completado
                                              ? 'Completado'
                                              : 'Pendiente',
                                          style: TextStyle(
                                            color: hito.completado
                                                ? rojoBurdeos
                                                : blancoSuave,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Línea vertical hasta siguiente
                        if (idx < _hitos.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 4.0, bottom: 4.0),
                            child: Container(
                              width: 2,
                              height: 24,
                              color: rojoBurdeos,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 24),
                  // Áreas
                  Text('Áreas', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: o.areaSerInvencible.map((a) => Chip(
                      label: Text(a.titulo),
                      backgroundColor: Colors.grey[700],
                      labelStyle: const TextStyle(color: Colors.white),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _markObjectiveCompleted,
                        icon: const Icon(Icons.check_circle_outline, color: blancoSuave),
                        label: const Text('Objetivo cumplido', style: TextStyle(color: blancoSuave),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: rojoBurdeos),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async { 
                          await _deleteObjective(); 
                          },
                        icon: const Icon(Icons.delete_outline, color: blancoSuave),
                        label: const Text('Borrar objetivo', style: TextStyle(color: blancoSuave),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: grisClaro),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botones finales
          ],
        ),
      ),
    );
  }
}
