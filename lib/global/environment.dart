import 'dart:io';

class Environment {
  // static String apiUrl    = Platform.isAndroid ? 'https://ser-inv-test-a0e4cf32afc0.herokuapp.com/api' : 'http://localhost:3000/api';
  static String apiUrl    = Platform.isAndroid ? 'http://192.168.1.34:3000/api' : 'http://localhost:3000/api';
  // static String socketUrl = Platform.isAndroid ? 'https://ser-inv-test-a0e4cf32afc0.herokuapp.com'     : 'http://localhost:3000';
  static String socketUrl = Platform.isAndroid ? 'http://192.168.1.34:3000'     : 'http://localhost:3000';
}