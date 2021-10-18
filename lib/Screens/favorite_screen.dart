// @dart=2.9
import 'package:appandup_bookshelf/CustomWidgets/fav_book_bubble.dart';
import 'package:appandup_bookshelf/Screens/single_detailed_book_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

User currentUser = FirebaseAuth.instance.currentUser;
FirebaseFirestore instance = FirebaseFirestore.instance;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key key}) : super(key: key);

  static const String id = 'favorite_screen';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection(currentUser.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Your favorites',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          iconSize: 30,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(100),
                child: Center(
                    child: CircularProgressIndicator(color: Colors.grey)),
              );
            } else if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(100),
                child: Center(child: Text('Something went wrong')),
              );
            } else if (snapshot.hasData) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                ),
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return FavBookBubble(
                    networkImage: data['cover'].toString(),
                    rating: data['rating'].toString(),
                    onPressed: () {
                      instance
                          .collection(currentUser.uid)
                          .doc(document.id)
                          .delete();
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleBookScreen(
                            selfLink: data['selfLink'],
                            description: data['description'],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            }
          } catch (e) {
            return const Padding(
              padding: EdgeInsets.all(100),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(100),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
