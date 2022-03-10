import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_db/model/user_model.dart';
import 'package:flutter_auth_db/screen/welcome_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //
  final _auth = FirebaseAuth.instance;

  //our form key
  final _formkey = GlobalKey<FormState>();
  //Controller
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //form for Register
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameController,
      keyboardType: TextInputType.name,
      validator: (V) {
        RegExp regex = RegExp(r"^.{3,}$");
        if (V!.isEmpty) {
          return 'First Name is cannot Empty';
        }
        if (!regex.hasMatch(V)) {
          return 'Please Enter Valid Password(Min. 3 Character)';
        }
        return null;
      },
      onSaved: (value) {
        firstNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'FirstName',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameController,
      keyboardType: TextInputType.name,
      validator: (V) {
        if (V!.isEmpty) {
          return 'Last Name is cannot Empty';
        }
        return null;
      },
      onSaved: (value) {
        lastNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'LastName',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (V) {
        if (V!.isEmpty) {
          return "Please Enter Your Email";
        }
        // Reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(V)) {
          return "Please Enter valid Email";
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      validator: (V) {
        RegExp regex = RegExp(r"^.{6,}$");
        if (V!.isEmpty) {
          return 'Password is required for login';
        }
        if (!regex.hasMatch(V)) {
          return 'Please Enter Valid Password(Min. 6 Character)';
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: confirmPasswordNameController,
      validator: (V) {
        if (V!.isEmpty) {
          return 'Please Enter';
        }
        if (passwordController.text != confirmPasswordNameController.text) {
          return 'Password dont Match';
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordNameController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'ConfirmPassword',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final signButtonField = Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          child: const Text(
            'SignUp',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          onPressed: () {
            signUp(emailController.text, passwordController.text);
          },
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 170,
                      child: Image.asset(
                        "assets/Login.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 45),
                    firstNameField,
                    const SizedBox(height: 20),
                    lastNameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 35),
                    signButtonField,
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////
  void signUp(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          postDetailToFirestore();
        });
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: e.code);
      }

      /*await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
              postDetailToFirestore()
              })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });*/

    }
  }

  postDetailToFirestore() async {
    // calling our firebase
    // calling our userModel
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstname = firstNameController.text;
    userModel.lastname = lastNameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created Successfully :");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
///////////////////////////////////////////////////////////////////////////

}
