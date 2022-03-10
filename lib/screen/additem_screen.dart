import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_auth_db/model/user_model.dart';
import 'package:flutter_auth_db/screen/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddScreen extends StatefulWidget {
  AddScreen({Key? key, this.userId}) : super(key: key);

  // Need user id for create folder
  String? userId;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  //
  File? _image;
  final imagePicker = ImagePicker();

  final nameDes = TextEditingController();
  final _formkey1 = GlobalKey<FormState>();

  // image picker
  Future imagePickerMethod() async {
    // picker file
    final pickiImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickiImage != null) {
        _image = File(pickiImage.path);
      } else {
        showSnackBar("No file selected", const Duration(milliseconds: 400));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additem'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                height: 500,
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Upload Your Data',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.blue)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _image == null
                                    ? const Center(
                                        child: Text('No image selected'))
                                    : Image.file(_image!),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Form(
                                key: _formkey1,
                                child: TextFormField(
                                  controller: nameDes,
                                  decoration: const InputDecoration(
                                    label: Text('Name *'),
                                  ),
                                  validator: (V) {
                                    if (V!.isEmpty) {
                                      return 'Plaese Enter';
                                    }
                                    return null;
                                  },
                                  onSaved: (V) {
                                    nameDes.text = V!;
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    imagePickerMethod();
                                  },
                                  child: const Text('Select Image')),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_image != null &&
                                        _formkey1.currentState!.validate()) {
                                      showSnackBar('Wait few a minute',
                                          const Duration(milliseconds: 400));
                                      uploadData()
                                          .whenComplete(() => showSnackBar(
                                                "Uploaded Successfully",
                                                const Duration(seconds: 2),
                                              ))
                                          .then((value) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen())));
                                    } else if (_image != null ||
                                        _formkey1.currentState!.validate()) {
                                      showSnackBar("Select Image OR Enter Name",
                                          const Duration(milliseconds: 400));
                                    }
                                  },
                                  child: const Text('Upload Your data'))
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ShowSnackBar
  showSnackBar(String snackText, Duration b) {
    final snackBar = SnackBar(content: Text(snackText), duration: b);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Upload Image to Stroage
  Future uploadData() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.userId}/images")
        .child("post_$postID");

    await ref.putFile(_image!);
    var downloadURL = await ref.getDownloadURL();
    //print(downloadURL);

    // Update to cloude_firebase
    await firebaseFirestore
        .collection("users")
        .doc(widget.userId)
        .collection('images')
        .add({'downloadURL': downloadURL,'Des':nameDes.text});

  }
}
