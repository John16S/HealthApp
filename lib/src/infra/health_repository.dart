import 'package:health/health.dart';
import 'package:health_app/src/models/StructureData.dart';

class HealthRepository {
  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
  final health = HealthFactory();

  Future<Object> getData() async {
    // define the types to get
    var types = [
      HealthDataType.WEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      //HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
    ];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    if(requested){
      // fetch health data from the last 24 hours
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          now.subtract(const Duration(days: 7)),
          now,
          types
      );
      String roundedValue;
      return healthData.map((e) {
        return StructureData(
          e.typeString,
          roundedValue = (double.parse(e.value.toJson()['numericValue'])).toStringAsFixed(1),
          e.unitString,
          e.dateFrom,
          e.dateTo,
        );
      }).toList();
    }

    return [];
  }

  Future<void> writeData() async{
    // define the types to get
    var types = [
      HealthDataType.WEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
    ];

    var now = DateTime.now();

    // request permissions to write steps and blood glucose
    var permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE
    ];
    await health.requestAuthorization(types, permissions: permissions);

    // write steps and blood glucose
    await health.writeHealthData(72.0, HealthDataType.WEIGHT, now, now);
    await health.writeHealthData(85, HealthDataType.BLOOD_GLUCOSE, now, now);
    var bool = await health.writeHealthData(95.0, HealthDataType.BLOOD_OXYGEN, now, now);
    await health.writeHealthData(36.6, HealthDataType.BODY_TEMPERATURE, now, now);
    await health.writeHealthData(144.0, HealthDataType.HEART_RATE, now, now);
  }

  Future<int?> getSteps() async{
    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day);

    // request permissions to write steps and blood glucose
    var permissions = [
      HealthDataAccess.READ_WRITE,
    ];
    await health.requestAuthorization([HealthDataType.STEPS], permissions: permissions);

    // write and get steps
    await health.writeHealthData(5000, HealthDataType.STEPS, midnight, now);
    int? steps = await health.getTotalStepsInInterval(midnight, now);

    return steps;
  }

}

/*
  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
    final health = HealthFactory(useHealthConnectIfAvailable: true);

    // define the types to get
    var types = [
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.STEPS,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEART_RATE,
    ];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(const Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    var permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE
    ];
    await health.requestAuthorization(types, permissions: permissions);

    // write steps and blood glucose
    bool success = await health.writeHealthData(5000, HealthDataType.STEPS, now, now);
    success = await health.writeHealthData(72.0, HealthDataType.WEIGHT, now, now);
    //success = await health.writeHealthData(170.0, HealthDataType.HEIGHT, now, now);
    success = await health.writeHealthData(3.1, HealthDataType.BLOOD_GLUCOSE, now, now);
    success = await health.writeHealthData(144.0, HealthDataType.HEART_RATE, now, now);

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    print(healthData);
*/