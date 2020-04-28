import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/stream1.dart';
import 'package:provider/provider.dart';

import 'models.dart';

// ...

class MyHome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: ChangeNotifierProvider<LoadModel>(
            create: (context) => LoadModel(),
            child: MiddleWrap()
        )
    );
  }
}

class MiddleWrap extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final loadModel = Provider.of<LoadModel>(context, listen: false);
    return AnimatedListSample(loadModel: loadModel);
  }
}


class AnimatedListSample extends StatefulWidget {

  final loadModel;
  AnimatedListSample({@required this.loadModel});

  @override
  _AnimatedListSampleState createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final myTween = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<int> _list;
  int _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0],
    );
    _nextItem = 1;
    _consume();
  }
  void _insert() {
    final int index =_list.length;
//    _list.insert(index, _nextItem++);
  }

  void _consume(){
    widget.loadModel.start();
    final mystream = StringCreator().stream;
    mystream.listen((data){
      _list.insert(int.parse(data));
      },
      onDone: () => widget.loadModel.finish()
    );
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {

    final newAnimation = animation.drive(
        CurveTween(curve: Curves.elasticOut)
    );
//    return SlideTransition(
//      position: newAnimation.drive(myTween),
//      child: _list[index]
//    );
    return FadeTransition(
        opacity: animation,
        child: _list[index]
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building everything');
    return Scaffold(
        appBar: AppBar(
          title: const Text('AnimatedList'),
          actions: <Widget>[
            MyActivityIndicator(),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _insert,
              tooltip: 'insert a new item',
            ),
            IconButton(
              icon: const Icon(Icons.update),
              onPressed: _consume,
              tooltip: 'start the stream',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ),
      );
  }
}

class MyActivityIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    print('Building Activity Indictors');
    final loadModel = Provider.of<LoadModel>(context);
    return loadModel.finished? Container(): const CupertinoActivityIndicator(radius: 15);
  }
}

/// Keeps a Dart [List] in sync with an [AnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that
/// mutate the list must make the same changes to the animated list in terms
/// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    Iterable<int> initialItems,
  }) : assert(listKey != null),
        _items = initialItems.map((it) => CardItem(item: it)).toList();

  final GlobalKey<AnimatedListState> listKey;
  final List<CardItem> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int item) {
    _items.add(CardItem(item: item));
    _animatedList.insertItem(_items.length - 1, duration:const Duration(milliseconds: 1500));
  }

  int get length => _items.length;

  CardItem operator [](int index) => _items[index];

  int indexOf(CardItem item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value.
///
/// The text is displayed in bright green if [selected] is
/// true. This widget's height is based on the [animation] parameter, it
/// varies from 0 to 128 as the animation varies from 0.0 to 1.0.
//class CardItem extends StatelessWidget {
//  const CardItem({
//    Key key,
//    @required this.item
//  }) : super(key: key);
//
//  final int item;
//
//  @override
//  Widget build(BuildContext context) {
//    print('[Build]:[Card$item}]');
//    TextStyle textStyle = Theme.of(context).textTheme.display1;
//    return Padding(
//      padding: const EdgeInsets.all(2.0),
//      child: SizedBox(
//        height: 64.0,
//        child: Card(
//          color: Colors.primaries[item % Colors.primaries.length],
//          child: Center(
//            child: Text('Item $item', style: textStyle),
//          ),
//        ),
//      ),
//    );
//  }
//}
class CardItem extends StatefulWidget {
  const CardItem({
    Key key,
    @required this.item
  }) : super(key: key);

  final int item;

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print('[Build]:[Card${widget.item}}]');
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 64.0,
        child: Card(
          color: Colors.primaries[widget.item % Colors.primaries.length],
          child: Center(
            child: Text('Item ${widget.item}', style: textStyle),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

void main() {
  runApp(MyHome());
}