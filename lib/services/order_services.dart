

import 'package:aggricus_delivery_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  FirebaseServices _services = FirebaseServices();
  Color ? statusColor ( document) {
    if (document['orderStatus']=='Accepted'){
      return Colors.blueGrey[400];
    }
    if (document['orderStatus']=='Rejected'){
      return Colors.red;
    }
    if (document['orderStatus']=='Picked Up'){
      return Colors.pink[900];
    }
    if (document['orderStatus']=='On the way'){
      return Colors.purple[900];
    }
    if (document['orderStatus']=='Delivered'){
      return Colors.green;
    }
    return Colors.orange;

  }

  Icon ?  statusIcon ( document) {
    if (document['orderStatus']=='Accepted'){
      return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);
    }

    if (document['orderStatus']=='Picked Up'){
      return Icon(Icons.cases,color: statusColor(document),);
    }
    if (document['orderStatus']=='On the way'){
      return Icon(Icons.delivery_dining,color: statusColor(document),);
    }
    if (document['orderStatus']=='Delivered'){
      return Icon(Icons.shopping_bag_outlined,color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined,color: statusColor(document),);

  }

  showMyDialog(title,status,documentId,context){
    final OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
        context : context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text('Make Sure You Have Received Payment'),
            actions: [
              TextButton(
                onPressed: (){
                  EasyLoading.show();
                  _services.updateStatus(id:documentId,status: 'Delivered').then((value) {
                    EasyLoading.showSuccess('Order status is now Delivered').then((value){
                      Navigator.pop(context);
                    });
                  });
                },
                child : Text ('RECEIVE',
                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child : Text ('Cancel',
                  style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),),
              )
            ],


          );
        }
    );
  }

  Widget statusContainer( document, context){
    if(document['deliveryBoy']['name'].length>1) {
      if (document['orderStatus']=='Accepted'){
        return  Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40,8,40,8),
            child: TextButton(
                style: TextButton.styleFrom(backgroundColor: statusColor(document),),
                onPressed: () {
                  EasyLoading.show();
                  _services.updateStatus(id:document.id,status: 'Picked Up').then((value) {
                    EasyLoading.showSuccess('Order status is now Picked Up');
                  });
                }, child: Text('Pick Up',style: TextStyle(color: Colors.white),)),
          ),
        );
      }
    }
    if (document['orderStatus']=='Picked Up'){
      return  Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40,8,40,8),
          child: TextButton(
              style: TextButton.styleFrom(backgroundColor: statusColor(document),),
              onPressed: () {
                EasyLoading.show();
                _services.updateStatus(id:document.id,status: 'On the way').then((value) {
                  EasyLoading.showSuccess('Order status is now On the way');
                });
              }, child: Text('On the way',style: TextStyle(color: Colors.white),)),
        ),
      );
    }
    if (document['orderStatus']=='On the way'){
      return  Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40,8,40,8),
          child: TextButton(
              style: TextButton.styleFrom(backgroundColor: statusColor(document),),
              onPressed: () {
               if (document['cod'] == true ){
                 return showMyDialog('Receive Payment','Delivered',document.id,context);
               }
                EasyLoading.show();
                _services.updateStatus(id:document.id,status: 'Delivered').then((value) {
                  EasyLoading.showSuccess('Order status is now Delivered');
                });
              }, child: Text('Deliver Order',style: TextStyle(color: Colors.white),)),
        ),
      );
    }
    if (document['orderStatus']=='Delivered'){
      return  Container(
        color: Colors.grey[300],
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
            style: TextButton.styleFrom(backgroundColor: statusColor(document),),
            onPressed: () {
            }, child: Text('Order Completed',style: TextStyle(color: Colors.white),)),
      );
    }

    return Container(
      color: Colors.grey[300],
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey,),
                  onPressed: () {
                    showMyDialog('Accept Order','Accepted',document.id,context);
                  }, child: Text('Accept',style: TextStyle(color: Colors.white),)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AbsorbPointer(
                absorbing: document['orderStatus'] == 'Rejected' ? true : false ,
                child: TextButton(
                    style: TextButton.styleFrom(backgroundColor:document['orderStatus'] == 'Rejected' ? Colors.grey : Colors.red,),
                    onPressed: () {
                      showMyDialog('Reject Order','Rejected',document.id,context);
                    }, child: Text('Reject',style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),
        ],
      ),
    );

  }


  void launchCall(number) async =>
      await canLaunch(number) ? await launch(number) : throw 'Could not launch $number';

  void launchMap(latitude , longitude ,name)async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(latitude,longitude),
      title: name,
    );
  }

}