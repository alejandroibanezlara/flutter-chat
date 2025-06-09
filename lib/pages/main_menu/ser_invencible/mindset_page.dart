import 'dart:async';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/usuarioData/serInvencibleData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MindsetPage extends StatefulWidget {
  const MindsetPage({Key? key}) : super(key: key);

  @override
  State<MindsetPage> createState() => _MindsetPageState();
}

class _MindsetPageState extends State<MindsetPage>
    with AutomaticKeepAliveClientMixin<MindsetPage>, TickerProviderStateMixin {
  List<String> _mantras = [];
  bool _isLoading = true;
  bool _animationsReady = false;
  int? _pressedIndex;
  List<AnimationController> _controllers = [];
  List<Animation<Color?>> _colorAnimations = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMindset();
  }

Future<void> _loadMindset() async {
  final service = Provider.of<SerInvencibleService>(context, listen: false);
  final authService = Provider.of<AuthService>(context, listen: false);

  try {
    final data = await service.getDataByUserId(authService.usuario!.uid);
    _mantras = data.mindset.map((e) => e.texto).toList();
  } catch (e) {
    _mantras = [];
  }

  _initAnimations();

  setState(() {
    _isLoading = false;
    _animationsReady = true; // ✅ solo cuando están listos
  });
}

  void _initAnimations() {
    _controllers.forEach((c) => c.dispose());
    _controllers = [];
    _colorAnimations = [];

    for (int i = 0; i < _mantras.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );

      final animation = ColorTween(
        begin: Colors.white,
        end: rojoBurdeos,
      ).animate(controller);

      _controllers.add(controller);
      _colorAnimations.add(animation);
    }
  }

  Future<void> _editMantra(int index) async {
    final controller = TextEditingController(text: _mantras[index]);
    final focusNode = FocusNode(); // Se mantiene fuera del StatefulBuilder

    final authService = Provider.of<AuthService>(context, listen: false);
    final service = Provider.of<SerInvencibleService>(context, listen: false);

    final result = await showDialog<String>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Solicita foco solo una vez después de montar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (focusNode.canRequestFocus) {
                focusNode.requestFocus();
              }
            });

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: grisCarbon,
              title: const Text(
                'Editar frase',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLength: 140,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Edita tu declaración...',
                      hintStyle: TextStyle(color: grisClaro),
                      filled: true,
                      fillColor: Colors.black12,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: grisClaro),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: grisClaro),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: rojoBurdeos, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${controller.text.length}/140',
                      style: TextStyle(color: grisClaro, fontSize: 12),
                    ),
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              actions: [
                // Botón principal centrado (Actualizar)
                Center(
                  child: TextButton.icon(
                    onPressed: controller.text.trim().isNotEmpty
                        ? () => Navigator.pop(context, controller.text.trim())
                        : null,
                    icon: Icon(Icons.check_circle_outline,
                        size: 20, color: controller.text.trim().isNotEmpty ? rojoBurdeos : Colors.grey),
                    label: Text(
                      'Actualizar',
                      style: TextStyle(
                        color: controller.text.trim().isNotEmpty ? rojoBurdeos : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Botones secundarios abajo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context, 'cancelar'),
                      icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                      label: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context, 'borrar'),
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                      label: const Text('Borrar', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    if (result == 'cancelar') return;

    if (result == 'borrar') {
      try {
        await service.removeMindsetByText(authService.usuario!.uid, _mantras[index]);
        await _loadMindset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Frase eliminada')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
      return;
    }

    if (result != null && result is String && result.isNotEmpty) {
      try {
        await service.updateMindsetByReplacing(
          authService.usuario!.uid,
          oldText: _mantras[index],
          newText: result,
        );
        await _loadMindset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Frase actualizada')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    }
  }

  Widget _buildMantras() {
    if (_mantras.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            "Añade declaraciones personales.\nPor ejemplo:\n\"Soy capaz de lograr todo lo que me proponga\"",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    if (_isLoading || !_animationsReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: List.generate(_mantras.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _controllers[index],
                builder: (context, child) => Icon(
                  Icons.bolt,
                  color: _colorAnimations[index].value ?? Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (_) {
                    _controllers[index].forward();

                    _controllers[index].addStatusListener((status) {
                      if (status == AnimationStatus.completed) {
                        _editMantra(index);
                        _controllers[index].reset();
                      }
                    });
                  },
                  onLongPressEnd: (_) {
                    _controllers[index].stop();
                    _controllers[index].reset();
                  },
                  child: Text(
                    _mantras[index],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _addMantra() async {
    final TextEditingController controller = TextEditingController();
    final authService = Provider.of<AuthService>(context, listen: false);


    final result = await showDialog<String>(
      context: context,
      builder: (_) {
      final focusNode = FocusNode();

        return StatefulBuilder(
          builder: (context, setState) {
            // Esperar al siguiente frame DENTRO del widget ya montado
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (focusNode.canRequestFocus) {
                focusNode.requestFocus();
              }
            });
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: grisCarbon,
              title: const Text(
                'Añadir mindset',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    focusNode: focusNode,
                    controller: controller,
                    maxLength: 140,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu declaración...',
                      hintStyle: TextStyle(color: grisClaro),
                      filled: true,
                      fillColor: Colors.black12,
                      counterText: '', // Oculta el contador por defecto
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: grisClaro),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: grisClaro),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: rojoBurdeos, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${controller.text.length}/140',
                      style: TextStyle(color: grisClaro, fontSize: 12),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: grisClaro),
                  ),
                ),
                TextButton(
                  onPressed: controller.text.trim().isNotEmpty
                      ? () => Navigator.pop(context, controller.text.trim())
                      : null,
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      color: rojoBurdeos,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      final service = Provider.of<SerInvencibleService>(context, listen: false);

      try {
        await service.updateDataMindset(authService.usuario!.uid, {
          'mindset': [
            {
              'texto': result,
              'status': 'activo',
              'contador': 0,
              'fecha': DateTime.now().toIso8601String(),
            }
          ]
        });
        await _loadMindset();
      } catch (e, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mindset',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_mantras.length <= 10) // 👈 condición aplicada aquí
                  IconButton(
                    onPressed: _addMantra,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [rojoBurdeos, Color.fromARGB(255, 237, 148, 148)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_buildMantras()],
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}