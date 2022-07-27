import 'package:flutter/cupertino.dart';
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

  late final TextEditingController nameContr;
  late final TextEditingController surnameContr;
  late final TextEditingController dateBirthContr;
  late final TextEditingController courseContr;
  late final TextEditingController dateImmatricContr;
  late final User usr;

  @override
  void initState() {
    super.initState();
    usr = widget.user;
    nameContr = TextEditingController(text: usr.name);
    surnameContr = TextEditingController(text: usr.surname);
    dateBirthContr = TextEditingController(text: usr.dateBirth);
    courseContr = TextEditingController(text: usr.course);
    dateImmatricContr = TextEditingController(text: usr.registrationDate);
  }

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
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  controller: nameContr,
                  maxLines: 1,
                  onChanged: (value) {
                    formUser.name = value;
                  },
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
                  textInputAction: TextInputAction.next,
                  controller: surnameContr,
                  onChanged: (newVal) {
                    formUser.surname = newVal;
                  },
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    hintText: 'Cognome',
                    label: Text('Cognome'),
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: dateBirthContr,
                  readOnly: true,
                  keyboardType: TextInputType.datetime,
                  onChanged: (newVal) {
                    formUser.dateBirth = newVal;
                  },
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    label: Text("Data Nascita"),
                  ),
                  onTap: () => _showDialog(
                    CupertinoDatePicker(
                      dateOrder: DatePickerDateOrder.dmy,
                      initialDateTime: DateTime.tryParse(usr.dateBirth ?? '') ??
                          DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      // This is called when the user changes the date.
                      onDateTimeChanged: (DateTime newDate) {
                        var dateString =
                            '${newDate.day}/${newDate.month}/${newDate.year}';
                        dateBirthContr.text = dateString;
                        setState(() => formUser.dateBirth = dateString);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: fieldGroupForm("Carriera Universitaria"),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  controller: courseContr,
                  onChanged: (newVal) {
                    formUser.course = newVal;
                  },
                  decoration: const InputDecoration(
                    labelStyle: labelStyle,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainColor)),
                    hintText: 'Corso Universitario',
                    labelText: 'Corso Universitario',
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: dateImmatricContr,
                  onChanged: (newVal) {
                    formUser.registrationDate = newVal;
                  },
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  maxLength: 4,
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameContr.dispose();
    surnameContr.dispose();
    dateBirthContr.dispose();
    courseContr.dispose();
    dateImmatricContr.dispose();
    super.dispose();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  void _saveChanges() {
    print(formUser.toString());
  }
}
