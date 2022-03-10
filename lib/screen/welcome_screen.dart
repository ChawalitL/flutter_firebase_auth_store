import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_db/model/user_model.dart';
import 'package:flutter_auth_db/screen/additem_screen.dart';
import 'package:flutter_auth_db/screen/detail_screen.dart';
import 'package:flutter_auth_db/screen/home.dart';

class HomeScreen extends StatefulWidget {
  String? userId;

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // AlertLogout
    final alertLogout = IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Logout!!!'),
                  content: const Text('You want to Logout?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancle')),
                    TextButton(
                        onPressed: () {
                          logout(context);
                        },
                        child: const Text('Yes'))
                  ],
                ));
      },
    );
    // Additem
    final addItem = IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddScreen(userId: loggedInUser.uid)));
        },
        icon: const Icon(Icons.add));

    return Scaffold(
      appBar: AppBar(
        title: Text('${loggedInUser.firstname}'),
        leading: const Icon(Icons.person_pin),
        actions: [addItem, alertLogout],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(loggedInUser.uid)
              .collection("images")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            /*if (!snapshot.hasData == false) {
              return const Center(
                child: Text('No Data',style: TextStyle(fontSize: 30),),
              );
            } */

            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No Data',
                  style: TextStyle(fontSize: 30),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index1) {
                    String url = snapshot.data!.docs[index1]['downloadURL'];
                    String nameDes = snapshot.data!.docs[index1]['Des'];
                    QueryDocumentSnapshot dss = snapshot.data!.docs[index1];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Container(
                        width: 100,
                        height: 220,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.blue)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: InkWell(
                            onTap: () {
                              toDetail(url, nameDes, dss.id,
                                  loggedInUser.uid.toString());
                              /*print(dss.id);
                              print(loggedInUser.uid);
                              print(snapshot.hasData);*/
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Name : $nameDes",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Image.network(
                                  url,
                                  height: 150,
                                  fit: BoxFit.fill,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  }

  toDetail(String a, String b, String ds, String uid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetialScreen(
                  userID: uid,
                  imageID: a,
                  nameDes: b,
                  ds: ds,
                )));
  }
}
