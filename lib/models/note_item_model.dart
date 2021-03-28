class NoteItemModel {
  DateTime lastActivityDate;
  String profilePictureFileKey;
  String body;
  int enteredByIndividualId;
  String enteredByIndividualName;

  NoteItemModel(
      {this.lastActivityDate,
      this.profilePictureFileKey,
      this.body,
      this.enteredByIndividualId,
      this.enteredByIndividualName});

  factory NoteItemModel.fromJson(Map<String, dynamic> jsonToken) {
    return NoteItemModel(
      lastActivityDate: jsonToken["LastActivityDate"] != null
          ? DateTime.parse(jsonToken["LastActivityDate"])
          : DateTime.now(),
      profilePictureFileKey: jsonToken["ProfilePictureFileKey"] != null
          ? jsonToken["ProfilePictureFileKey"]
          : "",
      body: jsonToken["Body"] != null ? jsonToken["Body"] : "",
      enteredByIndividualId: jsonToken["EnteredByIndividualId"] != null
          ? jsonToken["EnteredByIndividualId"]
          : 0,
      enteredByIndividualName: jsonToken["EnteredByIndividualName"] != null
          ? jsonToken["EnteredByIndividualName"]
          : "",
    );
  }
}
