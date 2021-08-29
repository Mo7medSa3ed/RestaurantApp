import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturantapp/constants.dart';
import 'package:resturantapp/provider/appdata.dart';
import 'package:resturantapp/provider/special.dart';
import 'package:resturantapp/screans/splashScrean.dart';
import 'package:resturantapp/socket.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!(Socket().socket.connected)) {
    Socket().socket.connect();
  }
  print(Socket().socket.connected);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Specials>(
      create: (context) => Specials(),
    ),
    ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Socket().socket.on('newDish', (data) {
      final pro = Provider.of<AppData>(context, listen: false);
      print(data);
      data['category'] = pro.getCategoryById(data['category']);
      pro.addNewDish(data);
    });
    Socket().socket.on('updateDish', (data) {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      data['category'] = pro.getCategoryById(data['category']);
      pro.updateDish(data);
    });
    Socket().socket.on('deleteDish', (data) {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.removeDish(data['_id']);
    });
    Socket().socket.on('newCategory', (data) {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.addCategory(data);
    });
    Socket().socket.on('updateCategory', (data) {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.updateCategory(data);
    });
    Socket().socket.on('deleteCategory', (data) {
      print(data);
      final pro = Provider.of<AppData>(context, listen: false);
      pro.removeCategory(data['_id']);
    });
      

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
              fontFamily: 'Montserrat',
              // ignore: deprecated_member_use
              accentColor: Kprimary,
              primaryColor: Kprimary)
          .copyWith(
        dialogBackgroundColor: Colors.white,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: Kprimary,
              primary: red,
            ),
        primaryColor: Kprimary,
        highlightColor: Colors.grey[400],
        hintColor: Colors.grey,
        textSelectionTheme: TextSelectionThemeData(cursorColor: red),
        scaffoldBackgroundColor: Colors.white.withOpacity(0.97),
        appBarTheme: AppBarTheme(
          // ignore: deprecated_member_use
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Kprimary.withOpacity(0.6)),
          elevation: 0,
          color: Colors.white.withOpacity(0.4),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScrean(),
    );
  }
}
