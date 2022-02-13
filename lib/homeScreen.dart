import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        margin: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Expanded(
                    child: Card(
                      color: Colors.red,
                      child: Container(alignment: Alignment.center,child: Text("Card 1")),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.yellow,
                      child:Container(alignment: Alignment.center,child: Text("Card 2")),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Expanded(
                    child: Card(
                      color: Colors.green,
                      child: Container(alignment: Alignment.center,child: Text("Card 3")),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.blue,
                      child: Container(alignment: Alignment.center,child: Text("Card 4")),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
