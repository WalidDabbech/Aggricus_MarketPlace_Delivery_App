import 'dart:io';


import 'package:aggricus_delivery_app/providers/auth_provider.dart';
import 'package:aggricus_delivery_app/screens/home_screen.dart';
import 'package:aggricus_delivery_app/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cPasswordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _dialogTextController = TextEditingController();


  String email='';
  String password='';
  String mobile='';
  String name='';

  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage.ref('boyProfilePic/${_nameTextController.text}').putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('boyProfilePic/${_nameTextController.text}')
        .getDownloadURL();
    return downloadURL;
  }
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    setState(() {
      _emailTextController.text = _authData.email;
      email = _authData.email;
    });
    scaffoldMessage(message){
      return ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(content: Text(message)));

    }
    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ) :  Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Name';
                }
                setState(() {
                  _nameTextController.text=value;
                });
                setState(() {
                  name=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline,),
                labelText: 'Name',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength: 8,
              keyboardType: TextInputType.phone,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixText: '+216',
                prefixIcon: Icon(Icons.phone_android,),
                labelText: 'Mobile Number',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              enabled: false,
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Theme.of(context).primaryColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              controller: _passwordTextController,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Password';
                }
                if (value.length<6){
                  return 'Minimum 6 characters';
                }
                setState(() {
                  password=value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'New Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _cPasswordTextController,
              obscureText: true,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Confirm Password';
                }
                if (value.length<6){
                  return 'Minimum 6 characters';
                  }
                if (_cPasswordTextController.text!=_passwordTextController.text){
                  return 'Password dosen\'t match';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key_outlined),
                labelText: 'Confirm Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 5,
              controller: _addressTextController,
              cursorColor: Theme.of(context).primaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please press navigation Button';
                }
                if (_authData.shopLatitude==null){
                  'Please press navigation Button';
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.contact_mail_outlined),
                labelText: 'Business Location',
                suffixIcon: IconButton(onPressed: () {
                  _addressTextController.text='Locating...\n Please wait...';
                  _authData.getCurrentAddress().then((address) {
                      if(address!=null){
                        _addressTextController.text='${_authData.placeName}\n${_authData.shopAddress}';
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not find location ... Try again')));
                      }
                  });
                }, icon:Icon(Icons.location_searching,) ,),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children:[ Expanded(
              child: FlatButton(
                  color:Theme.of(context).primaryColor,
                  onPressed: () {
                    if(_authData.isPicAvail==true){
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading=true;
                        });
                        _authData.registerBoy(email, password).then((credential) {
                          if(credential!.user!.uid!=null){
                                uploadFile(_authData.image!.path).then((url) {
                                  if(url!=null){
                                    _authData.saveBoyDataToDb(url: url,
                                        name: name,
                                        mobile: mobile,
                                        password: password,
                                        context: context
                                       );
                                       setState(() {
                                      _isLoading=false;
                                      });
                                  }
                                  else {
                                    scaffoldMessage('Filed to upload shop Profile Pic');
                                  }
                                });
                          }
                          else {
                            scaffoldMessage(_authData.error);
                          }
                        });
                      }

                    }else {
                      scaffoldMessage('Shop Profile Pic need to be Added');

                    }

                  },
                  child: Text('Register',style: TextStyle(color: Colors.white),),
              ),
            ),
            ],
          ),
          Row(
            children: [
              FlatButton(
                padding:EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: RichText(text: TextSpan(
                    text:'',
                    children: [
                      TextSpan(text:'Already have an account ?'
                          ,style:TextStyle(color: Colors.black) ),
                      TextSpan(text:'Login'
                          ,style:(TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Colors.red
                          )) ),
                    ]
                ),
                ),),
            ],
          ),
        ],
      ),
    );
  }
}
