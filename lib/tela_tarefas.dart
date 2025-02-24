import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'database_helper.dart';

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    final usuario = Supabase.instance.client.auth.currentUser;

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Usuário não autenticado! Faça login novamente.')),
      );
      return;
    }

    final tarefas = await _dbHelper.listarTarefas();

    setState(() {
      _tarefas = tarefas;
    });

    if (tarefas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma tarefa encontrada!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
      ),
      body: _tarefas.isEmpty
          ? const Center(child: Text("Nenhuma tarefa adicionada"))
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(tarefa['titulo']),
                    subtitle: Text(
                        'Prioridade: ${tarefa['prioridade']} • Categoria: ${tarefa['categoria']}'),
                  ),
                );
              },
            ),
    );
  }
}
