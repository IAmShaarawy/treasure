import 'package:flutter/material.dart';

class EditName extends StatefulWidget {
  final String name;

  EditName({this.name});

  @override
  _EditNameState createState() => _EditNameState(name: name);
}

class _EditNameState extends State<EditName> {
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _count = "";

  _EditNameState({String name}) {
    nameController.text = name;
    _count = name.length.toString()+"/30";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 8,
          children: [
            Text(
              "Edit Name",
              style: Theme.of(context).textTheme.headline5,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: TextFormField(
                onChanged: _onTextChange,
                controller: nameController,
                validator: _validateName,
                decoration: InputDecoration(
                  counterText: _count,
                  filled: true,
                  labelText: "Your Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () => onSaveNamePressed(context),
            ),
          ],
        ),
      ),
    );
  }


  String _validateName(String nameText) {
    if (nameText.isEmpty || nameText.trim().length <= 0) {
      return "Enter some value";
    }

    if (nameText.length < 5) {
      return "Feedback must be at min 5 character";
    }

    if (nameText.length > 30) {
      return "Feedback must be at max 300 character";
    }
    return null;
  }

  void _onTextChange(String text) {
    setState(() {
      _count = "${text.length}/30";
    });
  }

  void onSaveNamePressed(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Navigator.of(context).pop(nameController.text);
    }
  }
}
