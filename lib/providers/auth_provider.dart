


import 'package:aggricus_delivery_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';


class AuthProvider extends ChangeNotifier{
  XFile? image;
  bool isPicAvail=false;
  String pickerError='';
  String error='';

//shop data
  double ? shopLatitude;
  double ? shopLongitude;
  String ? shopAddress;
  String ? placeName;
  String email='';
  CollectionReference _boys =  FirebaseFirestore.instance.collection('boys');


  getEmail(email){
    this.email = email;
    notifyListeners();
  }



  Future<XFile?> getImage() async{
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
    if (pickedFile != null){
      this.image = XFile(pickedFile.path);
      notifyListeners();
    }
    else {
      this.pickerError='No image selected.';
      print(pickerError);
      notifyListeners();
    }
    return this.image;
  }

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    this.shopLatitude=_locationData.latitude;
    this.shopLongitude=_locationData.longitude;
    notifyListeners();
    final coordinates = new Coordinates(_locationData.latitude, _locationData.longitude);
    var _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine;
    this.placeName = shopAddress.featureName;
    notifyListeners();
    return shopAddress;
  }

  Future<UserCredential?> registerBoy(email,password)async{
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error='The password provided is too weak.';
        notifyListeners();
        print(this.error);
      } else if (e.code == 'email-already-in-use') {
        this.error='The account already exists for that email.';
        notifyListeners();
        print(this.error);
      }
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;

  }

  Future<UserCredential?> loginBoy(email,password)async{
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      this.error=e.code;
      notifyListeners();
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;

  }

  Future<void> resetPassword(email)async{
    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error=e.code;
      notifyListeners();
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<void>saveBoyDataToDb(
      {required String url, required String name, required String mobile, required String password, context})async
  {
    User? user =FirebaseAuth.instance.currentUser;
    _boys.doc(this.email).update({
      'uid':user!.uid,
      'name':name,
      'password':password,
      'mobile':mobile,
      'address':'${this.placeName}:${this.shopAddress}',
      'location':GeoPoint(this.shopLatitude!.toDouble(),this.shopLongitude!.toDouble()),
      'imageUrl' :url,
      'accVerified':false,
    }).whenComplete(() {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    });
    return null;

  }


}