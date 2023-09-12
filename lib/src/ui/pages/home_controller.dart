import 'package:flutter/material.dart';
import 'package:health_app/src/infra/health_repository.dart';
import 'package:health_app/src/models/StructureData.dart';

class HomeController{

  final repository = HealthRepository();
  final structureData = ValueNotifier(<StructureData>[]);

  Future<void> getData() async{
    structureData.value = await repository.getData() as List<StructureData>;
    //repository.getSteps();
  }

  Future<void> writeData() async{
    await repository.writeData();
  }
}