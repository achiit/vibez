// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_twitter_clone/helper/constant.dart';
// import 'package:flutter_twitter_clone/helper/enum.dart';
// import 'package:flutter_twitter_clone/helper/utility.dart';
// import 'package:flutter_twitter_clone/model/user.dart';
// import 'package:flutter_twitter_clone/state/authState.dart';
// import 'package:flutter_twitter_clone/widgets/customFlatButton.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class QRScanPage extends StatefulWidget {
//   @override
//   _QRScanPageState createState() => _QRScanPageState();
// }

// class _QRScanPageState extends State<QRScanPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Scanner'),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           _buildQrView(context),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: TextButton(
//               onPressed: () {
//                 // Add functionality to close QR scanner
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Close',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.green,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: MediaQuery.of(context).size.width * 0.8,
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) async {
//       // Store scanned data in local storage
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('scannedData', scanData.code!);

//       // Navigate to a new page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ScannedDataPage(),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

// class ScannedDataPage extends StatefulWidget {
//   @override
//   _ScannedDataPageState createState() => _ScannedDataPageState();
// }

// class _ScannedDataPageState extends State<ScannedDataPage> {
//   String? scannedData;

//   @override
//   void initState() {
//     _nameController = TextEditingController();
//     super.initState();
//     _getScannedData();
//   }

//   Future<void> _getScannedData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       scannedData = prefs.getString('scannedData');
//     });
//   }

//   void _loginWithAnonAadhar() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? scannedData = prefs.getString('scannedData');

//     if (scannedData != null) {
//       // Extract address from scanned data
//       Map<String, dynamic> data = jsonDecode(scannedData);
//       String address = data['address'];

//       // Create email address
//       String emailAddress = address.replaceAll(' ', '') + '@gmail.com';

//       // Sign up with email and default password
//       _signupWithEmail(emailAddress, '12345678');
//     }
//   }

//   void _signupWithEmail(String email, String password) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       // If successful, print the user ID
//       print('Successfully signed up user: ${userCredential.user!.uid}');
//       // You can do additional operations here after successful signup
//     } catch (e) {
//       // Handle signup errors here
//       print('Error signing up: $e');
//     }
//   }

//   Widget _entryField(String hint,
//       {required TextEditingController controller,
//       bool isPassword = false,
//       bool isEmail = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
//         style: const TextStyle(
//           fontStyle: FontStyle.normal,
//           fontWeight: FontWeight.normal,
//         ),
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           hintText: hint,
//           border: InputBorder.none,
//           focusedBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(30.0),
//             ),
//             borderSide: BorderSide(color: Colors.blue),
//           ),
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         ),
//       ),
//     );
//   }

//   TextEditingController _nameController = TextEditingController();
//   void _submitForm(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? scannedData = prefs.getString('scannedData');

//     if (scannedData != null) {
//       // Extract address from scanned data
//       Map<String, dynamic> data = jsonDecode(scannedData);
//       String address = data['address'];

//       // Create email address
//       String emailAddress = address.replaceAll(' ', '') + '@gmail.com';
//       if (_nameController.text.isEmpty) {
//         Utility.customSnackBar(context, 'Please enter name');
//         return;
//       }
//       if (_nameController.text.length > 27) {
//         Utility.customSnackBar(
//             context, 'Name length cannot exceed 27 character');
//         return;
//       }
//       // if (emailAddress) {
//       //   Utility.customSnackBar(context, 'Please fill form carefully');
//       //   return;
//       // }

//       //loader.showLoader(context);
//       var state = Provider.of<AuthState>(context, listen: false);
//       Random random = Random();
//       int randomNumber = random.nextInt(8);

//       UserModel user = UserModel(
//         email: emailAddress,
//         bio: 'Edit profile to update bio',
//         // contact:  _mobileController.text,
//         displayName: _nameController.text,
//         dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
//             .toString(),
//         location: 'Somewhere in universe',
//         profilePic: Constants.dummyProfilePicList[randomNumber],
//         isVerified: false,
//       );
//       state
//           .signUp(
//         user,
//         password: '12345678',
//         context: context,
//       )
//           .then((status) {
//         print(status);
//       }).whenComplete(
//         () {
//           //loader.hideLoader();
//           if (state.authStatus == AuthStatus.LOGGED_IN) {
//             Navigator.pop(context);
//             // if (widget.loginCallback != null) widget.loginCallback!();
//           }
//         },
//       );
//     }
//     final _formKey = GlobalKey<FormState>();
//     Widget _submitButton(BuildContext context) {
//       return Container(
//         margin: const EdgeInsets.symmetric(vertical: 35),
//         child: CustomFlatButton(
//           label: "Sign up",
//           onPressed: () => _submitForm(context),
//           borderRadius: 30,
//         ),
//       );
//     }

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Scanned Data'),
//         ),
//         body: Column(
//           children: [
//             Center(
//               child: scannedData != null
//                   ? Text(scannedData!)
//                   : CircularProgressIndicator(),
//             ),
//             _entryField('Name', controller: _nameController),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 50.0),
//                 child: ElevatedButton(
//                   onPressed: _loginWithAnonAadhar,
//                   child: Text('Login with Anon Aadhar'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'QR Scanner',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: QRScanPage(),
// //     );
// //   }
// // }

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/helper/enum.dart';
import 'package:flutter_twitter_clone/helper/utility.dart';
import 'package:flutter_twitter_clone/model/user.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/widgets/customFlatButton.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildQrView(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                // Add functionality to close QR scanner
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Store scanned data in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('scannedData', scanData.code!);

      // Navigate to a new page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScannedDataPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ScannedDataPage extends StatefulWidget {
  @override
  _ScannedDataPageState createState() => _ScannedDataPageState();
}

class _ScannedDataPageState extends State<ScannedDataPage> {
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getScannedData();
  }

  Future<void> _getScannedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      scannedData = prefs.getString('scannedData');
    });
  }

  String? scannedData;

  void _loginWithAnonAadhar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scannedData = prefs.getString('scannedData');

    if (scannedData != null) {
      // Extract address from scanned data
      Map<String, dynamic> data = jsonDecode(scannedData);
      String address = data['address'];

      // Create email address
      String emailAddress = address.replaceAll(' ', '') + '@gmail.com';

      // Sign up with email and default password
      _signupWithEmail(emailAddress, '12345678');
    }
  }

  void _signupWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // If successful, print the user ID
      print('Successfully signed up user: ${userCredential.user!.uid}');
      // You can do additional operations here after successful signup
    } catch (e) {
      // Handle signup errors here
      print('Error signing up: $e');
    }
  }

  void _submitForm(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scannedData = prefs.getString('scannedData');

    if (scannedData != null) {
      // Extract address from scanned data
      Map<String, dynamic> data = jsonDecode(scannedData);
      String address = data['address'];

      // Create email address
      String emailAddress = address.replaceAll(' ', '') + '@gmail.com';
      if (_nameController.text.isEmpty) {
        Utility.customSnackBar(context, 'Please enter name');
        return;
      }
      if (_nameController.text.length > 27) {
        Utility.customSnackBar(
            context, 'Name length cannot exceed 27 character');
        return;
      }

      var state = Provider.of<AuthState>(context, listen: false);
      Random random = Random();
      int randomNumber = random.nextInt(8);

      UserModel user = UserModel(
        email: emailAddress,
        bio: 'Edit profile to update bio',
        displayName: _nameController.text,
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
        location: 'Somewhere in universe',
        profilePic: Constants.dummyProfilePicList[randomNumber],
        isVerified: false,
      );
      state
          .signUp(
        user,
        password: '12345678',
        context: context,
      )
          .then((status) {
        print(status);
      }).whenComplete(
        () {
          if (state.authStatus == AuthStatus.LOGGED_IN) {
            Navigator.pop(context);
          }
        },
      );
    }
  }

  Widget _entryField(String hint,
      {required TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Data'),
      ),
      body: Column(
        children: [
          Center(
            child: scannedData != null
                ? Text(scannedData!)
                : CircularProgressIndicator(),
          ),
          _entryField('Name', controller: _nameController),
          _submitButton(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                onPressed: _loginWithAnonAadhar,
                child: Text('Login with Anon Aadhar'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: "Sign up",
        onPressed: () => _submitForm(context),
        borderRadius: 30,
      ),
    );
  }
}
