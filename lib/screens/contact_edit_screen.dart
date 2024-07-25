import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class ContactEditScreen extends StatefulWidget {
  final Contact contact;

  ContactEditScreen({required this.contact});

  @override
  _ContactEditScreenState createState() => _ContactEditScreenState();
}

class _ContactEditScreenState extends State<ContactEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _email;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _firstName = widget.contact.firstName;
    _lastName = widget.contact.lastName;
    _email = widget.contact.email ?? '';
    _dobController = TextEditingController(text: widget.contact.dob ?? '');
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedContact = Contact(
        id: widget.contact.id,
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        dob: _dobController.text,
      );
      Provider.of<ContactProvider>(context, listen: false)
          .updateContact(updatedContact);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF8C00),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _deleteContact() {
    Provider.of<ContactProvider>(context, listen: false)
        .deleteContact(widget.contact.id);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 251, 251, 250),
        title: Text('Edit Contact'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFF8C00)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Color(0xFFFF8C00)),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFFFF8C00),
                  child: Text(
                    '${widget.contact.firstName[0]}${widget.contact.lastName[0]}',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              Text(
                'Main Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('First Name'),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: _firstName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value!;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Last Name'),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: _lastName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastName = value!;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
              ),
              Text(
                'Sub Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('Email'),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value ?? '';
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('DOB'),
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
              ),
              ElevatedButton(
                onPressed: _deleteContact,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Delete Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
