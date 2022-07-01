import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:nus_social/add_friends.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/chats.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';
import 'package:nus_social/games.dart';
import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';
import 'package:nus_social/message_class.dart';

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
      body: MessagePage(),
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

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [
    Message(
        text: 'This is a test',
        isSentByMe: true,
        date: DateTime.now().subtract(Duration(minutes: 5))),
    Message(
        text: 'I know',
        isSentByMe: false,
        date: DateTime.now().subtract(Duration(minutes: 4))),
    Message(
        text: 'Amazing',
        isSentByMe: true,
        date: DateTime.now().subtract(Duration(minutes: 3))),
  ];

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GroupedListView<Message, DateTime>(
            padding: const EdgeInsets.all(8),
            reverse: true,
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: true,
            floatingHeader: true,
            elements: messages,
            groupBy: (message) => DateTime(
              message.date.year,
              message.date.month,
              message.date.day,
            ),
            groupHeaderBuilder: (Message message) => SizedBox(
              height: 40,
              child: Center(
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      DateFormat.yMMMd().format(message.date),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (BuildContext context, Message message) => Align(
              alignment: message.isSentByMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(message.text),
                      Text(
                        DateFormat.jm().format(message.date),
                        style: const TextStyle(fontSize: 9),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    hintText: 'Type your message here...',
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  String text = messageController.text;
                  Message message = Message(
                    text: text,
                    date: DateTime.now(),
                    isSentByMe: true,
                  );

                  setState(() {
                    messages.add(message);
                    messageController.clear();
                  });
                },
                icon: const Icon(
                  Icons.send_outlined,
                  color: Colors.deepOrange,
                ))
          ],
        ),
      ],
    );
  }
}
