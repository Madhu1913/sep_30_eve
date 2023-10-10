import 'package:flutter/material.dart';

import 'package:sep_30_eve/Contatc_add.dart';
import 'package:sep_30_eve/main.dart';


import 'contacts_model.dart';
class ContactEdit extends StatelessWidget {
  final Contact editedContact;


  const ContactEdit({required this.editedContact,

    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: ContactText(editedContact: editedContact,),
    );
  }
}
