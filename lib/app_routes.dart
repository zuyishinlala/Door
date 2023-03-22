// ignore_for_file: constant_identifier_names

part of 'main.dart';

abstract class Routes {
  static const SignUp = _Paths.SignUp;
  static const DoorRunning = _Paths.DoorRunning;
  static const Record = _Paths.DoorRunning + _Paths.Record;
  static const ShowName = _Paths.DoorRunning + _Paths.ShowName;
}

abstract class _Paths {
  static const SignUp = '/SignUp';
  static const DoorRunning = '/DoorRunning';
  static const Record = '/Record';
  static const ShowName = '/ShowName';
}

abstract class APIs {
  static const serverAdd = 'server.com';
  
}
