#library("time_server");

#import("dart:io");
#import('dart:isolate');

final HOST = "127.0.0.1";
final PORT = 8080;


// http://www.html5rocks.com/en/tutorials/eventsource/basics/

main() {
  HttpServer server = new HttpServer();
  
  server..addRequestHandler((HttpRequest request) => request.path == "/time", _time)
        ..addRequestHandler((_) => true, _serveFile)
        ..listen(HOST, PORT);
  
  print("Serving the current time on http://${HOST}:${PORT}."); 
}


_time(HttpRequest request, HttpResponse response) {
  response.headers..set(HttpHeaders.CONTENT_TYPE, 'text/event-stream')
                  ..set(HttpHeaders.CACHE_CONTROL, 'no-cache')
                  ..set(HttpHeaders.CONNECTION, 'keep-alive');
  var timer = new Timer.repeating(1000, (_){
     Date now = new Date.now();
    response.outputStream..writeString('data:${now.millisecondsSinceEpoch}\n\n');
  });  
}



_serveFile(HttpRequest request, HttpResponse response){
  final String path = request.path == '/' ? ".${request.path}index.html" : ".${request.path}";
  final File file = new File(path);
  print('Serve $path');
  file.exists().then((exist) {
    if(exist){
      file.openInputStream().pipe(response.outputStream);
    } else {
      response.statusCode = HttpStatus.NOT_FOUND;
      response.outputStream.close();        
    }    
  });
}