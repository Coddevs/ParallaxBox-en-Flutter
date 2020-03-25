import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parallax',
      theme: ThemeData.dark(),
      home: Initial(),
    );
  }
}

class ParallaxBox extends StatefulWidget {
  static double initialPosition;

  final double height;
  final Widget background;
  final Widget child;
  ParallaxBox({
    @required this.height,
    @required this.background,
    @required this.child,
  }) :
      assert(height!=null),
      assert(child!=null),
      assert(background!=null),
      assert(initialPosition!=null, 'The first parallax box require a initial position')
  ;

  final _parallaxState = _ParallaxBoxState();

  double get startGlobalPosition => _parallaxState._startGlobalPosition;
  double get endGlobalPosition => _parallaxState._endGlobalPosition;
  double get insidePosition => _parallaxState._insidePosition;
  set insidePosition(double value) {
    _parallaxState._insidePosition = value;
    _parallaxState.refresh();
  }

  State createState() => _parallaxState;
}
class _ParallaxBoxState extends State<ParallaxBox> {
  static final _allHeight = <double>[ParallaxBox.initialPosition];

  double _startGlobalPosition;
  double _endGlobalPosition;
  double _insidePosition = 0.0;

  void refresh() => setState(() {});

  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Transform.translate(
        offset: Offset(0.0, _insidePosition),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: widget.background,
        ),
      ),
      SizedBox(
        height: widget.height,
        width: double.infinity,
        child: widget.child,
      ),
    ]);
  }

  void initState() {
    double positionFromHeight = 0.0;
    for (var height in _allHeight) positionFromHeight+=height;
    _startGlobalPosition = positionFromHeight;
    _allHeight.add(widget.height);
    positionFromHeight = 0.0;
    for (var height in _allHeight) positionFromHeight+=height;
    _endGlobalPosition = positionFromHeight;
    /*print('--------------------------------------------------');
		print('_startGlobalPosition : $_startGlobalPosition');
		print('_endGlobalPosition   : $_endGlobalPosition');*/
    super.initState();
  }
}

class Initial extends StatefulWidget {
  State createState() => _InitialState();
}
class _InitialState extends State<Initial> {
  final _scrollController = ScrollController();
  final _initialPosition = 100.0;
  ParallaxBox _pbox1;
  ParallaxBox _pbox2;
  ParallaxBox _pbox3;

  Widget build(BuildContext context) {
    _pbox1 ??= ParallaxBox(
      height: 350.0,
      background: ColoredBox(
        color: Colors.teal[900],
        child: Placeholder(color: Colors.white),
      ),
      child: Center(
        child: Column(children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 1   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 1   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 1   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
    _pbox2 ??= ParallaxBox(
      height: 500.0,
      background: ColoredBox(
        color: Colors.blue[900],
        child: Placeholder(color: Colors.white),
      ),
      child: Center(
        child: Column(children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 2   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 2   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 2   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
    _pbox3 ??= ParallaxBox(
      height: 200.0,
      background: ColoredBox(
        color: Colors.deepPurple[900],
        child: Placeholder(color: Colors.white),
      ),
      child: Center(
        child: Column(children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 3   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 3   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '   ParallaxBox 3   ',
                style: TextStyle(backgroundColor: Colors.black, color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );

    return Scaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350.0),
              child: Column(children: <Widget>[
                ColoredBox(
                  color: Colors.black,
                  child: Placeholder(fallbackHeight: _initialPosition, color: Colors.white),
                ),
                _pbox1,
                _pbox2,
                _pbox3,
                ColoredBox(
                  color: Colors.black,
                  child: Placeholder(fallbackHeight: 750.0, color: Colors.white),
                ),
              ]),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_drop_down),
        onPressed: () => _scrollController.animateTo(
          1150.0,
          curve: Curves.easeIn,
          duration: Duration(seconds: 5),
        ),
      ),
    );
  }

  void initState() {
    ParallaxBox.initialPosition = _initialPosition;
    _scrollController.addListener(() {
      double scrollPosition = _scrollController.position.pixels;
      if (scrollPosition<_pbox1.startGlobalPosition) {
        _pbox3.insidePosition = 0.0;
        _pbox2.insidePosition = 0.0;
        _pbox1.insidePosition = 0.0;
      } else if (scrollPosition<_pbox1.endGlobalPosition) {
        _pbox3.insidePosition = 0.0;
        _pbox2.insidePosition = 0.0;
        _pbox1.insidePosition = scrollPosition-_pbox1.startGlobalPosition;
      } else if (scrollPosition<_pbox2.endGlobalPosition) {
        _pbox3.insidePosition = 0.0;
        _pbox2.insidePosition = scrollPosition-_pbox2.startGlobalPosition;
      } else if (scrollPosition<_pbox3.endGlobalPosition) {
        _pbox3.insidePosition = scrollPosition-_pbox3.startGlobalPosition;
      }
      /*print('--------------------------------------------------');
			print('_parallax1.insidePosition : ${_parallax1.insidePosition}');
			print('_parallax2.insidePosition : ${_parallax2.insidePosition}');
			print('_parallax3.insidePosition : ${_parallax3.insidePosition}');*/
    });
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}