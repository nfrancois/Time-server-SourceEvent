library time_client;

import 'dart:html';

Element _currentTimeElement;

main() {
  _currentTimeElement = document.query('#currentTime');
  _connectToEventSource();
}

_connectToEventSource(){
  var source = new EventSource('/time');
  source..onError.listen((Event e) => print("Error:$e"))
        ..onOpen.listen((Event e) => print('open'))
        ..onMessage.listen((MessageEvent me)  => _displayDate(int.parse(me.data)));
}

_displayDate(int millisecondsSinceEpoch){
  DateTime current = new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  _currentTimeElement.text = current.toString();
}
