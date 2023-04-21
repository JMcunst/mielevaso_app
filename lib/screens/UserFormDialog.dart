import 'package:flutter/material.dart';

class UserFormDialog extends StatefulWidget {
  const UserFormDialog({Key? key}) : super(key: key);

  @override
  _UserFormDialogState createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Define the variables that you want to use in the form
  String _nickname = '';
  String _rank = '';
  String _server = '';
  String _guildName = '';
  String _guildPosition = '';
  String _arena = '';
  String _selena = '';

  // Define the lists that you want to use in the dropdowns
  final _serverFields = <String>[];
  final _guildNameFields = <String>[];
  final _guildPositionFields = <String>[];
  final _arenaFields = <String>[];
  final _realArenaFields = <String>[];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('User Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nickname'),
                initialValue: _nickname,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nickname';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _nickname = value ?? '';
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Rank'),
                initialValue: _rank,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rank';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _rank = value ?? '';
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Server'),
                value: _server,
                items: _serverFields.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _server = value ?? '';
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Guild Name',
                  hintText: 'Search your guild name',
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
                value: _guildName,
                items: _guildNameFields.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _guildName = value ?? '';
                  });
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Guild Position'),
                value: _guildPosition,
                items: _guildPositionFields.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _guildPosition = value ?? '';
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Arena',
                ),
                value: _arena,
                items: _arenaFields.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _arena = value ?? '';
                  });
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Selena',
                ),
                value: _selena,
                items: _realArenaFields.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selena = value ?? '';
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
// Do something with the user input
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
