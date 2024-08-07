import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:medical_blog_app/core/error/failures.dart';
import 'package:medical_blog_app/features/case/models/case_model.dart';
import 'package:medical_blog_app/init_dependencies.dart';

final casesLocalDataSourceProvider = Provider<CasesLocalDataSource>((ref) {
  return CasesLocalDataSourceImpl();
});

abstract class CasesLocalDataSource {
  Future< List<MyCase>> retrieveCases();
  Future<Either<Failure, List<MyCase>>> retrieveCasesByTags(List<String> tags);
  Future<Either<Failure, void>> saveCases(List<MyCase> cases);
  Future<Either<Failure, void>> saveCase(MyCase myCase);

  // Either<Failure, void> saveCase(MyCase myCase);
  // Either<Failure, void> deleteCase(MyCase myCase);
}

class CasesLocalDataSourceImpl implements CasesLocalDataSource {
  CasesLocalDataSourceImpl();

  @override
  Future<List<MyCase>> retrieveCases() async {
    final casesBox = await Hive.openBox("casesBox");

    try {
      List<MyCase> cases = [];

      final List<Map<String, dynamic>> myCases =
          casesBox.values.toList().map((element) {
        return (element as Map<dynamic, dynamic>).map((key, value) {
          return MapEntry(key.toString(), value);
        });
      }).toList();
      print("my cases in local db after formatting");
      print(myCases[0]);
      print("===> ${MyCase.fromMapLocalDB(myCases[0])}");
      myCases.forEach((e){
        cases.add(MyCase.fromMapLocalDB(e));
      });
      print("local cases");
      print(cases);
      casesBox.close();
      return cases;
    } catch (e) {
      throw Left(
          Failure(message: "Error while retrieving cases from local storage"));
    }
  }

  @override
  Future<Either<Failure, List<MyCase>>> retrieveCasesByTags(List<String> tags) async {
    try {
      final casesBox = await Hive.openBox("casesBox");
    final cases = casesBox.values.toList().map((element) {
      return (element as Map<dynamic, dynamic>).map((key, value) {
        return MapEntry(key.toString(), value);
      });
    }).toList();
    Set<MyCase> selectedCases = {};
    for (var element in cases){
      if (element['tags'] != null) {
        for (var tag in tags){
          if (element['tags'].contains(tag)) {
            selectedCases.add(MyCase.fromMapLocalDB(element));
          }
        }
      }
    }
    return Right(selectedCases.toList()); 
    } catch (e) {
      return left(Failure(message: "Error while retrieving cases from local storage"));
    }
    
  }

  @override
  Future<Either<Failure, void>> saveCase(MyCase myCase) async {
    final casesBox = await Hive.openBox("casesBox");

    try {
      await casesBox.put(myCase.id, myCase.toMap());
      casesBox.close();
      return Right(null);
    } catch (e) {
      print(e);
      casesBox.close();

      return Left(
          Failure(message: "Error inserting case in local data source!!"));
    }
  }

  @override
  Future<Either<Failure, void>> saveCases(List<MyCase> cases) async {
    final casesBox = await Hive.openBox("casesBox");

    try {
      cases.forEach((myCase) async {
        await casesBox.put(myCase.id, myCase.toMap());
      });
      casesBox.close();
      return Right(null);
    } catch (e) {
      print(e);
      casesBox.close();
      return Left(
          Failure(message: "Error inserting cases in local data source!!"));
    }
  }
}
