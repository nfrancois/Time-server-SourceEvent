library time_client;

import 'dart:html';
//#import('/home/nicolas/dart/dart-sdk/lib/i18n/date_format.dart');

Element _currentTimeElement; 

main() {
  _currentTimeElement = document.query('#currentTime');
  var source = new EventSource('/time');
  source.on.open.add((e) => print('open'));
  source.on.error.add((Event e) => print(e));
  source.on.message.add((MessageEvent me)  => showDate(int.parse(me.data)));
  
  _currentTimeElement.text = "Start";
}

showDate(int millisecondsSinceEpoch){
  Date current = new Date.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  //DateFormat.Hms.format(current);
  _currentTimeElement.text = current.toString();
}
