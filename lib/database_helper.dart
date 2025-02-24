import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseHelper {
  final SupabaseClient _client = Supabase.instance.client;

  //inserir tarefa
  Future<void> inserirTarefa(String titulo, String prioridade, String categoria,
      bool notificacao, bool importante) async {
    await _client.from('tarefas').insert({
      'titulo': titulo,
      'prioridade': prioridade,
      'categoria': categoria,
      'notificacao': notificacao,
      'importante': importante,
    });
  }

  //listar tarefas
  Future<List<Map<String, dynamic>>> listarTarefas() async {
    return await _client.from('tarefas').select();
  }

  // atualiazr tarefas
  Future<void> atualizarTarefa(int id, String novoTitulo, String novaPrioridade,
      String novaCategoria, bool novaNotificacao, bool novoImportante) async {
    await _client.from('tarefas').update({
      'titulo': novoTitulo,
      'prioridade': novaPrioridade,
      'categoria': novaCategoria,
      'notificacao': novaNotificacao,
      'importante': novoImportante,
    }).eq('id', id);
  }

  //deletar tarefa
  Future<void> deletarTarefa(int id) async {
    await _client.from('tarefas').delete().eq('id', id);
  }
}
