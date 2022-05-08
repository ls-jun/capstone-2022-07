// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Color/Color.dart';


AppBar StockscreenBar(BuildContext context, String title, String stockName) {
  return AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.black),
    ),
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
    actions: [FavoriteButton(stockName)],
    leadingWidth: 70,
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  );
}


class FavoriteButton extends StatefulWidget implements PreferredSizeWidget {

  FavoriteButton(this.stockName) : preferredSize = Size.fromHeight(60.0), super();
  final Size preferredSize;
  final String stockName;

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}
class _FavoriteButtonState extends State<FavoriteButton> {

    late bool IsFavorite;
    Future Isstockfavorite() async {
    var user = await FirebaseFirestore.instance.collection('users')
        .doc(await FirebaseAuth.instance.currentUser!.uid).get();
    List<dynamic> favoritelist = user['favorite'];
    if(favoritelist.contains(widget.stockName)){
      IsFavorite = true;
    }else{
      IsFavorite = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Isstockfavorite(),
    builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            IconData favorite;
            if(IsFavorite == true){
              favorite = Icons.star;
            }else{
              favorite = Icons.star_outline;
            }
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    IsFavorite = !IsFavorite;
                  });
                  if (IsFavorite == false) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth
                        .instance.currentUser!.uid)
                        .update({
                      "favorite": FieldValue.arrayRemove(
                          [widget.stockName])
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth
                        .instance.currentUser!.uid)
                        .update({
                      "favorite": FieldValue.arrayUnion(
                          [widget.stockName])
                    });
                  }
                },
                child : Icon(
                  favorite,
                  color : CHART_MINUS,
                ),
              );
          }else{
            return Container();
          }
    }
    );
  }
}