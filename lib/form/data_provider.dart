import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier{
  DataProvider() {
    _loadLocale();
  }
 static const List<Map<String,dynamic>> languages =[
   {
     'name':'English',
     'language':'en',
   },
   {
     'name':'Arabic',
     'language':'hi',
   },
 
 ];

  Locale selectLocale=const Locale('en');

  // void changeLanguage(String language){
  //   selectLocale=Locale(language);
  //   notifyListeners();
  // }
  

  
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLocale = prefs.getString('locale') ?? 'en';  
    selectLocale = Locale(savedLocale);
    notifyListeners();
  }

  
  Future<void> changeLanguagee(String languageCode) async {
    selectLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', languageCode); 
    notifyListeners();  
  }


}