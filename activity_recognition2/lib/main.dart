import 'package:flutter/material.dart';
import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


void main() => runApp( new activityTransition());

class activityTransition extends StatefulWidget {
  @override
  _activityTransitionState createState() => _activityTransitionState();
}


class _activityTransitionState extends State<activityTransition> {
  
  Stream<ActivityEvent> activityStream; 
  ActivityEvent latestActivity = ActivityEvent.empty();
  List<ActivityEvent> _events = [];
  
  
  @override
  void initState() { 
    super.initState();
    _init();
  }


  // Método interno para confirmar el permiso a activityRecognition y encender el stream.listen
  void _init() async {
    if ( await Permission.activityRecognition.request().isGranted) {
      activityStream = ActivityRecognition.activityStream(runForegroundService: true);
      activityStream.listen(onData);
    }
  }
  // Método para almacenar los eventos en la lista<activityEvent> declarada al inicio del script
  void onData( ActivityEvent activityEvent ) {
    print(activityEvent.toString());
    setState(() {
      _events.add( activityEvent );
      latestActivity = activityEvent;
    });
  }


  @override
  Widget build( BuildContext context ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Activity Transition Recognition App'),
          backgroundColor: Colors.green[400],
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _events.length,
            reverse: true,
            itemBuilder: (BuildContext context, int idx) {
              final entry = _events[idx];
              return ListTile(
                leading : Text(entry.timeStamp.toString().substring(0,19)),
                trailing: Text(entry.type.toString().split('.').last),
              );
            },
          ),),
      )
    );
  }


}