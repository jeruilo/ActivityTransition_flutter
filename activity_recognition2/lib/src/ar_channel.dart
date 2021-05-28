part of activity_recognition; 

class _ActivityChannel {
  // Declaración del stream controller del tipo activity event
  // This controller allows sending data, error and done events on its [stream]. 
  // This class can be used to create a simple stream that others can listen on, and to push events to that stream.
  StreamController<ActivityEvent> _activityStreamController = StreamController<ActivityEvent>();

  // When you listen on a [Stream] using [Stream.listen], a [StreamSubscription] object is returned.
  // The subscription provides events to the listener, and holds the callbacks used to handle the events. 
  // The subscription can also be used to unsubscribe from the events, or to temporarily pause the events from the stream.
  StreamSubscription _activityUpdateStreamSubscription; 

  Stream<ActivityEvent> get activityUpdates => _activityStreamController.stream;

  // Bool para saber si esta activo o no
  bool _runForegroundService; 

  _ActivityChannel( this._runForegroundService ) {
    //Start the foreground service plugin if we are on android and if the option was not toggled off by the programmer.
    if ( Platform.isAndroid && _runForegroundService ) {
      ForegroundService().start();
    }

    _activityStreamController.onListen = startActivityUpdates();
  }


  startActivityUpdates() {
    if ( _activityUpdateStreamSubscription != null ) return; 

    _activityUpdateStreamSubscription = _eventChannel
      .receiveBroadcastStream().listen(_onActivityUpdateReceived);

    _channel.invokeMethod('startActivityUpdates');
  }


  endActivityUpdates() {
    if ( _activityUpdateStreamSubscription != null ) {
      _activityUpdateStreamSubscription.cancel();
      _activityUpdateStreamSubscription = null; 
    }
  }



  _onActivityUpdateReceived( dynamic activity ) {
    debugPrint('onActivityUpdateReceived');
    assert( activity is String );
    var parsedActivity = ActivityEvent.fromJson(json.decode(activity));
    _activityStreamController.add(parsedActivity);
  }


  static MethodChannel _channel = MethodChannel('activity_recognition/activities');

  static EventChannel _eventChannel = EventChannel('activity_recognition/activityUpdates');
}



