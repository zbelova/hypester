import 'package:flutter/material.dart';

class ModelArchPage extends StatefulWidget {
  const ModelArchPage({super.key});

  @override
  State<ModelArchPage> createState() => _ModelArchPageState();
}

class _ModelArchPageState extends State<ModelArchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Model Arch'),
      ),
      body: const Center(
          child:
          Text('Model Arch')
      ),
    );
  }
}
