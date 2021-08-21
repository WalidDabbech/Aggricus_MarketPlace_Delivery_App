
import 'package:aggricus_delivery_app/providers/auth_provider.dart';
import 'package:aggricus_delivery_app/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id='reset-screen';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email='';
  bool _loading=false;



  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/forgot.png',height: 250,),
                SizedBox(height: 20,),
                RichText(text: TextSpan(
                  text: '',
                  children: [
                    TextSpan(text : 'Forgot Password ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                    TextSpan(text: 'Dont worry , provide us your registered email , we will send you an email to reset your password ',
                        style: TextStyle(color: Colors.red,fontSize: 12)),
                  ],
                ),),
                SizedBox(height: 10,),
                TextFormField(
                  controller: _emailTextController,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Enter Email';
                    }
                    final bool _isValid = EmailValidator.validate(_emailTextController.text);
                    if (!_isValid){
                      return 'Invalid Email Format';
                    }
                    setState(() {
                      email=value;
                    });
                    return null;
                  },
                  keyboardType:TextInputType.emailAddress,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor,
                      ),),

                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          onPressed:(){
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                _loading=true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('Check your Email ${_emailTextController.text} inbox for reset link')));
                            }
                            Navigator.pushReplacementNamed(context, LoginScreen.id);

                          },
                          child:  _loading ? LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            backgroundColor: Colors.transparent,
                          ):Text('Reset Password',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
                    )
                  ],
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}
