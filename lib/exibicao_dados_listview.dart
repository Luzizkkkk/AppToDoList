import 'package:flutter/material.dart';
import 'package:flutter_application_1/tela_tarefas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'entrada_dados_input.dart';
import 'settings_page.dart';
import 'database_helper.dart';

class EntradaDadosListView extends StatefulWidget {
  const EntradaDadosListView({super.key});

  @override
  State<EntradaDadosListView> createState() => _EntradaDadosListViewState();
}

class _EntradaDadosListViewState extends State<EntradaDadosListView> {
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

    print(
        "ID do usuário logado: ${usuario.id}"); // ✅ Veja se este ID corresponde ao da tabela tarefas no Supabase

    final tarefas = await _dbHelper.listarTarefas();

    setState(() {
      print("Tarefas do banco: $tarefas");
      _tarefas = tarefas;
    });

    if (tarefas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma tarefa encontrada!')),
      );
    }
  }

  Future<void> _adicionarTarefa(String titulo, String prioridade,
      String categoria, bool notificacao, bool importante) async {
    await _dbHelper.inserirTarefa(
        titulo, prioridade, categoria, notificacao, importante);
    _carregarTarefas();
  }

  Future<void> _removerTarefa(int id) async {
    await _dbHelper.deletarTarefa(id);
    _carregarTarefas();
  }

  Future<void> _atualizarTarefa(
      int id,
      String novoTitulo,
      String novaPrioridade,
      String novaCategoria,
      bool novaNotificacao,
      bool novoImportante) async {
    await _dbHelper.atualizarTarefa(id, novoTitulo, novaPrioridade,
        novaCategoria, novaNotificacao, novoImportante);
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
            icon: const Icon(Icons.list),
            tooltip: 'Minhas Tarefas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaTarefas()),
              );
            },
          ),
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
      body: _tarefas.isEmpty
          ? const Center(child: Text("Nenhuma tarefa adicionada"))
          : ListView.builder(
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
                    title: Text(
                      tarefa['titulo'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prioridade: ${tarefa['prioridade']}'),
                        Text('Categoria: ${tarefa['categoria']}'),
                        tarefa['importante']
                            ? const Text('🔥 Importante!',
                                style: TextStyle(color: Colors.red))
                            : Container(),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          onPressed: () => _mostrarDialogoAtualizar(
                            tarefa['id'],
                            tarefa['titulo'],
                            tarefa['prioridade'],
                            tarefa['categoria'],
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaTarefa = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntradaDadosInputs(),
            ),
          );

          if (novaTarefa != null && novaTarefa is Map<String, dynamic>) {
            _adicionarTarefa(
              novaTarefa['titulo'],
              novaTarefa['prioridade'],
              novaTarefa['categoria'],
              novaTarefa['notificacao'],
              novaTarefa['importante'],
            );
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar nova tarefa',
      ),
    );
  }

  Future<void> _mostrarDialogoAtualizar(
      int id, String tituloAtual, String prioridade, String categoria) async {
    String novoTitulo = tituloAtual;
    String novaPrioridade = prioridade;
    String novaCategoria = categoria;

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
                _atualizarTarefa(id, novoTitulo, novaPrioridade, novaCategoria,
                    false, false);
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
