import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/services/objectives/objectives_service.dart';
import 'package:chat/models/ser_invencible_areas.dart';
import 'package:chat/pages/shared/appbar/scroll_appbar.dart';
import 'package:chat/pages/shared/colores.dart';
import 'package:chat/pages/main_menu/rutinas/objetivos/commitment_page.dart';

class BenefitGoalScreen extends StatefulWidget {
  const BenefitGoalScreen({Key? key}) : super(key: key);

  @override
  State<BenefitGoalScreen> createState() => _BenefitGoalScreenState();
}

class _BenefitGoalScreenState extends State<BenefitGoalScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ObjectivesService get _service =>
      Provider.of<ObjectivesService>(context, listen: false);

  String get _beneficio => _controller.text.trim();
  List<AreaSerInvencible> get _selected => _service.selectedAreas!;

  bool get _canProceed =>
      _beneficio.isNotEmpty && _selected.isNotEmpty;

  void _onNext() {
    if (!_canProceed) return;
    _service.setBeneficio(_beneficio);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CommitmentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const ScrollAppBar(currentStep: 1, totalSteps: 3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Give Your Goal a "Benefit"',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Summarize how achieving this goal will benefit you.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Benefit',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This goal will help me by...',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Grid de áreas con fila centralizada escalonada y cuadrados idénticos
              Column(children: _buildRows()),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canProceed ? _onNext : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return rojoBurdeos;
                    }),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Genera filas con 3-4-3 items, todos los cuadrados del mismo tamaño
  List<Widget> _buildRows() {
    const pattern = [3, 4, 3];
    const double margin = 4.0;
    List<Widget> rows = [];
    int idx = 0;
    for (var count in pattern) {
      final slice = serInvencibleAreas.skip(idx).take(count).toList();
      idx += count;
      rows.add(
        LayoutBuilder(
          builder: (context, constraints) {
            // Basado en la fila con más columnas (4)
            final int maxItems = 4;
            final double totalMargin = maxItems * margin * 2;
            final double squareSize =
                (constraints.maxWidth - totalMargin) / maxItems;

            final items = slice.map((area) {
              final isSelected = _selected.contains(area);
              final codePoint =
                  int.tryParse(area.icono) ?? Icons.help.codePoint;
              final iconData =
                  IconData(codePoint, fontFamily: 'MaterialIcons');

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _service.deselectArea(area);
                    } else {
                      _service.selectArea(area);
                    }
                  });
                },
                child: Container(
                  width: squareSize,
                  height: squareSize,
                  margin: const EdgeInsets.all(margin),
                  decoration: BoxDecoration(
                    color: isSelected ? rojoBurdeos : grisClaro,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconData,
                        size: squareSize * 0.4,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        area.titulo,
                        style: TextStyle(
                          fontSize: squareSize * 0.13,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList();

            return Row(
              mainAxisAlignment: count == 4
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: items,
            );
          },
        ),
      );
    }
    return rows;
  }
}
