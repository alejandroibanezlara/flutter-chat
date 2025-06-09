import 'package:chat/models/ser_invencible_areas.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/microlearning.dart';

/// Ruta accesible solo en entorno web para gestión de microlearnings
class MicrolearningAdminPage extends StatefulWidget {
  const MicrolearningAdminPage({super.key});

  @override
  State<MicrolearningAdminPage> createState() => _MicrolearningAdminPageState();
}

class _MicrolearningAdminPageState extends State<MicrolearningAdminPage> {
  final _formKey = GlobalKey<FormState>();

  String titulo = '';
  String textoCorto = '';
  String textoLargo = '';
  String imagen = '';
  AreaSerInvencible? areaSeleccionada;

  @override
  Widget build(BuildContext context) {
    final isWeb = Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.windows ||
        Theme.of(context).platform == TargetPlatform.linux;

    if (!isWeb) {
      return const Scaffold(
        body: Center(child: Text('Esta página solo está disponible en la versión web.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Microlearnings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                onChanged: (val) => setState(() => titulo = val),
                validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Texto corto'),
                onChanged: (val) => setState(() => textoCorto = val),
                validator: (val) => val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Texto largo'),
                maxLines: 4,
                onChanged: (val) => setState(() => textoLargo = val),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ruta de imagen'),
                onChanged: (val) => setState(() => imagen = val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<AreaSerInvencible>(
                decoration: const InputDecoration(labelText: 'Área'),
                value: areaSeleccionada,
                items: serInvencibleAreas.map((area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Text(area.titulo),
                  );
                }).toList(),
                onChanged: (val) => setState(() => areaSeleccionada = val),
                validator: (val) => val == null ? 'Selecciona un área' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevo = MicroLearning(
                      id: 'temp-id',
                      titulo: titulo,
                      textoCorto: textoCorto,
                      textoLargo: textoLargo,
                      icono: areaSeleccionada?.icono,
                      imagen: imagen,
                      vecesSeleccionado: 0,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                      areaInvencibleObj: areaSeleccionada!,
                    );
                    // TODO: enviar a backend vía POST
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Microlearning creado (no enviado aún)')),
                    );
                  }
                },
                child: const Text('Crear Microlearning'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
