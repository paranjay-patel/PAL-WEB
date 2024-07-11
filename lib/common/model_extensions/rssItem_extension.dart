import 'package:intl/intl.dart';
import 'package:webfeed/webfeed.dart';

extension RssItemExtension on RssItem {
  bool get isValidItem {
    return description != null && media != null && link != null;
  }

  String get getDescription {
    final description = this.description;
    if (description == null) return '';
    return description;
  }

  String get getTitle {
    final title = this.title;
    if (title == null) return '';
    return title;
  }

  String get imageUrl {
    final url = itunes?.image?.href;
    if (url == null) return '';
    return url;
  }

  String get getDate {
    final dateAndTime = pubDate;
    if (dateAndTime == null) return '';
    return DateFormat('MMM d, yyyy').format(dateAndTime);
  }

  String get getDuration {
    final duration = itunes?.duration?.inMinutes;
    return '${duration}min';
  }
}
