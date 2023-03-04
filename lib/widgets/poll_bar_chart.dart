// import 'package:charts_flutter_new/flutter.dart' as charts;
// import 'package:flutter/cupertino.dart';


// class PollBarChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   PollBarChart(this.seriesList, {this.animate});

//   @override
//   Widget build(BuildContext context) {
//     return charts.BarChart(
//       seriesList,
//       animate: animate,
//       barGroupingType: charts.BarGroupingType.grouped,
//       behaviors: [
//         charts.SeriesLegend(
//           position: charts.BehaviorPosition.bottom,
//           horizontalFirst: false,
//           desiredMaxRows: 2,
//           cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
//           entryTextStyle: charts.TextStyleSpec(
//             fontSize: 14,
//             color: charts.MaterialPalette.gray.shade800,
//           ),
//         ),
//       ],
//       domainAxis: charts.OrdinalAxisSpec(
//         renderSpec: charts.SmallTickRendererSpec(
//           labelStyle: charts.TextStyleSpec(
//             fontSize: 12,
//             color: charts.MaterialPalette.gray.shade800,
//           ),
//         ),
//       ),
//     );
//   }
// }
