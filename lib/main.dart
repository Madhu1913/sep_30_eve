import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sep_30_eve/addcontact.dart';
import 'package:sep_30_eve/contacts.dart';
import 'package:sep_30_eve/contacts_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: contatacsModel()..loadContacts(),
      child: MaterialApp(
        home: FirstScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override

  // void _sortContacts(){
  //   _contacts.sort((a,b){
  //     int comparisonResult;
  //     comparisonResult=_compareBasedOnFavouriteStatus(a, b);
  //     if(comparisonResult==0){
  //       comparisonResult=_compareAlphabetically(a, b);
  //     }
  //     return comparisonResult;
  //   });
  // }
  // int _compareBasedOnFavouriteStatus(Contact a, Contact b) {
  //   if (a.isFavourite) {
  //     return -1;
  //   } else if (b.isFavourite) {
  //     return -1;
  //   } else
  //     return 0;
  // }
  //
  // int _compareAlphabetically(Contact a, Contact b) {
  //   return a.name.compareTo(b.name);
  // }

  // void addContact(Contact contact1){
  //   print(_contact.length);
  //      _contact.add(contact1);
  //     print(_contact.length);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ScopedModelDescendant<contatacsModel>(
        builder: (context, child, model) {
          if(model.isLoading){
            return Center(child: CircularProgressIndicator());
          }
          else{
            return ListView.builder(
              itemCount: model.contacts?.length,
              itemBuilder: (context, i) {
                return ContactTile(
                  contactIndex: i,
                );
              },
            );
          }

        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => Contactform()));
        },
      ),
    );
  }
}

class Contact {
  int? id;
  String name;
  String email;
  String phoneNumber;
  bool isFavourite;
  XFile? imgFile;
  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavourite = false,
    this.imgFile,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavourite': isFavourite?1:0,
      'imgFilePath': imgFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
        name: map['name'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        isFavourite: map['isFavourite']==1?true:false,
        imgFile: map['imgFilePath'] !=null ? XFile(map['imgFilePath']) :null);
  }
}
