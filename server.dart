#library("time_server");

#import("dart:io");

final HOST = "127.0.0.1";
final PORT = 8080;


// http://www.html5rocks.com/en/tutorials/eventsource/basics/

main() {
  HttpServer server = new HttpServer();
  
  server
        ..addRequestHandler((HttpRequest request) => request.path == "/time", time)
        ..addRequestHandler((_) => true, serveFile)
        ..listen(HOST, PORT);
  
  print("Serving the current time on http://${HOST}:${PORT}."); 
}


time(HttpRequest request, HttpResponse response) {
  
  Date now = new Date.now();
  String dataResponse = 'retry:1000\ndata:${now.millisecondsSinceEpoch}\n\n';
  
  response.headers..set(HttpHeaders.CONTENT_TYPE, 'text/event-stream')
                  ..set(HttpHeaders.CACHE_CONTROL, 'no-cache')
                  ..set(HttpHeaders.CONNECTION, 'keep-alive');
  response.outputStream..writeString(dataResponse)
                       ..close();  

  
}

serveFile(HttpRequest request, HttpResponse response){
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