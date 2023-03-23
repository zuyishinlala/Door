// ignore_for_file: constant_identifier_names, unused_field

part of 'main.dart';

abstract class Routes {
  static const SignUp = _Paths.SignUp;
  static const DoorRunning = _Paths.DoorRunning;
  static const Record = _Paths.Record;
  static const ShowName = _Paths.ShowName;
  static const NavBar = _Paths.NavBar;
}

abstract class _Paths {
  static const SignUp = '/SignUp';
  static const DoorRunning = '/DoorRunning';
  static const Record = '/Record';
  static const ShowName = '/ShowName';
  static const NavBar = '/Nav';
}
