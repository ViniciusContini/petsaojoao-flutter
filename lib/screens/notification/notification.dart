import 'package:flutter/material.dart';
import 'package:petsaojoao/screens/notification/pet_found/pet_found_board.dart';
import 'package:petsaojoao/screens/login/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class PushMessaging extends StatefulWidget {
  @override
  _PushMessagingState createState() => _PushMessagingState();
}

class _PushMessagingState extends State<PushMessaging> {
  String _homeScreenText = "Waiting for token...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _navigateToItemDetail(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );

    //Needed by iOS only
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    //Getting the token from FCM
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: \n\n $token";
      });
      print(_homeScreenText);
    });
  }
  final _imgPaws=Image.asset("assets/login/legs.png");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[200],
      body: Container(
        child: Stack(
          children: <Widget>[
            ClipWavy(),
            LogoApp()
          ],
        )
      ),
    );
  }

  //PRIVATE METHOD TO HANDLE NAVIGATION TO SPECIFIC PAGE
  void _navigateToItemDetail(Map<String, dynamic> message) {
    final MessageBean item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }
}

final Map<String, MessageBean> _items = <String, MessageBean>{};
MessageBean _itemForMessage(Map<String, dynamic> message) {
  //If the message['data'] is non-null, we will return its value, else return map message object
  final dynamic data = message['data'] ?? message;
  final String petId = data['id_fnd'].toString();
  final MessageBean item = _items.putIfAbsent(
      petId, () => MessageBean(petId: petId))
    ..status = data['status'];
  return item;
}

//Model class to represent the message return by FCM
class MessageBean {
  MessageBean({this.petId});
  final String petId;

  StreamController<MessageBean> _controller =
  StreamController<MessageBean>.broadcast();
  Stream<MessageBean> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route<void>> routes = <String, Route<void>>{};
  Route<void> get route {
    final String routeName = '/detail/$petId';
    return routes.putIfAbsent(
      routeName,
      () => MaterialPageRoute<void>(
        settings: RouteSettings(name: routeName),
        builder: (BuildContext context) => DetailPage(petId),
      ),
    );
  }
}

//Detail UI screen that will display the content of the message return from FCM
class DetailPage extends StatefulWidget {
  DetailPage(this.petId);
  final String petId;
  @override
  _DetailPageState createState() => _DetailPageState();
}

class ClipWavy extends StatelessWidget {
  final _imgPaws=Image.asset("assets/login/legs.png");
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          child: Opacity(
            opacity: 0.35,
            child: _imgPaws,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login()),
            );
          },
        ),GestureDetector(
          child: Opacity(
            opacity: 0.35,
            child: _imgPaws,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login()),
            );
          },
        ),
        GestureDetector(
          child: Opacity(
            opacity: 0.35,
            child: _imgPaws,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login()),
            );
          },
        ),
      ],
    );
  }
}

class LogoApp extends StatelessWidget {
  final _imgLogo=Image.asset("assets/login/logoDogWhite.png");
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 260
      ),
      height: 370,
      width: double.maxFinite,
      alignment: Alignment.center,
      child: _imgLogo,
    );
  }
}

class _DetailPageState extends State<DetailPage> {
  MessageBean _item;
  StreamSubscription<MessageBean> _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.petId];
    _subscription = _item.onChanged.listen((MessageBean item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PetFoundBoard(valor: _item.petId,);
  }
}
