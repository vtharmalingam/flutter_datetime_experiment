import 'package:flutter/material.dart';
import 'package:flutter_datetime_experiment/server_time.dart';
import 'package:timezone/browser.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();


  void _incrementCounter() {
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fromController.text = DateTime.now().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(
              controller: fromController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DateTime',
              ),
            ),


            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {

                DateTime dt = DateTime.parse(fromController.text);

                toController.text += "FROM DATETIME:\n";
                toController.text += dt.timeZoneName.toString() + "\n";
                toController.text += "\n\n\n";

                toController.text += "TO DATETIME:\n";
                TZDateTime dt2 = ServerDateTime(isConvert: false).toServerDateTime(dt).dt;
                toController.text += "(False)DT:" + dt2.toString() + "\n";
                toController.text += "TimeZone:" +  timezoneNames2[dt2.timeZone.offset] + "\n";
                toController.text += "\n";

                dt2 = ServerDateTime(isConvert: true).toServerDateTime(dt).dt;
                toController.text += "(True) DT:" + dt2.toString()+ "\n";
                toController.text += "TimeZone:" +  timezoneNames2[dt2.timeZone.offset] + "\n";

                },
              child: Text('Go'),
            ),


            TextField(
              controller: toController,
              minLines: 6,
              maxLines: 12, //or null
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DateTime (Output)',
              ),
            ),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}