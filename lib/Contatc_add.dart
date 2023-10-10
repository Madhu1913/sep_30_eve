import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sep_30_eve/contacts_model.dart';
import 'package:sep_30_eve/main.dart';

class ContactText extends StatefulWidget {
  final Contact? editedContact;


  const ContactText({this.editedContact, super.key});

  @override
  State<ContactText> createState() => _ContactTextState();
}

class _ContactTextState extends State<ContactText> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _eMail;
  String? _phoneNumber;
  XFile? _contactImageFile;
  bool get hasSelectedCustomImage=> _contactImageFile!=null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState(
    );
    _contactImageFile=widget.editedContact?.imgFile as XFile?;
  }
  // String? validateName(String value){
  //   if(value.isEmpty){
  //     return 'Enter the Name';
  //   }
  //   return null;
  // }
  void _onContactSavePressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      final newContact = Contact(
        name: _name!,
        email: _eMail!,
        phoneNumber: _phoneNumber!,
        isFavourite: widget.editedContact?.isFavourite ??false,
        imgFile: _contactImageFile!,


      );
      if (widget.editedContact != null) {
        newContact.id=widget.editedContact?.id;
        ScopedModel.of<contatacsModel>(context)
            .updateContact(newContact);
      }
      else {
        ScopedModel.of<contatacsModel>(context).addContact(newContact);
      }

      Navigator.pop(context);
    }
  }

  Widget _builtCircularAvatarContent(double halfScreenWidth) {
    if (widget.editedContact != null||hasSelectedCustomImage) {
        return _builtCircleAvatarEditModeContent(halfScreenWidth);
    } else {
      return Icon(
        Icons.person,
        size: halfScreenWidth / 2,
      );
    }
  }
  Widget _builtCircleAvatarEditModeContent(double halfScreenWidth){
     if (_contactImageFile == null) {
      return Text(
        widget.editedContact!.name[0],
        style: TextStyle(fontSize: halfScreenWidth / 2),
      );
    } else {
      return ClipOval(
          child: AspectRatio(
            aspectRatio: 1/1,
            child: Image.file(
              File(_contactImageFile!.path),
              fit: BoxFit.fill,
            ),
          ));
    }
  }

  Widget _buildContactPicture() {
    double halfScreenWidth = MediaQuery.of(context).size.width / 2;
    return Hero(
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenWidth / 2,
          child: _builtCircularAvatarContent(halfScreenWidth),
        ),
      ),
    );
  }

  Future _onContactPictureTapped() async {
    final imgFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _contactImageFile = imgFile as XFile?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          SizedBox(
            height: 10,
          ),
          _buildContactPicture(),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _name = value,
            initialValue: widget.editedContact?.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter the Name';
              } else
                return null;
            },
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _eMail = value,
            validator: (value) {
              // final emailregex=RegExp(r"^[A-Za-z0-9](([a-zA-Z0-9,=\.!\-#|\$%\^&\*\+/\?_`\{\}~]+)*)@(?:[0-9a-zA-Z-]+\.)+[a-zA-Z]{2,9}$");
              if (value!.isEmpty) {
                return 'Enter a E-Mail';
              }
              // else if(!emailregex.hasMatch(value)){
              //   return 'Enter Valid E-Mail';
              // }
            },
            initialValue: widget.editedContact?.email,
            decoration: InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (value) => _phoneNumber = value,
            validator: (value) {
              // final phonenumberregex=RegExp(r'^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$');
              if (value!.isEmpty) {
                return 'Enter Phone Number';
              }
              // else if(!phonenumberregex.hasMatch(value)){
              //   return 'Enter valid Phone number';
              // }
            },
            initialValue: widget.editedContact?.phoneNumber,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton(
            onPressed: _onContactSavePressed,
            child: Text(
              'Save',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
