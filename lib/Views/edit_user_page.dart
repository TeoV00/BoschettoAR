import 'package:flutter/material.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Database/database_constant.dart';
import 'package:tree_ar/constant_vars.dart';

class EditUserInfoPage extends StatefulWidget {
  final User user;
  const EditUserInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  //if field is null -> not edited
  User formUser = User(
      userId: DEFAULT_USER_ID,
      name: null,
      surname: null,
      dateBirth: null,
      course: null,
      registrationDate: null,
      userImageName: null);

  @override
  Widget build(BuildContext context) {
    User usr = widget.user;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: secondColor,
        title: const Text("Modifica Dati"),
        actions: [
          IconButton(
            tooltip: 'Chiudi tastiera',
            onPressed: () => {FocusScope.of(context).unfocus()},
            icon: const Icon(Icons.keyboard_hide_sharp),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                fieldGroupForm("Dati Anagrafici"),
                TextFormField(
                  maxLines: 1,
                  initialValue: usr.name,
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    hintText: 'Nome',
                    label: Text('Nome'),
                  ),
                ),
                TextFormField(
                  maxLines: 1,
                  initialValue: usr.surname,
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    hintText: 'Cognome',
                    label: Text('Cognome'),
                  ),
                ),
                TextFormField(
                  initialValue: usr.dateBirth,
                  keyboardType: TextInputType.none,
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    label: Text("Data Nascita"),
                  ),
                  onTap: () => {},
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: fieldGroupForm("Carriera Universitaria"),
                ),
                TextFormField(
                  maxLines: 1,
                  initialValue: usr.course,
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    hintText: 'Corso Universitario',
                    labelText: 'Corso Universitario',
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  maxLength: 4,
                  initialValue: usr.registrationDate,
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    hintText: 'Anno Immatricolazione',
                    labelText: 'Anno Immatricolazione',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _saveChanges(), //call datamanager method
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                  ),
                  child: const Text("Salva Modifiche"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text fieldGroupForm(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _saveChanges() {}
}
