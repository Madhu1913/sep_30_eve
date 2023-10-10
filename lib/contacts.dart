import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sep_30_eve/Contatcs_edit_page.dart';
import 'package:sep_30_eve/contacts_model.dart';
import 'package:sep_30_eve/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTile extends StatelessWidget {
  final int contactIndex;
  const ContactTile({required this.contactIndex, super.key});
  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<contatacsModel>(context);
    final displayedContact = model.contacts![contactIndex];
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 2,
            onPressed: (context) => model.deleteContact(displayedContact),
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) =>
                _callPhoneNumber(context, displayedContact.phoneNumber),
            icon: Icons.phone,
            label: 'Call',
            backgroundColor: Colors.green,
          ),
          SlidableAction(
            onPressed: (context) =>
                _writeEmail(context, displayedContact.email),
            icon: Icons.mail,
            label: 'email',
            backgroundColor: Colors.yellow,
          ),
        ],
      ),
      child: _buildContent(context, displayedContact, model),
    );
  }

  Future _callPhoneNumber(BuildContext context,String number) async {
    final Uri url=Uri(
      scheme: 'tel',
      path: number,
    );
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      final snackBar = SnackBar(content: Text('Cannot make a call'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future _writeEmail(BuildContext context,String emailAddress) async {
    final Uri url=Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      final snackBar = SnackBar(content: Text('Cannot write an email'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Container _buildContent(
    BuildContext context,
    Contact displayedContact,
    contatacsModel model,
  ) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: ListTile(
        leading: Hero(
            tag: displayedContact.hashCode,
            child: CircleAvatar(
              child: _buildCircleAvatarContent(displayedContact),
            )),
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        trailing: IconButton(
          onPressed: () {
            model.changeFavouriteStatus(displayedContact);
          },
          icon: displayedContact.isFavourite
              ? Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              : Icon(
                  Icons.star_border,
                  color: Colors.grey,
                ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactEdit(
                        editedContact: displayedContact,
                      )));
        },
      ),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.imgFile == null) {
      return Text(displayedContact.name[0]);
    } else {
      return ClipOval(
        child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.file(
              File(displayedContact.imgFile!.path),
              fit: BoxFit.fill,
            )),
      );
    }
  }
}
