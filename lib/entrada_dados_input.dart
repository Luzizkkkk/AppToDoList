import 'package:flutter/material.dart';
import 'entrada_dados_buttons.dart';

class EntradaDadosInputs extends StatefulWidget {
  const EntradaDadosInputs({super.key});

  @override
  State<EntradaDadosInputs> createState() => _EntradaDadosInputsState();
}

class _EntradaDadosInputsState extends State<EntradaDadosInputs> {
  final TextEditingController _controller = TextEditingController();
  bool _checkboxValue = false;
  bool _switchValue = false;
  String? _selectedCategory;
  String? _prioridadeSelecionada;

  void _salvarTarefa() {
    final novaTarefa = _controller.text.trim();

    if (novaTarefa.isNotEmpty &&
        _prioridadeSelecionada != null &&
        _selectedCategory != null) {
      Navigator.pop(context, {
        'titulo': novaTarefa,
        'prioridade': _prioridadeSelecionada,
        'categoria': _selectedCategory,
        'notificacao': _switchValue,
        'importante': _checkboxValue,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Preencha todos os campos antes de salvar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Descrição da Tarefa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // botao checkbox
              Row(
                children: [
                  Checkbox(
                    value: _checkboxValue,
                    onChanged: (value) {
                      setState(() {
                        _checkboxValue = value!;
                      });
                    },
                  ),
                  const Text('Marcar como importante'),
                ],
              ),

              // botao switch
              Row(
                children: [
                  const Text('Ativar notificação: '),
                  Switch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                ],
              ),

              //botao radio button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Prioridade:'),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Alta',
                        groupValue: _prioridadeSelecionada,
                        onChanged: (value) {
                          setState(() {
                            _prioridadeSelecionada = value;
                          });
                        },
                      ),
                      const Text('Alta'),
                      Radio<String>(
                        value: 'Média',
                        groupValue: _prioridadeSelecionada,
                        onChanged: (value) {
                          setState(() {
                            _prioridadeSelecionada = value;
                          });
                        },
                      ),
                      const Text('Média'),
                      Radio<String>(
                        value: 'Baixa',
                        groupValue: _prioridadeSelecionada,
                        onChanged: (value) {
                          setState(() {
                            _prioridadeSelecionada = value;
                          });
                        },
                      ),
                      const Text('Baixa'),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // botao dropdowm
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categoria (DropdownButton):'),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    hint: const Text('Selecione uma categoria'),
                    items: <String>['Trabalho', 'Pessoal', 'Estudo', 'Outros']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  ),
                ],
              ),

              // salvar tarefaa
              const SizedBox(height: 20),
              EntradaDadosButtons(
                onSave: (String tarefa) {
                  _salvarTarefa();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
