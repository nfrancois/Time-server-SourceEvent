library time_server;

import 'dart:io';
import 'dart:isolate';

const HOST = "127.0.0.1";
const PORT = 8080;
const SECOND = 1000;  

// http://www.html5rocks.com/en/tutorials/eventsource/basics/

main() {
  HttpServer server = new HttpServer();
  
  server..defaultRequestHandler = _serveFile
        ..addRequestHandler((HttpRequest request) => request.path == "/time", _time)
        ..listen(HOST, PORT);
  
  print("Serving the current time on http://${HOST}:${PORT}."); 
}

_time(HttpRequest request, HttpResponse response) {
  response.headers..set(HttpHeaders.CONTENT_TYPE, 'text/event-stream')
                  ..set(HttpHeaders.CACHE_CONTROL, 'no-cache')
                  ..set(HttpHeaders.CONNECTION, 'keep-alive');
  var timer = new Timer.repeating(SECOND, (t) => _onTick(t, response));  
}

_onTick(Timer timer, HttpResponse response) {
  try {
    Date now = new Date.now();
    response.outputStream.writeString('data:${now.millisecondsSinceEpoch}\n\n');
  } on StreamException {
    timer.cancel();
  } catch(e) {
    print(e);
  }
}
_serveFile(HttpRequest request, HttpResponse response){
  final String path = request.path == '/' ? ".${request.path}index.html" : ".${request.path}";
  final File file = new File(path);
  print('Serve $path');
  file.exists().then((exist) {
    if(exist){
      file.openInputStream().pipe(response.outputStream);
    } else {
      response..statusCode = HttpStatus.NOT_FOUND
              ..outputStream.close();        
    }    
  });
}
