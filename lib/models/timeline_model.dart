import 'package:teamgram_poc/models/note_item_model.dart';

class TimeLineModel {
  int currentIndividualId;
  int totalCount;
  List<NoteItemModel> notes = [];

  TimeLineModel({this.currentIndividualId, this.totalCount, this.notes});

  factory TimeLineModel.fromJson(Map<String, dynamic> jsonToken) {
    Iterable _notes = jsonToken["Notes"];
    return TimeLineModel(
      currentIndividualId: jsonToken["CurrentIndividualId"] != null
          ? jsonToken["CurrentIndividualId"]
          : 0,
      totalCount:
          jsonToken["NoteTotalCount"] != null ? jsonToken["NoteTotalCount"] : 0,
      notes: _notes != null
          ? _notes.map((noteItem) => NoteItemModel.fromJson(noteItem)).toList()
          : null,
    );
  }
}
