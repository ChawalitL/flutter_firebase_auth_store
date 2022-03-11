import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_db/screen/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';

class DetialScreen extends StatefulWidget {
  DetialScreen({Key? key, this.ds, this.userID, this.imageID, this.nameDes})
      : super(key: key);

  String? imageID;
  String? nameDes;
  String? userID;
  String? ds;

  @override
  State<DetialScreen> createState() => _DetialScreenState();
}

class _DetialScreenState extends State<DetialScreen> {
  //
  final changeName = TextEditingController();
  final keyT = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.nameDes}",
        style: TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color.fromARGB(255, 0, 136, 248),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 30),
            icon: const Icon(
              Icons.delete_forever,
              size: 40,
              color: Colors.red,
            ),
            onPressed: () {
              deleteItem();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${widget.nameDes}",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 30),
                  Image.network(
                    "${widget.imageID}",
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return dialogEdit();
                            });
                      },
                      child: const Text('Edit'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deleteItem() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('DELETE!!!'),
              content: const Text('You want to Delete This Item?'),
              actions: [
                TextButton(
                    onPressed: () {
                      print("${widget.userID}");
                      print(widget.ds);
                      print(widget.imageID);
                      print(widget.nameDes);
                      Navigator.pop(context);
                    },
                    child: const Text('Cancle')),
                TextButton(
                    onPressed: () async {
                      await delete(widget.ds.toString())
                          .whenComplete(() => showSnackBar(
                              'Delete Successfully',
                              const Duration(milliseconds: 400)))
                          .then((value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen())));
                    },
                    child: const Text('Yes'))
              ],
            ));
  }

  Future<void> delete(String a) async {
    FirebaseFirestore A = FirebaseFirestore.instance;

    await A
        .collection("users")
        .doc(widget.userID)
        .collection("images")
        .doc(a)
        .delete()
        .then((value) => print("DELETED"));
  }

  showSnackBar(String snackText, Duration b) {
    final snackBar = SnackBar(content: Text(snackText), duration: b);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  dialogEdit() {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'Update Name',
        style: TextStyle(fontSize: 15),
      ),
      content: TextFormField(
        key: keyT,
        controller: changeName,
        decoration: const InputDecoration(
            hintText: 'Enter name', prefixIcon: Icon(Icons.file_open)),
        textInputAction: TextInputAction.done,
        onSaved: (String? va) {
          changeName.text = va!;
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              changeName.text = '';
              Navigator.pop(context);
            },
            child: const Text('No')),
        TextButton(
            onPressed: () async {
              await update(widget.ds.toString(), changeName.text)
                  .whenComplete(() => showSnackBar(
                      'Update Successfully', const Duration(milliseconds: 400)))
                  .then((value) => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen())));
            },
            child: const Text('Yes')),
      ],
    );
  }

  Future<void> update(String a, String b) async {
    FirebaseFirestore A = FirebaseFirestore.instance;

    await A
        .collection("users")
        .doc(widget.userID)
        .collection("images")
        .doc(a)
        .update({'Des': b}).then((value) => print("Update"));
  }
}
