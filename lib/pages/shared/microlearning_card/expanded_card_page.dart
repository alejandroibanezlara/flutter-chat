import 'package:chat/pages/shared/colores.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:chat/services/usuarioData/serInvencibleData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/microlearning.dart';
import 'package:chat/services/personalData/microlearning_service.dart';
import 'package:chat/services/auth_service.dart';

/// ExpandableStoryCard: tarjeta vertical que se expande al pulsarla.
class ExpandableStoryCard extends StatelessWidget {
  final MicroLearning micro;
  final String titulo;
  final Widget collapsedContent;
  final String expandedText;
  final String? areaTitulo;
  final String? areaIconoCodePoint;
  static const double _phi = 1.618;
  final double collapsedWidth;

  const ExpandableStoryCard({
    Key? key,
    required this.micro,
    required this.titulo,
    required this.collapsedContent,
    required this.expandedText,
    this.areaTitulo,
    this.areaIconoCodePoint,
    this.collapsedWidth = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = collapsedWidth;
    final height = collapsedWidth * _phi;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragEnd: (details) {
                final velocity = details.primaryVelocity ?? 0;
                if (velocity.abs() > 300) {
                  Navigator.of(context).pop();
                }
              },
              child: Scaffold(
                backgroundColor: Colors.black,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(color: rojoBurdeos, thickness: 1.5),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Text(
                              expandedText,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (areaTitulo != null && areaIconoCodePoint != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    IconData(int.parse(areaIconoCodePoint!), fontFamily: 'MaterialIcons'),
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    areaTitulo!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              Consumer<SerInvencibleService>(
                                builder: (context, serService, _) {
                                  final auth = Provider.of<AuthService>(context, listen: false);
                                  final uid = auth.usuario!.uid;
                                  final isGuardado = serService.data?.library.any((ml) => ml.id == micro.id) ?? false;

                                  return IconButton(
                                    icon: Icon(
                                      isGuardado ? Icons.bookmark_remove : Icons.bookmark_add,
                                      color: isGuardado ? Colors.white70 : rojoBurdeos,
                                    ),
                                    onPressed: () async {
                                      try {
                                        if (isGuardado) {
                                          await serService.removeLibraryItem(uid, micro.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Microlearning eliminado de tu biblioteca.')),
                                          );
                                        } else {
                                          await serService.addLibraryItem(uid, micro.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Microlearning guardado en tu biblioteca.')),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: collapsedContent,
        ),
      ),
    );
  }
}
