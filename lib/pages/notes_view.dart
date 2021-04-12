import 'package:flutter/material.dart';
import 'package:teamgram_poc/api/api_service.dart';
import 'package:teamgram_poc/models/timeline_model.dart';
import 'package:teamgram_poc/pages/note_item_view.dart';

import '../ProgressHUD.dart';
import 'login_view.dart';

class NotesView extends StatefulWidget {
  @override
  NotesViewState createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {
  final APIService _apiService = APIService();
  TimeLineModel timeLine;
  bool isApiCallProcess = true;

  @override
  void initState() {
    super.initState();
    _apiService.timeLine().then((_timeLine) {
      setState(() {
        timeLine = _timeLine;
        setState(() {
          isApiCallProcess = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _timeLineUISetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _timeLineUISetup(BuildContext context) {
    bool hasNotes = timeLine != null && timeLine.notes != null;
    int itemCount = 0;
    if (hasNotes) {
      itemCount = timeLine.notes.length;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('TeamGram'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            var _note = timeLine.notes[index];
            return NoteItem(note: _note);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add_outlined),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('TeamGram'),
              accountEmail: new Text('kerem@teamgram.com'),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    'https://i1.teamgram.com/i/pp/k_16_50.png'),
              ),
            ),
            new ListTile(
              title: new Text('Timeline'),
              onTap: () {},
            ),
            new ListTile(
              title: new Text('Logout'),
              onTap: () {
                final APIService apiService = APIService();
                apiService.logout().then((value) => {
                      setState(() {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginView(),
                          ),
                        );
                      })
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
