import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SettingsTabView extends StatefulWidget {
  const SettingsTabView({super.key});

  @override
  State<SettingsTabView> createState() => _SettingsTabViewState();
}

class _SettingsTabViewState extends State<SettingsTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _sliderValue = 50;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      final fileName = 'imagem_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storagePath = 'uploads/$fileName';

      //upload no supabase da imagem
      final uploadResponse = await Supabase.instance.client.storage
          .from('uploads')
          .upload(storagePath, file,
              fileOptions: const FileOptions(upsert: true));

      if (uploadResponse.error == null) {
        final publicUrl = Supabase.instance.client.storage
            .from('uploads')
            .getPublicUrl(storagePath);

        setState(() {
          _imageUrl = publicUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload concluído!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar imagem')),
        );
      }
    }
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
          //aba das configuracoes
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

                //volumeeee
                Slider(
                  value: _sliderValue,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${_sliderValue.round()}%',
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),
                const SizedBox(height: 20),

                Text(
                  'Volume: ${_sliderValue.round()}%',
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),

                //imagem do perfil
                _imageUrl != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_imageUrl!),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person, size: 50),
                      ),

                const SizedBox(height: 10),

                //botao pra colocar imagem
                ElevatedButton(
                  onPressed: _pickAndUploadImage,
                  child: const Text('Alterar Foto de Perfil'),
                ),
              ],
            ),
          ),

          //aba SOBRE
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

extension on String {
  get error => null;
}
