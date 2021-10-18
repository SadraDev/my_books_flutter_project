import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BooksBubble extends StatelessWidget {
  const BooksBubble({
    Key? key,
    required this.networkImage,
    required this.authorName,
    required this.bookName,
    required this.category,
    required this.onTap,
    required this.rating,
  }) : super(key: key);

  final String networkImage;
  final String authorName;
  final String bookName;
  final String category;
  final String rating;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
      child: GestureDetector(
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: Offset(4, 4),
                blurRadius: 100,
                color: Colors.black26,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 24),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          'by ' + authorName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          bookName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow[600]),
                            const SizedBox(width: 8),
                            Text(
                              rating,
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    category,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
