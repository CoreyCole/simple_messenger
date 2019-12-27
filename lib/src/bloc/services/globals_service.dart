import 'package:rxdart/rxdart.dart';


class GlobalsService {
  final BehaviorSubject<bool> loading;
  final BehaviorSubject<String> error;

  GlobalsService() :
    loading = BehaviorSubject<bool>.seeded(false),
    error = BehaviorSubject<String>.seeded(null);

  dispose() {
    loading.close();
  } 
}