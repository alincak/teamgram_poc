import 'package:flutter/material.dart';
import 'package:teamgram_poc/models/note_item_model.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key key,
    @required this.note,
  }) : super(key: key);

  final NoteItemModel note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 250,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("https:" + note.profilePictureFileKey),
              ),
              title: Text(note.enteredByIndividualName),
              subtitle: Text(note.lastActivityDate.toString()),
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[new Text(note.body)],
                  )),
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
    );
  }
}
