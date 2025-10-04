// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

abstract class ApiServices{
  Future<Response> get({required String url, dynamic data, dynamic params}) ;
  Future<Response> post({required String url, dynamic data, dynamic params}) ;
  Future<Response> put({required String url});
  Future<Response> delete({required String url});
}

