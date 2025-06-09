import 'package:chat/pages/widgets/finishAndUpdateButton.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/challenges/user_challenge_service.dart';
import 'package:chat/services/personalData/personalData_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/models/challenge.dart';
import 'package:chat/models/user_challenge.dart';
import 'package:chat/pages/shared/colores.dart';

class RetoChecklistPage extends StatefulWidget {
  final Challenge reto;
  const RetoChecklistPage({ Key? key, required this.reto }) : super(key: key);

  @override
  _RetoChecklistPageState createState() => _RetoChecklistPageState();
}

class _RetoChecklistPageState extends State<RetoChecklistPage> {
  late UserChallenge _uc;
  late List<ChecklistItem> _items;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      await ucService.getUserChallenges();
      _uc = ucService.items.firstWhere(
        (u) => u.challengeId == widget.reto.id && u.isActive,
        orElse: () => ucService.createUserChallenge(widget.reto) as UserChallenge,
      );
      _items = List<ChecklistItem>.from(_uc.checklist ?? []);
      setState(() => _loading = false);
    });
  }

  Future<void> _toggleItem(int index, bool? val) async {
    final newVal = val ?? false;
    final updatedItem = ChecklistItem(
      check: _items[index].check,
      complete: newVal,
    );
    setState(() {
      _items[index] = updatedItem;
    });
    final data = _items.map((e) => e.toJson()).toList();
    try {
      final updated = await Provider.of<UserChallengeService>(context, listen: false)
          .updateUserChallenge(_uc.id, {'checklist': data});
      setState(() {
        _uc = updated;
        _items = List<ChecklistItem>.from(updated.checklist ?? []);
      });
    } catch (e) {
      setState(() {
        _items[index] = ChecklistItem(
          check: updatedItem.check,
          complete: !newVal,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error guardando checkbox: \$e')),
      );
    }
  }

  Future<void> _finishChallenge() async {
    try {
      // Contar ítems marcados
      final count = _items.where((e) => e.complete).length;
      final authService = Provider.of<AuthService>(context, listen: false);
      final personalDataSvc = Provider.of<PersonalDataService>(context, listen: false);
      final ucService = Provider.of<UserChallengeService>(context, listen: false);
      // 1) Actualizar contadores personales según periodo
      await personalDataSvc.completeChallenge(
        authService.usuario!.uid,
        widget.reto.timePeriod,
      );
      // 2) Registrar count en UserChallenge
      await ucService.finishToday(_uc.id, count);
      Navigator.pushNamed(
        context,
        'reto_fin',
        arguments: { 'reto': widget.reto, 'resultado': count },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finalizando reto: \$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const currentStep = 1;
    final allComplete = !_loading && _items.isNotEmpty && _items.every((e) => e.complete);
    
    return Scaffold(
      backgroundColor: negroAbsoluto,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: blancoSuave),
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('home', (r) => false),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 40, height: 1,
            color: (i <= currentStep) ? Colors.white : Colors.grey[800],
          )),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: blancoSuave),
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.reto.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      color: blancoSuave,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Marca los siguientes puntos si los has cumplido hoy:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: blancoSuave, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _items.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay elementos en esta lista',
                              style: TextStyle(color: blancoSuave),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, i) {
                              return CheckboxListTile(
                                value: _items[i].complete,
                                onChanged: (val) => _toggleItem(i, val),
                                title: Text(
                                  _items[i].check,
                                  style: const TextStyle(fontSize: 18, color: blancoSuave),
                                ),
                                activeColor: rojoBurdeos,
                                checkColor: blancoSuave,
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  FinishChallengeButton(
                    reto: widget.reto,
                    uc: _uc,
                    // Sólo habilitado si todos los ítems están marcados
                    enabled: allComplete,
                    // El resultado es la cantidad de checks true
                    resultBuilder: () async => _items.where((item) => item.complete).length,
                    label: 'Finalizar por hoy',
                  ),
                ],
              ),
            ),
    );
  }
}
