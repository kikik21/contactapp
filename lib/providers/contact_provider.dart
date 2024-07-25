import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // for rootBundle
import 'package:path_provider/path_provider.dart';

import '../models/contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];

  // List<Contact> get contacts => _contacts;

  List<Contact> get contacts =>
      _filteredContacts.isEmpty ? _contacts : _filteredContacts;

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<void> _copyJsonFromAssets() async {
    final file = await _localFile;
    if (!(await file.exists())) {
      final data = await rootBundle.loadString('assets/data.json');
      await file.writeAsString(data);
    }
  }

  Future<void> loadContacts() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    _contacts = jsonResponse.map((data) => Contact.fromJson(data)).toList();
    _filteredContacts = [];
    notifyListeners();
    try {
      await _copyJsonFromAssets(); // Ensure the file is copied from assets if it doesn't exist
      final file = await _localFile;
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      _allContacts = jsonData.map((item) => Contact.fromJson(item)).toList();
      _contacts = jsonData.map((data) => Contact.fromJson(data)).toList();
      notifyListeners();
    } catch (e) {
      print('Failed to load contacts: $e');
    }
  }

  Future<void> writeContacts() async {
    final file = await _localFile;
    List<Map<String, dynamic>> jsonData =
        _contacts.map((contact) => contact.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
  }

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
    writeContacts();
  }

  void updateContact(Contact updatedContact) {
    final index =
        _contacts.indexWhere((contact) => contact.id == updatedContact.id);
    if (index != -1) {
      _contacts[index] = updatedContact;
      notifyListeners();
      writeContacts();
    }
  }

  void deleteContact(String id) {
    _contacts.removeWhere((contact) => contact.id == id);
    notifyListeners();
    writeContacts();
  }

  void searchContacts(String query) {
    if (query.isEmpty) {
      _filteredContacts = [];
    } else {
      _filteredContacts = _contacts.where((contact) {
        final fullName =
            '${contact.firstName} ${contact.lastName}'.toLowerCase();
        final searchQuery = query.toLowerCase();
        return fullName.contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }
}
