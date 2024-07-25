import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/contact_provider.dart';
import 'screens/contact_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          ContactProvider()..loadContacts(), // Load contacts on app start
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ContactListScreen(),
      ),
    );
  }
}
