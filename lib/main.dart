import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.data);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Messaging with Udemy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase Messaging'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    initializeFCM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Testes com mensageria do Firebase',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initializeFCM() async {
    final token = await messaging.getToken();
    print(token);

    // Cadastro meu app em um topico
    await messaging.subscribeToTopic('saopaulo');

    // Recuperamos a mensagem quando o app está aberto
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification?.title);

      if (event.notification != null) {
        Flushbar(
          margin: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
          title: event.notification?.title,
          titleColor: Colors.black,
          messageColor: Colors.black,
          flushbarPosition: FlushbarPosition.TOP,
          message: event.notification?.body,
          icon: const Icon(
            Icons.notifications,
            color: Colors.blue,
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 50),
        ).show(context);

        print(event.data);
      }
    });

    // Recuperamos a mensagem quando o app está fechado
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // Recuperamos a mensagem quando o app está fechado e o usuário toca na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event?.data);
    });

    // Recuperamos a mensagem quando o app está fechado e o usuário toca na notificação
    final RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      print("Toque em terminated: ${message!.notification?.title}");
    }
  }
}
