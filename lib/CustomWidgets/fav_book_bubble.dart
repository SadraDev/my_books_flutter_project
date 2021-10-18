import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore instance = FirebaseFirestore.instance;

class FavBookBubble extends StatelessWidget {
  const FavBookBubble({
    Key? key,
    required this.networkImage,
    required this.rating,
    required this.onTap,
    required this.onPressed,
  }) : super(key: key);

  final String networkImage;
  final String rating;
  final void Function() onTap;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GestureDetector(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 100,
                color: Colors.black26,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 200,
                  width: 125,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        networkImage,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(rating),
                      ],
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: onPressed,
                      icon: const Icon(Icons.bookmark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
