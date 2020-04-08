import 'package:flutter/material.dart';
import 'package:flutter_desk_calendar/QCalNotification.dart';
import 'package:flutter_desk_calendar/QCalModel.dart';
import 'package:flutter_desk_calendar/QCalendarWidget.dart';

const studys = [
  'android',
  'ios',
  'web',
  'flutter',
  'kotlin',
  'swift',
  'React Native',
  'java',
  'Object-C',
  'PHP'
];

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage>
    with QCalendarWidgetMixin<ExamplePage> {
  ScrollController _scrollController;
  Date focusDateTime = Date.from(DateTime.now());
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  final Key scrollViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(child: Text(focusDateTime.toString())),
            centerTitle: false,
            leading: Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.cyan,
        body: SafeArea(
            top: false,
            bottom: false,
            child: Container(
                child: NotificationListener<QCalNotification>(
                    onNotification: (notification) {
                      print(
                          "QCalNotification: ${notification.model.focusDateTime}");
                      focusDateTime = notification.model.focusDateTime;
                      setState(() {});
                      return true;
                    },
                    child: customScrollView(
                        _scrollController,
                        CustomScrollView(
                          physics: ClampingScrollPhysics(),
                          key: scrollViewKey,
                          controller: _scrollController,
                          slivers: <Widget>[
                            sliverHeader(),
                            SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return new Container(
                                  height: 85,
                                  alignment: Alignment.center,
                                  color:
                                      Colors.lightBlue[100 * ((index % 9) + 1)],
                                  child: new Text('${studys[index]}'),
                                );
                              }, childCount: studys.length),
                            ),
                          ],
                        ))))));
  }
}
