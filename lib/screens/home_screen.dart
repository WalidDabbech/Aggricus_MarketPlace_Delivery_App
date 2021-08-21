import 'package:aggricus_delivery_app/screens/login_screen.dart';
import 'package:aggricus_delivery_app/services/firebase_services.dart';
import 'package:aggricus_delivery_app/widgets/order_summary_card.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  static const String id='home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User ? user = FirebaseAuth.instance.currentUser;
  FirebaseServices _services = FirebaseServices();
  String ? status;
  int tag = 0;
  List<String> options = [
    'All', 'Accepted', 'Picked Up',
    'On the way', 'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Orders',style: TextStyle(color: Colors.white),),centerTitle: true,),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
      body:Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: C2ChoiceStyle(borderRadius:
              BorderRadius.all(Radius.circular(3))),
              value: tag,
              onChanged: (val) {
                if (val==0){
                  setState(() {
                    status = null ;
                  });
                }
                setState(() {
                  tag = val;
                  if (tag>0) {
                   status=options[val];
                  }
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.orders.where('deliveryBoy.email',isEqualTo: user!.email).where('orderStatus',isEqualTo: status).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.data!.size==0){
                  return Center (child:Text('No $status Orders'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }

                return Expanded(
                  child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
                        child: OrderSummaryCard(document),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
