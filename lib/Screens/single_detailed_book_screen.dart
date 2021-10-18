// @dart=2.9
import 'package:appandup_bookshelf/Screens/webview_screen.dart';
import 'package:appandup_bookshelf/networking/google_books_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../constants.dart';

User currentUser = FirebaseAuth.instance.currentUser;
FirebaseFirestore instance = FirebaseFirestore.instance;

class SingleBookScreen extends StatefulWidget {
  const SingleBookScreen(
      {Key key, @required this.selfLink, @required this.description})
      : super(key: key);
  final String selfLink;
  final String description;

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<SingleBookScreen> {
  bool marked = false;
  String cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Network(widget.selfLink).getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(100),
              child:
                  Center(child: CircularProgressIndicator(color: Colors.grey)),
            );
          } else if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.all(100),
              child: Center(child: Text('Something went wrong')),
            );
          } else if (snapshot.hasData) {
            var bookImage = snapshot.data['volumeInfo']['imageLinks'];
            var bookInfo = snapshot.data['volumeInfo'];

            if (bookImage['medium'] == null) {
              cover = bookImage['thumbnail'].toString();
            } else if (bookImage['medium'] != null) {
              cover = bookImage['medium'].toString();
            }

            List getAuthors() {
              List<Widget> authors = [];
              try {
                for (int i = 0; i < bookInfo['authors'].length; i++) {
                  String author = bookInfo['authors'][i];
                  final newAuthor = Text(
                    author,
                    softWrap: true,
                  );
                  authors.add(newAuthor);
                }
                return authors;
              } catch (e) {
                return authors;
              }
            }

            List getCategories() {
              List<Widget> categories = [];
              try {
                for (int i = 0; i < bookInfo['categories'].length; i++) {
                  String category = bookInfo['categories'][i];
                  final newAuthor = Text(
                    category,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  );
                  categories.add(newAuthor);
                }
                return categories;
              } catch (e) {
                return categories;
              }
            }

            return BuildFuture(
              title: bookInfo['title'],
              cover: cover,
              description: widget.description,
              author: getAuthors(),
              categories: getCategories(),
              language: bookInfo['language'],
              pageCount: bookInfo['pageCount'],
              publisher: bookInfo['publisher'],
              published: bookInfo['publishedDate'],
              marked: marked,
              onPressed: () {
                setState(() {
                  marked = !marked;
                  if (marked) {
                    instance
                        .collection(currentUser.uid)
                        .doc(snapshot.data['id'])
                        .set({
                      'rating': bookInfo['averageRating'] ?? 'not rated',
                      'cover': cover,
                      'selfLink': widget.selfLink,
                      'description': widget.description,
                    });
                  } else if (!marked) {
                    instance
                        .collection(currentUser.uid)
                        .doc(snapshot.data['id'])
                        .delete();
                  }
                });
              },
              webReaderOnPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      url: snapshot.data['accessInfo']['webReaderLink'],
                    ),
                  ),
                );
              },
              pagePreviewOnPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      url: bookInfo['infoLink'],
                    ),
                  ),
                );
              },
            );
          }
          return const Text('');
        },
      ),
    );
  }
}

class BuildFuture extends StatelessWidget {
  const BuildFuture({
    Key key,
    this.onPressed,
    this.marked,
    this.title,
    this.cover,
    this.description,
    this.author,
    this.publisher,
    this.published,
    this.pageCount,
    this.categories,
    this.language,
    this.webReaderOnPressed,
    this.pagePreviewOnPressed,
  }) : super(key: key);

  final void Function() onPressed;
  final void Function() webReaderOnPressed;
  final void Function() pagePreviewOnPressed;
  final bool marked;
  final String title;
  final String cover;
  final String description;
  final List<Widget> author;
  final String publisher;
  final String published;
  final int pageCount;
  final List<Widget> categories;
  final String language;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 40,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
                child: Text(
                  title ?? 'unknown title',
                  style: style,
                ),
              ),
            )
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              image: NetworkImage(cover),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Column(
          children: [
            ListTile(
              dense: true,
              leading: const Text('description : '),
              title: Text(
                description ?? 'No description found',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
            ListTile(
              minLeadingWidth: 70,
              dense: true,
              leading: const Text('author : '),
              title: Column(
                children: author ?? 'unknown author',
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            ListTile(
              minLeadingWidth: 70,
              dense: true,
              leading: const Text('publisher : '),
              title: Text(publisher ?? 'unknown publisher'),
            ),
            ListTile(
              minLeadingWidth: 70,
              dense: true,
              leading: const Text('published : '),
              title: Text(published ?? 'published date unknown'),
            ),
            ListTile(
              minLeadingWidth: 70,
              dense: true,
              leading: const Text('page count : '),
              title: Text('$pageCount' ?? 'page count unknown'),
            ),
            ListTile(
              minLeadingWidth: 70,
              dense: true,
              leading: const Text('categories : '),
              title: Column(
                children: categories,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            ListTile(
              minLeadingWidth: 70,
              dense: true,
              leading: const Text('language : '),
              title: Text(language ?? 'unknown language'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      marked ? Icons.bookmark : Icons.bookmark_outline,
                    ),
                  ),
                  IconButton(
                    onPressed: webReaderOnPressed,
                    icon: const Icon(Icons.read_more),
                  ),
                  IconButton(
                    onPressed: pagePreviewOnPressed,
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
