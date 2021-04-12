import 'package:flutter/material.dart';
import 'package:teamgram_poc/models/note_item_model.dart';
import 'package:teamgram_poc/extensions/dateTimeExtension.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    Key key,
    @required this.note,
  }) : super(key: key);

  final NoteItemModel note;

  @override
  Widget build(BuildContext context) {
    var _tapPosition;

    void _storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        child: Container(
          height: 210,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage("https:" + note.profilePictureFileKey),
                ),
                title: Text(note.enteredByIndividualName),
                subtitle: Text(note.lastActivityDate
                    .toDateViewer(withtimezoneoffset: true)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        note.body
                            .replaceAll('<br>', '\n')
                            .replaceAll('<br/>', '\n'),
                      ))
                    ],
                  ),
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
                        Icons.thumb_up_outlined,
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
                        Icons.mode_comment_outlined,
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
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        "Delete",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTapDown: _storePosition,
                    onTap: () {
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject();
                      showMenu(
                          context: context,
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                "Copy",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: Text(
                                "Detail",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            PopupMenuItem(
                              value: 4,
                              child: Text(
                                "New Activity",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                          position: RelativeRect.fromRect(
                              _tapPosition &
                                  const Size(
                                      40, 40), // smaller rect, the touch area
                              Offset.zero & overlay.size));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.more_vert,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offsetPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Flutter Open",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Flutter Tutorial",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        icon: Icon(Icons.library_add),
        offset: Offset(0, 100),
      );
}
