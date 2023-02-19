import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_experiment/my_date_time_picker.dart';
import 'package:flutter_datetime_experiment/server_time.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';

// import 'package:timezone/browser.dart';
enum MyDateFormat {
  DATETIME, //'yyyy-MM-dd HH:mm:ss'
  DATE_LONG, //'yyyy-MM-dd'
  DATE_SHORT, //'yMMMMd'
  TIME //'hh:mm:ss'
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  late DateTime dt;

  void _incrementCounter() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fromController.text = ServerDateTime().dt.toString();
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
              onTap: () => _showDialog(
                MyDateTimePicker(
//toServerDateTime(DateTime.parse(fromController.text))
                //ServerDateTime(isConvert: true).toServerDateTime(dt).dt
                  initialDateTime:   ServerDateTime(isConvert: true).toServerDateTime2 (fromController.text).dt,
                  use24hFormat: true,
                  // This is called when the user changes the dateTime.
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      fromController.text = formatDateTimeToStr(
                        dt: newDateTime,
                        fmt: MyDateFormat.DATETIME,
                      );
                    });
                  },
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {

                DateTime dt = DateTime.parse(fromController.text);

                toController.text = "FROM DATETIME:\n";
                toController.text += dt.timeZoneName.toString() + "\n";
                toController.text += "\n\n\n";

                toController.text += "TO DATETIME:\n";
                TZDateTime dt2 =
                    ServerDateTime(isConvert: false).toServerDateTime(dt).dt;
                toController.text += "(False)DT:" + dt2.toString() + "\n";
                toController.text +=
                    "TimeZone:" + timezoneNames2[dt2.timeZone.offset] + "\n";
                toController.text += "\n";

                dt2 = ServerDateTime(isConvert: true).toServerDateTime(dt).dt;
                toController.text += "(True) DT:" + dt2.toString() + "\n";
                toController.text +=
                    "TimeZone:" + timezoneNames2[dt2.timeZone.offset] + "\n";
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

  //This converts DateTime to String
  static String formatDateTimeToStr(
      {required DateTime dt, required MyDateFormat fmt}) {
    DateFormat formatter = resolveFormater(fmt);
    return formatter.format(dt);
  }

  //Based on the format required (enum), DateFormat instance is provided
  static DateFormat resolveFormater(MyDateFormat fmt) {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    switch (fmt) {
      case MyDateFormat.DATETIME:
        formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        break;
      case MyDateFormat.DATE_LONG:
        formatter = DateFormat('yyyy-MM-dd');
        break;
      case MyDateFormat.DATE_SHORT:
        formatter = DateFormat('yMMMMd');
        break;
      case MyDateFormat.TIME:
        formatter = DateFormat('HH:mm:ss');
        break;
    }

    return formatter;
  }

  // This function displays a CupertinoModalPopup with a reasonable fixed height
  // which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}
