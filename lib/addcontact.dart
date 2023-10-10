import 'package:flutter/material.dart';

import 'package:sep_30_eve/Contatc_add.dart';


import 'contacts_model.dart';
class Contactform extends StatelessWidget {
  const Contactform({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: ContactText(),
    );
  }
}
