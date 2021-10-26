import 'package:flutter/material.dart';

class PaginaCieloEcommerce extends StatefulWidget {
  @override
  State<PaginaCieloEcommerce> createState() => _PaginaCieloEcommerceState();
}

class _PaginaCieloEcommerceState extends State<PaginaCieloEcommerce> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Página Cielo Ecommerce'),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text(
              'You have pushed the button this many times:',
            ),

            Text(
              'xxxxxxx',
              style: Theme.of(context).textTheme.headline4,
            ),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
