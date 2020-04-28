import 'dart:async';

void main(){
  final mystream = StringCreator().stream;
  final sub = mystream.listen((data){
    print(data);
  });
}

class StringCreator{
  var _count = 100;
  final _controller = StreamController<String>();

  StringCreator(){
    Timer.periodic(Duration(milliseconds: 1000), (t){
      _controller.sink.add(_count.toString());
      _count ++;
      if (_count > 110){
        t.cancel();
        _controller.close();
      }
    });
  }

  Stream<String> get stream => _controller.stream;
}
