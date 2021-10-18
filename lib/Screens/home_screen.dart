// @dart=2.9
import 'package:appandup_bookshelf/CustomWidgets/book_bubble.dart';
import 'package:appandup_bookshelf/CustomWidgets/search_bar.dart';
import 'package:appandup_bookshelf/Screens/favorite_screen.dart';
import 'package:appandup_bookshelf/Screens/single_detailed_book_screen.dart';
import 'package:appandup_bookshelf/Screens/welcome_screen.dart';
import 'package:appandup_bookshelf/constants.dart';
import 'package:appandup_bookshelf/networking/google_books_api.dart';
import 'package:appandup_bookshelf/networking/log_in.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchedValue = 'Animal Farm';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 50.0, left: 40),
            sliver: MultiSliver(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          IconButton(
                            iconSize: 35,
                            icon: const Icon(Icons.bookmark_outline),
                            onPressed: () {
                              Navigator.pushNamed(context, FavoriteScreen.id);
                            },
                          ),
                          const Text(
                            'Liked books',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: <Widget>[
                          IconButton(
                            iconSize: 35,
                            icon: const Icon(Icons.logout_outlined),
                            onPressed: () {
                              final provider =
                                  Provider.of<LogIn>(context, listen: false);

                              Alert(
                                context: context,
                                title: "Log Out",
                                desc: "Are you sure you want to log out?",
                                buttons: [
                                  DialogButton(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                    color: Colors.green,
                                  ),
                                  DialogButton(
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      provider.logOut(context);
                                      Navigator.popAndPushNamed(
                                        context,
                                        WelcomeScreen.id,
                                      );
                                    },
                                    color: Colors.red,
                                  )
                                ],
                              ).show();
                            },
                          ),
                          const Text(
                            'Log Out !',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Explore thousands of', style: style),
                const Text('books on the go', style: style),
              ],
            ),
          ),
          SliverPinnedHeader(
            child: SearchBar(
              onChanged: (newValue) {
                searchedValue = newValue;
              },
              onPressed: () {
                setState(() {});
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(35).copyWith(bottom: 10),
            sliver: SliverToBoxAdapter(
              child: Text(searchedValue, style: style.copyWith(fontSize: 20)),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: Network(
                '$kGoogleBooksAPIForVolumes?q=$searchedValue&printType=books&key=$kApiKey',
              ).getData(),
              builder: (context, snapshot) {
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
                    List<BooksBubble> booksList = [];
                    var items = snapshot.data['items'];
                    String networkImage = '';
                    String authorName = 'No author found';
                    String bookName = 'untitled';
                    String category = 'unknown';
                    String rating = 'not rated';

                    for (int i = 0; i < items.length; i++) {
                      if (items[i]['volumeInfo']['imageLinks'] != null) {
                        networkImage = items[i]['volumeInfo']['imageLinks']
                                ['thumbnail']
                            .toString();
                      }

                      if (items[i]['volumeInfo']['authors'] != null) {
                        authorName =
                            items[i]['volumeInfo']['authors'][0].toString();
                      }

                      if (items[i]['volumeInfo']['title'] != null) {
                        bookName = items[i]['volumeInfo']['title'].toString();
                      }

                      if (items[i]['volumeInfo']['categories'] != null) {
                        category =
                            items[i]['volumeInfo']['categories'][0].toString();
                      }

                      if (items[i]['volumeInfo']['averageRating'] != null) {
                        rating =
                            items[i]['volumeInfo']['averageRating'].toString();
                      }

                      final newBook = BooksBubble(
                        category: category,
                        networkImage: networkImage,
                        authorName: authorName,
                        bookName: bookName,
                        rating: rating,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleBookScreen(
                                selfLink: items[i]['selfLink'].toString(),
                                description: items[i]['volumeInfo']
                                        ['description']
                                    .toString(),
                              ),
                            ),
                          );
                        },
                      );

                      booksList.add(newBook);
                    }

                    return Column(
                      children: booksList,
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(100),
                      child: Center(child: Text('Something went wrong')),
                    );
                  }
                } catch (e) {
                  if (e == 400) {
                    return const Padding(
                      padding: EdgeInsets.all(100),
                      child: Center(child: Text('Please search a book name')),
                    );
                  }
                }
                return const Padding(
                  padding: EdgeInsets.all(100),
                  child: Center(child: Text('Please search a book name')),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
