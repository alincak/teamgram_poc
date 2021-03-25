import 'package:flutter/material.dart';
import 'package:teamgram_poc/models/domain_model.dart';

class NoteItemView extends StatelessWidget {
  final List<DomainModel> domains;

  NoteItemView({Key key, @required this.domains});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
              height: 350.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text("Investor Tactics Developer"),
                    subtitle: Text("Tue Oct 01 2019 12:50:14"),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Like",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.comment,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Comments",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Share",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
