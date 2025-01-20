import 'package:flutter/material.dart';

class SettingsTabView extends StatefulWidget {
  const SettingsTabView({super.key});

  @override
  State<SettingsTabView> createState() => _SettingsTabViewState();
}

class _SettingsTabViewState extends State<SettingsTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _sliderValue = 50; // Valor inicial do Slider

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // Duas abas: Configurações e Sobre
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: 'Configurações'),
            Tab(icon: Icon(Icons.info), text: 'Sobre'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Primeira aba: Configurações
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ajustar Volume',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Slider de Volume
                Slider(
                  value: _sliderValue, // Usa a variável de estado
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label:
                      '${_sliderValue.round()}%', // Mostra o valor arredondado
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value; // Atualiza o valor do Slider
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Exibe o volume atual
                Text(
                  'Volume: ${_sliderValue.round()}%', // Exibe o valor atualizado
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          // Segunda aba: Sobre o App
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aplicativo desenvolvido por Luis Henrique Demarco Scatolin.\n\nDesenvolvido em Flutter.\nVersão 1.0.0.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
