import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:access_challenge/screens/loading_screen.dart';

class MyChart extends StatefulWidget {
  const MyChart ({Key? key, }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  List<ChartData> products = [];
  late TooltipBehavior _tooltipBehavior;

  Future<String> getJsonFromFirebase() async{
    String url = 'https://access-challenges-default-rtdb.firebaseio.com/.json';

    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  Future loadProductsData() async{
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    
    for(Map<String, dynamic> i in jsonResponse){
      if(i['qty'] < 20){
        products.add(ChartData.fromJson(i));
      }
    }
  }

  @override
  void initState(){
    loadProductsData();
    _tooltipBehavior = TooltipBehavior(
      enable: false,
      duration: 0.5,
      opacity: 0.7 
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getJsonFromFirebase(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return (
                SfCartesianChart(
                  title: ChartTitle(text: 'IASA Products 2022'),
                  legend: Legend(isVisible: true, position: LegendPosition.bottom),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    BarSeries<ChartData, String>(
                      name: 'Products',
                      dataSource: products,
                      xValueMapper: (ChartData details,_)=>details.description, 
                      yValueMapper: (ChartData details,_)=>details.qty,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      enableTooltip: true
                    )
                  ],
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0), 
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'QTY by Products'
                    )
                  ),
                )
              );
            }
            else{
              return(const Center(
                child: LoadingScreen()
              ));
            }
          },
        ),
      )
    );
  }
}

class ChartData{
  ChartData(this.description,this.qty);
  final String description;
  final int qty;

  factory ChartData.fromJson(Map<String, dynamic> parsedJson){
    return ChartData(parsedJson['description'].toString(), parsedJson['qty']);
  }
}