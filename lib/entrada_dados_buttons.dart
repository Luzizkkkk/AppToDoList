import 'package:flutter/material.dart';

class EntradaDadosButtons extends StatelessWidget {
  final Function(String) onSave;

  const EntradaDadosButtons({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        const novaTarefa =
            "Nova Tarefa Adicionada"; // Placeholder para lógica futura
        if (novaTarefa.isNotEmpty) {
          onSave(novaTarefa);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa adicionada com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campo vazio!')),
          );
        }
      },
      child: const Text('Adicionar Nova Tarefa'),
    );
  }
}
