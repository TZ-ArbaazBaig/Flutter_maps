import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      locale:  Locale('en'), // default to English
      supportedLocales:  [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      localizationsDelegates:  [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // Add the generated localization delegate
        DefaultMaterialLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Locale _locale = const Locale('hi');  // Default to English

  void _changeLanguage(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,  // Change locale dynamically
      supportedLocales: const [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(title: const Text('Language Drawer Example')),
        drawer: LanguageDrawer(onLanguageChanged: _changeLanguage),
        body: const Center(child: Text('Home Page')),
      ),
    );
  }
}

class LanguageDrawer extends StatelessWidget {
  final Function(String) onLanguageChanged;

  const LanguageDrawer({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    // Determine the language to change text direction
    bool isArabic = Localizations.localeOf(context).languageCode == 'hi';
     TextDirection textDirection =isArabic
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Drawer(
      child: Directionality(
        textDirection: textDirection,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('English'),
              onTap: () {
                onLanguageChanged('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Arabic'),
              onTap: () {
                onLanguageChanged('ar');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
