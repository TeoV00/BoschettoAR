import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_ar/Database/dataModel.dart';
import 'package:tree_ar/Database/database_constant.dart';
import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/data_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_ar/utils.dart';

const String newPhotoMsg =
    "Riavvia l'applicazione per visualizzare la nuova immagine";

const alertEditNotSavedMsg =
    'Per continuare a modificare clicca "Continua" altrimenti per lasciare questa schemrata senza salvare clicca "Lascia"';

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
  void initState() {
    super.initState();
    usr = widget.user;
    nameContr = TextEditingController(text: usr.name);
    surnameContr = TextEditingController(text: usr.surname);
    dateBirthContr = TextEditingController(text: usr.dateBirth);
    courseContr = TextEditingController(text: usr.course);
    dateImmatricContr = TextEditingController(text: usr.registrationDate);

    formUser.userImageName = usr.userImageName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: secondColor,
        title: const Text("Modifica Dati"),
        leading: BackButton(onPressed: () => _alertEditing(context)),
        actions: [
          IconButton(
            tooltip: 'Chiudi tastiera',
            onPressed: () => {FocusScope.of(context).unfocus()},
            icon: const Icon(Icons.keyboard_hide_sharp),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  getUserImageWidget(formUser.userImageName),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: mainColor),
                    child: IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      tooltip: 'Modifica immagine',
                      onPressed: () => {_changeUserImage()},
                    ),
                  )
                ],
              ),
              Form(
                key: _formKey,
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
                          initialDateTime:
                              DateTime.tryParse(usr.dateBirth ?? '') ??
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
                    fieldGroupForm("Carriera Universitaria"),
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
                    Consumer<DataManager>(
                      builder: (context, dataManager, child) => ElevatedButton(
                        onPressed: () async => _saveChanges(
                            context, dataManager), //call datamanager method
                        style: ElevatedButton.styleFrom(
                          primary: mainColor,
                        ),
                        child: const Text("Salva Modifiche"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldGroupForm(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    nameContr.dispose();
    surnameContr.dispose();
    dateBirthContr.dispose();
    courseContr.dispose();
    dateImmatricContr.dispose();
  }

  void _changeUserImage() async {
    final XFile? imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      final File image = File(imagePicked.path);
      final String path = (await getApplicationDocumentsDirectory()).path;
      final File newImage = await image.copy('$path/user${usr.userId}.png');

      setState(() {
        formUser.userImageName = newImage.path;
      });
    }
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

  void _alertEditing(context) {
    if (formUser
        .toMap()
        .entries
        .any((e) => e.key != 'userId' && e.value != null)) {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Modifiche non salvate'),
          content: const Text(alertEditNotSavedMsg),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continua'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Lascia'),
            ),
          ],
        ),
      ).then((answer) => {
            if (answer == false) {_backPrevScreen(context, false)},
          });
    } else {
      _backPrevScreen(context, false);
    }
  }

  void _backPrevScreen(BuildContext context, bool isUpdated) {
    Navigator.pop(context, isUpdated);
  }

  void _saveChanges(BuildContext context, DataManager dm) async {
    dm.updateCurrentUserInfo(formUser).then((isDone) => {
          showSnackBar(
              context,
              isDone
                  ? const Text("Modifiche salvate")
                  : const Text("Errore nel salvataggio"),
              null),
          _backPrevScreen(context, isDone)
        });
  }
}
