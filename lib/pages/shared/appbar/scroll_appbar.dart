import 'package:flutter/material.dart';

class ScrollAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final int totalSteps;
  
  @override
  final Size preferredSize;

  const ScrollAppBar({
    super.key, 
    required this.currentStep,
    required this.totalSteps,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalSteps, (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 40,
          height: 1,
          color: index <= currentStep ? Colors.white : Colors.grey[800],
        )),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ],
    );
  }
}