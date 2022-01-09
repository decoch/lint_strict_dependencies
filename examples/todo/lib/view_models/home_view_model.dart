import 'package:flutter/foundation.dart';
import 'package:todo/models/count.dart';

class HomeViewModel with ChangeNotifier {
  Count count = Count();

  void incrementPressed() {
    count.increment();
    notifyListeners();
  }
}
