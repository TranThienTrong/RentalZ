import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/widgets/header.dart';


class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _createAccountFormKey = GlobalKey<FormState>();
  late String username;

  _submit(){
    if (_createAccountFormKey.currentState!.validate()) {
      _createAccountFormKey.currentState!.save();
      Navigator.pop(context, username);
    }
  }


  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: Header("Set up new Account"),
      body: Form(
          key: _createAccountFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (value) => username=value!,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (value.length<3){
                      return 'Name too short';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
