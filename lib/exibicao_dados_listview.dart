import 'package:flutter/material.dart';
import 'entrada_dados_input.dart';
import 'settings_page.dart'; // Import da tela de configurações
import 'database_helper.dart'; // Gerenciamento do banco de dados

class EntradaDadosListView extends StatefulWidget {
  const EntradaDadosListView({super.key});

  @override
  State<EntradaDadosListView> createState() => _EntradaDadosListViewState();
}

class _EntradaDadosListViewState extends State<EntradaDadosListView> {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Banco de dados
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas(); // Carregar tarefas do banco de dados
  }

  Future<void> _carregarTarefas() async {
    final tarefas = await _dbHelper.listarTarefas();
    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> _adicionarTarefa(String titulo) async {
    await _dbHelper.inserirTarefa(titulo);
    _carregarTarefas();
  }

  Future<void> _removerTarefa(int id) async {
    await _dbHelper.deletarTarefa(id);
    _carregarTarefas();
  }

  Future<void> _atualizarTarefa(int id, String novoTitulo) async {
    await _dbHelper.atualizarTarefa(id, novoTitulo);
    _carregarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App To-Do List',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsTabView()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.deepPurple[50],
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = _tarefas[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                title: Text(
                  tarefa['titulo'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      onPressed: () => _mostrarDialogoAtualizar(
                          tarefa['id'], tarefa['titulo']),
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: () => _removerTarefa(tarefa['id']),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar para a tela de entrada de dados
          final novaTarefa = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntradaDadosInputs(),
            ),
          );

          // Verificar se a tarefa foi preenchida e adicioná-la
          if (novaTarefa != null &&
              novaTarefa is String &&
              novaTarefa.isNotEmpty) {
            _adicionarTarefa(novaTarefa);
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar nova tarefa',
      ),
    );
  }

  Future<void> _mostrarDialogoAtualizar(int id, String tituloAtual) async {
    String novoTitulo = tituloAtual;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Atualizar Tarefa"),
          content: TextField(
            autofocus: true,
            onChanged: (valor) {
              novoTitulo = valor;
            },
            decoration: InputDecoration(
              labelText: "Novo texto",
              hintText: tituloAtual,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _atualizarTarefa(id, novoTitulo);
                Navigator.of(context).pop();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}
