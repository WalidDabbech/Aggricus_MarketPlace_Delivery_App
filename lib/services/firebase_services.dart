

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {


  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot>validateUser(id)async{
    DocumentSnapshot result = await boys.doc(id).get();
    return result;
  }

  Future <DocumentSnapshot> getUserDetails(id)async{
    final DocumentSnapshot doc = await users.doc(id).get();
    return doc ;
  }

  Future<void>updateStatus({id,status}){
    return orders.doc(id).update({
      'orderStatus' : status,
    });
  }

}