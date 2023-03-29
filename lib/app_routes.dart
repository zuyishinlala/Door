// ignore_for_file: constant_identifier_names, unused_field

part of 'main.dart';

abstract class Routes {
  static const SignUp = _Paths.SignUp;
  static const DoorScan = _Paths.DoorScan;
  static const Record = _Paths.Record;
  static const ShowName = _Paths.ShowName;
  static const NavBar = _Paths.NavBar;
}

abstract class _Paths {
  static const SignUp = '/SignUp';
  static const DoorScan = '/DoorScan';
  static const Record = '/Record';
  static const ShowName = '/ShowName';
  static const NavBar = '/Nav';
}
