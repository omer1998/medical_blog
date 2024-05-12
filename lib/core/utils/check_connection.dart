import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:medical_blog_app/core/network/connection_checker.dart';

Future<bool> isConnected() async {
  final connectionChecker =
      ConnectionCheckerImpl(internetConnection: InternetConnection());
  final isConnected = await connectionChecker.isConnected;
  return isConnected;
}
