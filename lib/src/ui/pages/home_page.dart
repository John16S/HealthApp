import 'package:flutter/material.dart';
import 'package:health_app/src/ui/pages/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();
  var selectedDataType = 'ALL'; // тип данных по умолчанию

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('Health App', style: TextStyle(),),
        actions: [
          ElevatedButton(
              onPressed: () => controller.writeData(),
              child: const Text('Write Data')
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.getData(),
        child: const Icon(Icons.refresh_sharp),
      ),

      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Filter:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedDataType,
                onChanged: (newValue) {
                  if (newValue is String) {
                    setState(() {
                      selectedDataType = newValue;
                    });
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'ALL',
                    child: Text('ALL'),
                  ),DropdownMenuItem(
                    value: 'WEIGHT',
                    child: Text('WEIGHT'),
                  ),
                  DropdownMenuItem(
                    value: 'BLOOD_GLUCOSE',
                    child: Text('BLOOD_GLUCOSE'),
                  ),
                  DropdownMenuItem(
                    value: 'BODY_TEMPERATURE',
                    child: Text('BODY_TEMPERATURE'),
                  ),
                  DropdownMenuItem(
                    value: 'HEART_RATE',
                    child: Text('HEART_RATE'),
                  ),
                ],
                style: const TextStyle(
                  color: Colors.black, // Цвет текста
                  fontSize: 16.0, // Размер шрифта
                ),
                icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.purple), // Иконка стрелки
                elevation: 2, // Высота тени выпадающего списка

              ),
            ],
          ),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller.structureData,
              builder: (context, value, child) {
                /// value - все возвращаемые данные
                /// filteredDataType - Типы данных из StructureData
                /// filteredData - для обработки кейса если выбран ALL, то возвращаем value
                final filteredDataType = value.where((data) => data.type == selectedDataType);
                final filteredData = selectedDataType == 'ALL' ? value : filteredDataType;
                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  children: [
                    for (final e in filteredData)
                      Card(
                        color: Colors.deepPurple,
                        elevation: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.type,
                              style: const TextStyle(
                                fontSize: 16, // Размер шрифта.
                                fontWeight: FontWeight.bold, // Жирный шрифт.
                                color: Colors.white, // Цвет текста.
                              ),
                            ),Text(
                              e.value,
                              style: const TextStyle(
                                fontSize: 14, // Размер шрифта.
                                fontWeight: FontWeight.bold, // Жирный шрифт.
                                color: Colors.white, // Цвет текста.
                              ),
                            ),
                            Text(
                              e.unit,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5), // Отступы сверху и снизу.
                              child: Text(
                                'From: ${e.dateFrom.toString()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'To: ${e.dateTo.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}