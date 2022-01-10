import 'package:flutter/material.dart';
import 'package:todo/ui/components/add_icon.dart';

class IncrementButton extends StatelessWidget {
  const IncrementButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Increment',
      child: const AddIcon(),
    );
  }
}
