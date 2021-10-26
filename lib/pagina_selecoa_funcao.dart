import 'package:flutter/material.dart';

class PaginaSelecoaFuncao extends StatefulWidget {

  @override
  State<PaginaSelecoaFuncao> createState() => _PaginaSelecoaFuncaoState();
}

class _PaginaSelecoaFuncaoState extends State<PaginaSelecoaFuncao> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Função Teste'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'XXXXXX',
              style: Theme.of(context).textTheme.headline4,
            ),

          ],
        ),
      ),

    );
  }
}
