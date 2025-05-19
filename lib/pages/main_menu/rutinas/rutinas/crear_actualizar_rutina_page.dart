import 'package:chat/pages/shared/appbar/scroll_appbar.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/routine.dart';
import 'package:chat/pages/main_menu/home_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/routine/routine_service.dart';
import 'package:provider/provider.dart';

class RepeatSettingsPage extends StatefulWidget {
  final String finalPhrase;
  final Routine? routine; // <-- rutina opcional si estamos editando

  const RepeatSettingsPage({Key? key, required this.finalPhrase, this.routine}) : super(key: key);

  @override
  _RepeatSettingsPageState createState() => _RepeatSettingsPageState();
}


class _RepeatSettingsPageState extends State<RepeatSettingsPage> {
  
  final List<String> _weekDays = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];

int _mapWeekDay(String label) {
  final idx = _weekDays.indexOf(label);
  if (idx == -1) throw Exception('Día no válido: $label');
  return idx == 0 ? 7 : idx;
}

  final Set<String> _selectedDays = {};
  final List<int> _reminderOptions = [0, 5, 10, 15, 25, 30];
  int _selectedReminderMinutes = 0;
  bool _monthlyDayX = false;
  // int? _monthlyDayXValue = 1;
  final Set<int> _monthlySelectedDays = {}; // Reemplaza _monthlyDayXValue
  bool _monthlyFirstMonday = false;
  Set<String> _advancedDays = {};
  Set<int> _advancedWeeks = {};
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _sendReminder = true;
  bool _isLoading = false;
  IconData? _selectedIcon;
  final List<Area> _selectedAreas = [];


  final Map<String, int> _dayToNumber = {
    'D': 7,
    'L': 1,
    'M': 2,
    'X': 3,
    'J': 4,
    'V': 5,
    'S': 6,
  };


  int _mapWeekDayStrict(String label) {
    if (!_dayToNumber.containsKey(label)) {
      throw Exception('Día inválido: $label');
    }
    return _dayToNumber[label]!;
  }

        // instancia del submodelo

  @override
  void initState() {
    super.initState();
    final rutina = widget.routine;
    if (rutina != null) {
      _selectedIcon = rutina.icono != null ? IconData(rutina.icono!, fontFamily: 'MaterialIcons') : null;
      _selectedAreas.addAll(rutina.areas);
      _selectedReminderMinutes = rutina.configNotificacion?.minutosAntes ?? 0;
      _sendReminder = rutina.configNotificacion?.activada ?? true;
      _selectedTime = _parseTime(rutina.horario?.horaInicio) ?? TimeOfDay.now();
      if (rutina.tipo == 'semanal' && rutina.diasSemana != null) {
        for (var i in rutina.diasSemana!) {
          int index = i % 7; // 7 → 0 (domingo), 1–6 → 1–6
          if (index >= 0 && index < _weekDays.length) {
            _selectedDays.add(_weekDays[index]);
          }
        }
      }
      if (rutina.tipo == 'mensual' && rutina.diasMes != null) {
        _monthlyDayX = true;
        _monthlySelectedDays.addAll(rutina.diasMes!);
      }
      if (rutina.tipo == 'personalizada') {
        _monthlyFirstMonday = true;
        if (rutina.semanasMes != null) _advancedWeeks = rutina.semanasMes!.toSet();
        if (rutina.diasSemana != null) {
          for (var i in rutina.diasSemana!) {
            // _advancedDays.add(_weekDays[i]);
            int index = i % 7; // 7 → 0 (domingo), 1–6 → 1–6
            if (index >= 0 && index < _weekDays.length) {
              _advancedDays.add(_weekDays[index]);
            }
          }
        }
      }
    }
  }

  

  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null) return null;
    final parts = timeStr.split(":");
    if (parts.length != 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _getTipoRutina() {
    if (_selectedDays.isNotEmpty) return 'semanal';
    if (_monthlyDayX) return 'mensual';
    if (_advancedDays.isNotEmpty) return 'personalizada';
    return 'personalizada';
  }

  String get _formattedTime => _selectedTime.format(context);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _toggleArea(Area area) {
    setState(() {
      if (_selectedAreas.any((a) => a.titulo == area.titulo)) {
        _selectedAreas.removeWhere((a) => a.titulo == area.titulo);
      } else {
        _selectedAreas.add(area);
      }
    });
  }

  

  Future<void> _submitHabit() async {
    if (_selectedAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos un área')));
      return;
    }

    DateTime? _selectedEndDate;               // fechaFin
    ReglasRepeticion _reglasRepeticion; 

    // Defino primero el tipo
    final tipoRutina = _getTipoRutina();

    final reglas = ReglasRepeticion(
      tipo: tipoRutina,

      // Si es semanal, uso _selectedDays; si es personalizada, uso _advancedDays
      diasSemana: tipoRutina == 'semanal'
          ? _selectedDays.map(_mapWeekDay).toList()
          : tipoRutina == 'personalizada'
              ? _advancedDays.map(_mapWeekDay).toList()
              : null,

      // Para mensual
      diasMes: tipoRutina == 'mensual'
          ? _monthlySelectedDays.toList()
          : null,

      // Para personalizada: asigno las semanas del mes
      semanasMes: tipoRutina == 'personalizada' && _advancedWeeks.isNotEmpty
          ? _advancedWeeks.toList()
          : null,

      fechaFin: _selectedEndDate,
    );

    Future<void> _pickEndDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedEndDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) setState(() => _selectedEndDate = picked);
    }

    setState(() => _isLoading = true);

    try {
      final routineService = Provider.of<RoutineService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);



      final routine = Routine(
        id: widget.routine?.id ?? '',
        title: widget.finalPhrase.split(',')[0].replaceFirst('Voy a ', '').trim(),
        tiempoYlugar: widget.finalPhrase.split(',')[1].trim(),
        tipoPersona: widget.finalPhrase.split('en ')[1].trim(),
        declaracionCompleta: widget.finalPhrase,
        areas: _selectedAreas,
        icono: _selectedIcon?.codePoint,
        tipo: tipoRutina,  // mejor que _getTipoRutina() dos veces
        // diasSemana: tipoRutina == 'semanal'
        //     ? _selectedDays.map(_mapWeekDay).toList()
        //     : tipoRutina == 'personalizada'
        //         ? _advancedDays.map(_mapWeekDay).toList()
        //         : null,
        diasSemana: tipoRutina == 'semanal'
            ? _selectedDays.map(_mapWeekDayStrict).whereType<int>().toList()
            : tipoRutina == 'personalizada'
                ? _advancedDays.map(_mapWeekDayStrict).whereType<int>().toList()
                : null,
        diasMes: tipoRutina == 'mensual'
            ? _monthlySelectedDays.toList()
            : null,
        semanasMes: tipoRutina == 'personalizada'
            ? _advancedWeeks.toList()
            : null,
        // tipo: _getTipoRutina(),
        // diasSemana: _selectedDays.isNotEmpty ? _selectedDays.map((d) => _weekDays.indexOf(d)).toList() : null,
        // diasMes: _monthlyDayX ? _monthlySelectedDays.toList() : null,
        // semanasMes: _advancedWeeks.isNotEmpty ? _advancedWeeks.toList() : null,
        horario: Horario(horaInicio: _formattedTime, duracionMinutos: 30),
        status: 'in-progress',
        configNotificacion: ConfigNotificacion(
          activada: _sendReminder,
          minutosAntes: _selectedReminderMinutes,
          horaExacta: _formattedTime,
        ),
        diasCompletados: widget.routine?.diasCompletados ?? [],
        metadata: Metadata(
          creadoPor: authService.usuario!.uid,
          ultimaModificacion: DateTime.now(),
        ),
        createdAt: widget.routine?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        reglasRepeticion: reglas,
      );

      if (widget.routine != null) {
        await RoutineService.updateRoutine(routine.id, routine.toJson());
      } else {
        await routineService.createRoutine(routine);
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage(initialIndex: 1)),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(currentStep: 4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.finalPhrase,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Áreas
              Text(
                'Áreas',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              AreaIconSelector(
                onAreaSelected: _toggleArea,
                selectedAreas: _selectedAreas,
              ),
              const SizedBox(height: 24),

              // Icono
              Text(
                'Icono',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showIconPicker(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Añadir Icono'),
                  ),
                  if (_selectedIcon != null) ...[
                    const SizedBox(width: 16),
                    Icon(_selectedIcon, size: 40),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Repetición semanal
              Text(
                'Semanal',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _weekDays.map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: ChoiceChip(
                          label: Text(day),
                          selected: isSelected,
                          showCheckmark: false,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedDays.add(day);
                                _monthlyDayX = false;
                                _monthlyFirstMonday = false;
                                _advancedDays.clear();
                                _advancedWeeks.clear();
                              } else {
                                _selectedDays.remove(day);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Repetición mensual
              Text(
                'Mensual',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),


              SwitchListTile(
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    children: [
                      const TextSpan(text: 'Los días '),
                      TextSpan(
                        text: _monthlySelectedDays.isEmpty 
                            ? 'del mes' 
                            : _monthlySelectedDays.map((d) => d.toString()).join(', '),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' de cada mes'),
                    ],
                  ),
                ),
                value: _monthlyDayX,
                onChanged: (value) {
                  setState(() {
                    _monthlyDayX = value;
                    if (value) {
                      _selectedDays.clear();
                      _monthlyFirstMonday = false;
                      _advancedDays.clear();
                      _advancedWeeks.clear();
                    } else {
                      _monthlySelectedDays.clear();
                    }
                  });
                },
              ),
              if (_monthlyDayX)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selecciona hasta 10 días del mes:'),
                      const SizedBox(height: 8),
                      
                      // Fila 1: Días 1-7
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) => _buildDaySquare(index + 1)),
                      ),
                      const SizedBox(height: 8),
                      
                      // Fila 2: Días 8-14
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) => _buildDaySquare(index + 8)),
                      ),
                      const SizedBox(height: 8),
                      
                      // Fila 3: Días 15-21
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) => _buildDaySquare(index + 15)),
                      ),
                      const SizedBox(height: 8),
                      
                      // Fila 4: Días 22-28
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) => _buildDaySquare(index + 22)),
                      ),
                      const SizedBox(height: 8),
                      
                      // Fila 5: Días 29-31
                      Row(
                        children: [
                          _buildDaySquare(29),
                          const Spacer(),
                          _buildDaySquare(30),
                          const Spacer(),
                          _buildDaySquare(31),
                        ],
                      ),
                      
                      if (_monthlySelectedDays.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Días seleccionados: ${_monthlySelectedDays.length}/10',
                            style: TextStyle(
                              color: _monthlySelectedDays.length >= 10 
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),



              const SizedBox(height: 24),

              // Opciones avanzadas
Text(
  'Opciones avanzadas',
  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
),
SwitchListTile(
  title: RichText(
    text: TextSpan(
      style: const TextStyle(fontSize: 16, color: Colors.white),
      children: [
        const TextSpan(text: 'El '),
        TextSpan(
          text: _advancedDays.isEmpty ? 'día' : _advancedDays.join(', '),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const TextSpan(text: ' de la(s) semana(s) '),
        TextSpan(
          text: _advancedWeeks.isEmpty
              ? '—'
              : _advancedWeeks.map((e) => e.toString()).join(', '),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const TextSpan(text: ' del mes'),
      ],
    ),
  ),
  value: _monthlyFirstMonday,  // tú lo llamas así
  onChanged: (value) {
    setState(() {
      _monthlyFirstMonday = value;
      if (value) {
        _selectedDays.clear();
        _monthlyDayX = false;
      } else {
        _advancedDays.clear();
        _advancedWeeks.clear();
      }
    });
  },
),
if (_monthlyFirstMonday) ...[
  // 1) Selección de días de la semana
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Text('Selecciona el/los día(s) de la semana:'),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 4,
      children: _weekDays.map((label) {
        final isSelected = _advancedDays.contains(label);
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (sel) {
            setState(() {
              if (sel) {
                _advancedDays.add(label);
                _selectedDays.clear();
                _monthlyDayX = false;
              } else {
                _advancedDays.remove(label);
              }
            });
          },
        );
      }).toList(),
    ),
  ),
  const SizedBox(height: 12),

  // 2) **Nueva sección**: Selección de semanas del mes
  const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Text('Selecciona la(s) semana(s) del mes:'),
  ),
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Wrap(
      spacing: 8,
      runSpacing: 4,
      children: List.generate(5, (index) => index + 1).map((sem) {
        final isWeekSelected = _advancedWeeks.contains(sem);
        return ChoiceChip(
          label: Text('Semana $sem'),
          selected: isWeekSelected,
          onSelected: (sel) {
            setState(() {
              if (sel) {
                _advancedWeeks.add(sem);
                _selectedDays.clear();
                _monthlyDayX = false;
              } else {
                _advancedWeeks.remove(sem);
              }
            });
          },
        );
      }).toList(),
    ),
  ),
  const SizedBox(height: 12),
],
              const SizedBox(height: 24),

              // Hora
              Row(
                children: [
                  const Text('A las...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text(_formattedTime, style: const TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: _pickTime,
                    child: const Text('Cambiar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notificación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notificación', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _sendReminder,
                    onChanged: (value) => setState(() => _sendReminder = value),
                    activeColor: rojoBurdeos.withValues(alpha: 0.6),
                     activeTrackColor: rojoBurdeos, // Color de la pista cuando está activo
                    inactiveThumbColor: grisClaro, // Color del botón cuando está inactivo
                    inactiveTrackColor: grisCarbon, // Color de la pista cuando está inactivo
                  ),
                ],
              ),
              if (_sendReminder) ...[
                const SizedBox(height: 8),
                const Text('¿Cuánto antes quieres que te avisemos?'),
                const SizedBox(height: 4),
                DropdownButton<int>(
                  value: _selectedReminderMinutes,
                  items: _reminderOptions.map((minutos) {
                    return DropdownMenuItem<int>(
                      value: minutos,
                      child: Text(
                        minutos == 0 ? 'A la hora de la rutina' : '$minutos minutos antes',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedReminderMinutes = value;
                      });
                    }
                  },
                ),
              ],
              const SizedBox(height: 24),

              // Botón principal: Crear o Modificar rutina
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitHabit,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(widget.routine != null ? 'Modificar rutina' : 'Crear rutina'),
                ),
              ),

              // Botón de eliminación solo si es una rutina existente
              if (widget.routine != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('¿Estás seguro?'),
                          content: const Text('Esta acción desactivará la rutina.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await RoutineService.deleteRoutine(widget.routine!.id);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const HomePage(initialIndex: 1)),
                            (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Eliminar rutina', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],

            ],
          ),
        ),
      ),
    );
  }

  void _showIconPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 350,
            height: 500,
            child: DefaultTabController(
              length: categorizedIcons.keys.length,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selecciona un icono',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: categorizedIcons.keys.map((category) => Tab(text: category)).toList(),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      children: categorizedIcons.values.map((iconList) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                            itemCount: iconList.length,
                            itemBuilder: (context, index) {
                              final icon = iconList[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedIcon = icon);
                                  Navigator.of(context).pop();
                                },
                                child: Icon(icon, size: 28),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Método auxiliar para construir cada cuadrado de día
Widget _buildDaySquare(int day) {
  final isSelected = _monthlySelectedDays.contains(day);
  final screenWidth = MediaQuery.of(context).size.width;
  final squareSize = (screenWidth - 32 - 48) / 7; // 32 de padding, 48 de spacing (6 espacios de 8)
  
  return GestureDetector(
    onTap: () {
      setState(() {
        if (isSelected) {
          _monthlySelectedDays.remove(day);
        } else {
          if (_monthlySelectedDays.length < 10) {
            _monthlySelectedDays.add(day);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Máximo 10 días seleccionados')),
            );
          }
        }
      });
    },
    child: Container(
      width: squareSize,
      height: squareSize,
      decoration: BoxDecoration(
        color: isSelected ? rojoBurdeos : grisClaro,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
}

final Map<String, List<IconData>> categorizedIcons = {
  'Actividades': [
    Icons.work, Icons.phone, Icons.shopping_cart, Icons.anchor, Icons.backpack,
    Icons.flight, Icons.code, Icons.sports_esports, Icons.headphones, Icons.edit,
    Icons.hiking, Icons.music_note, Icons.map, Icons.school, Icons.home, Icons.calendar_today,
    Icons.people, Icons.brush, Icons.book, Icons.healing, Icons.lightbulb, Icons.piano,
  ],
  'Deportes': [
    Icons.directions_run, Icons.directions_bike, Icons.fitness_center, Icons.pool,
    Icons.sports_basketball, Icons.sports_soccer, Icons.sports_tennis, Icons.sports_handball,
    Icons.sports_volleyball, Icons.sports_kabaddi, Icons.sports_mma, Icons.rowing,
  ],
  'Comida y bebida': [
    Icons.local_pizza, Icons.fastfood, Icons.local_cafe, Icons.icecream, Icons.local_dining,
    Icons.ramen_dining, Icons.local_bar, Icons.emoji_food_beverage, Icons.cake,
    Icons.lunch_dining, Icons.dinner_dining, Icons.set_meal, Icons.breakfast_dining,
  ],
  'Arte': [
    Icons.photo, Icons.brush, Icons.palette, Icons.camera_alt, Icons.mic, Icons.movie,
    Icons.music_note, Icons.queue_music, Icons.audiotrack, Icons.theaters, Icons.piano,
    Icons.style, Icons.draw, Icons.color_lens,
  ],
  'Finanzas': [
    Icons.account_balance_wallet, Icons.attach_money, Icons.euro, Icons.currency_bitcoin,
    Icons.monetization_on, Icons.payments, Icons.money_off, Icons.trending_up,
    Icons.pie_chart, Icons.bar_chart,
  ],
  'Otros': [
    Icons.alarm, Icons.sentiment_satisfied, Icons.sentiment_dissatisfied, Icons.error,
    Icons.info, Icons.warning, Icons.check_circle, Icons.delete, Icons.settings,
    Icons.wifi, Icons.security, Icons.nightlight, Icons.wb_sunny, Icons.language,
    Icons.visibility, Icons.cloud, Icons.public, Icons.star, Icons.favorite,
    Icons.facebook, Icons.snapchat, Icons.tiktok,
    Icons.flutter_dash, Icons.send,
  ],
};

class AreaIconSelector extends StatelessWidget {
  final Function(Area) onAreaSelected;
  final List<Area> selectedAreas;

  const AreaIconSelector({
    Key? key,
    required this.onAreaSelected,
    required this.selectedAreas,
  }) : super(key: key);

  // Lista de áreas válidas con sus íconos correspondientes
  static final List<Area> validAreas = [
    Area(titulo: 'Empatía y Solidaridad', icono: Icons.group.codePoint.toString()),
    Area(titulo: 'Carisma', icono: Icons.face.codePoint.toString()),
    Area(titulo: 'Disciplina', icono: Icons.check.codePoint.toString()),
    Area(titulo: 'Organización', icono: Icons.assignment.codePoint.toString()),
    Area(titulo: 'Adaptabilidad', icono: Icons.autorenew.codePoint.toString()),
    Area(titulo: 'Imagen pulida', icono: Icons.image.codePoint.toString()),
    Area(titulo: 'Visión estratégica', icono: Icons.visibility.codePoint.toString()),
    Area(titulo: 'Educación financiera', icono: Icons.money.codePoint.toString()),
    Area(titulo: 'Actitud de superación', icono: Icons.trending_up.codePoint.toString()),
    Area(titulo: 'Comunicación asertiva', icono: Icons.chat.codePoint.toString()),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: validAreas.map((area) {
        final isSelected = selectedAreas.any((a) => a.titulo == area.titulo);
        return FilterChip(
          label: Text(area.titulo),
          selected: isSelected,
          onSelected: (selected) => onAreaSelected(area),
          avatar: Icon(IconData(int.parse(area.icono), fontFamily: 'MaterialIcons'),
          color: Theme.of(context).primaryColor,
          // checkmarkColor: Colors.white,
        ));
      }).toList(),
    );
  }

  
}