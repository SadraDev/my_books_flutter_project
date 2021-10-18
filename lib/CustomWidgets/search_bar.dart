import 'package:appandup_bookshelf/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, this.onChanged, this.onPressed}) : super(key: key);

  final void Function(String)? onChanged;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 100,
              color: Colors.black26,
            )
          ],
        ),
        child: TextField(
          decoration: kTextFieldDecoration.copyWith(
            prefixIcon: const Icon(CupertinoIcons.book),
            suffixIcon: IconButton(
              padding: const EdgeInsets.all(8).copyWith(right: 16),
              onPressed: onPressed,
              icon: const Icon(Icons.search),
            ),
            hintText: 'Book or Author name...',
            enabledBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                const OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
