import 'package:intl/intl.dart';

extension dateTimeExtension on DateTime {
  String toDateViewer({bool withtimezoneoffset = false}) {
    var formatter = DateFormat('d MMM yyyy EEE hh:mm a');

    var tempDate = this;
    if (withtimezoneoffset) {
      var timeZoneOffset = DateTime.now().timeZoneOffset;
      tempDate = this.add(timeZoneOffset);
    }

    return formatter.format(tempDate);
  }
}
