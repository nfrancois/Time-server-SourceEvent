library time_client;

import 'dart:html';

Element _currentTimeElement;

main() {
  _currentTimeElement = document.query('#currentTime');
}

_connectToEventSource(value){
  var source = new EventSource('/time');
  source.on..open.add((e) => print('open'))
           ..error.add((Event e) => print(e))
           ..message.add((MessageEvent me)  => _displayDate(int.parse(me.data)));
}

_displayDate(int millisecondsSinceEpoch){
  Date current = new Date.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  _currentTimeElement.text = current.toString();
}
