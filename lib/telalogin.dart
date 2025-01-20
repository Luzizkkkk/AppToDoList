import 'package:flutter/material.dart';
import 'exibicao_dados_listview.dart'; // Import da home

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final String _emailCorreto = "luis@gmail.com";
  final String _senhaCorreta = "1234";

  void _fazerLogin() {
    String email = _emailController.text.trim();
    String senha = _senhaController.text.trim();

    if (email == _emailCorreto && senha == _senhaCorreta) {
      // Navega para a home ao fazer login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EntradaDadosListView(),
        ),
      );
    } else {
      // Exibe mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("E-mail ou senha incorretos!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone principal com a imagem
              const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/todolist.png'), // Caminho da imagem
              ),
              const SizedBox(height: 40),

              // Campo de e-mail
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Campo de senha
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botão de Login
              ElevatedButton(
                onPressed: _fazerLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
