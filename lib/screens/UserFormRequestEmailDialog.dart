import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class UserFormRequestEmailDialog extends StatefulWidget {
  const UserFormRequestEmailDialog({Key? key}) : super(key: key);

  @override
  _UserFormRequestEmailDialogState createState() => _UserFormRequestEmailDialogState();
}

class _UserFormRequestEmailDialogState extends State<UserFormRequestEmailDialog> {
  final GlobalKey<FormState> _mailFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _guildNameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  void _submitMailForm() async {
    final FormState? mailForm = _mailFormKey.currentState;
    if (mailForm == null) {
      return;
    }
    if (!mailForm.validate()) {
      return;
    }
    mailForm.save();

    final String name = _nameController.text;
    final String server = _serverController.text;
    final String guildName = _guildNameController.text;
    final String comment = _commentController.text;

    final Email send_email = Email(
      body: 'Name: $name\nServer: $server\nGuild Name: $guildName\nComment: $comment',
      subject: 'subject of email',
      recipients: ['no.reply.ezcominc@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(send_email);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('User Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _mailFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                const InputDecoration(labelText: 'Name'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serverController,
                decoration:
                const InputDecoration(labelText: 'Server'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a server';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _guildNameController,
                decoration:
                const InputDecoration(labelText: 'Guild Name'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a guild name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _commentController,
                decoration:
                const InputDecoration(labelText: 'Comment'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitMailForm,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
