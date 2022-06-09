import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './friends.dart';
import './games.dart';
import './profile.dart';
import './settings.dart';
import 'homePage.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
          )
        ],
      ),
      body: ConvPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.blueGrey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined, size: 20),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined, size: 20),
            label: "Games",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_outlined, size: 20),
            label: "Chats",
          ),
        ],
        onTap: (value) {
          if (value == 0)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => WelcomePage()));
          if (value == 1)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GamesPage()));
          if (value == 2) ;
        },
      ),
    );
  }
}

class ConvPage extends StatefulWidget {
  @override
  _ConvPageState createState() => _ConvPageState();
}

class _ConvPageState extends State<ConvPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("Chat")),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    'Adee',
    'Jacob',
    'Yuhan',
    'Daryl',
    'Oyd',
    'Seth',
  ]; //Sample search suggestions, TBC

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_outlined),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_outlined),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query, style: const TextStyle(fontSize: 64)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
            });
      },
    );
  }
}