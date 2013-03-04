library time_server;

import 'dart:io';
import 'dart:isolate';
import 'dart:async';

const HOST = "127.0.0.1";
const PORT = 8080;
const SECOND = 1000;

// http://www.html5rocks.com/en/tutorials/eventsource/basics/

main() {
  HttpServer.bind(HOST, PORT).then((HttpServer server) {
    print("Serving the current time on http://${HOST}:${PORT}.");
    server.listen((HttpRequest request) {
      if(request.uri.path == "/time"){
        _time(request);
      } else {
        _serveFile(request);
      }
    });
  });
}

_time(HttpRequest request) {
  request.response.headers..set(HttpHeaders.CONTENT_TYPE, 'text/event-stream')
                          ..set(HttpHeaders.CACHE_CONTROL, 'no-cache')
                          ..set(HttpHeaders.CONNECTION, 'keep-alive');
  var timer = new Timer.repeating(SECOND, (t) => _onTick(request.response));
  // TODO close timer https://code.google.com/p/dart/issues/detail?id=4652
  //request.response.done.whenComplete(() => timer.cancel());
}

_onTick(HttpResponse response) {
  var tick = new DateTime.now().millisecondsSinceEpoch;
  print("server tick : $tick");
  response.addString('data:$tick\n\n');

}

_serveFile(HttpRequest request){
  final String path = request.uri.path == '/' ? "web/index.html" : "web/${request.uri.path}";
  final File file = new File(path);
  print('Serve $path');
  file.exists().then((exist) {
    if(exist){
      file.openRead().pipe(request.response);
    } else {
      request.response..statusCode = HttpStatus.NOT_FOUND
                      ..close();
    }
  });
}
