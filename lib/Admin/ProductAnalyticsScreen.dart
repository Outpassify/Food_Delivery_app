// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';


// class ProductAnalyticsDashboard extends StatefulWidget {
//   final String productId;
  
//   const ProductAnalyticsDashboard({Key? key, required this.productId}) : super(key: key);

//   @override
//   _ProductAnalyticsDashboardState createState() => _ProductAnalyticsDashboardState();
// }

// class _ProductAnalyticsDashboardState extends State<ProductAnalyticsDashboard> {
//   TimeRange _selectedRange = TimeRange.week;
//   bool _showDetails = false;
//   List<AnalyticsData> _analyticsData = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAnalyticsData();
//   }

//   Future<void> _fetchAnalyticsData() async {
//     setState(() => _isLoading = true);
//     // Simulate API call
//     await Future.delayed(Duration(seconds: 1));
    
//     setState(() {
//       _analyticsData = _generateMockData();
//       _isLoading = false;
//     });
//   }

//   List<AnalyticsData> _generateMockData() {
//     final now = DateTime.now();
//     final random = Random();
//     return List.generate(
//       _selectedRange == TimeRange.day ? 24 : 
//       _selectedRange == TimeRange.week ? 7 :
//       _selectedRange == TimeRange.month ? 30 :
//       _selectedRange == TimeRange.quarter ? 12 :
//       12,
//       (index) => AnalyticsData(
//         date: _selectedRange == TimeRange.day ? 
//           DateTime(now.year, now.month, now.day, index) :
//           _selectedRange == TimeRange.week ?
//           now.subtract(Duration(days: 6 - index)) :
//           _selectedRange == TimeRange.month ?
//           now.subtract(Duration(days: 29 - index)) :
//           _selectedRange == TimeRange.quarter ?
//           now.subtract(Duration(days: 89 - index * 7)) :
//           DateTime(now.year - 1 + (index ~/ 12), (index % 12) + 1, 1),
//         views: 100 + (index * 10) + random.nextInt(50),
//         purchases: 5 + (index * 2) + random.nextInt(10),
//         revenue: 100.0 + (index * 25.0) + random.nextDouble() * 50,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text('Product Analytics'),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: _fetchAnalyticsData,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Header with product info
//           _buildProductHeader(),
          
//           // Time range selector
//           _buildTimeRangeSelector(),
          
//           // Summary cards
//           _buildSummaryCards(),
          
//           // Main chart area
//           Expanded(
//             child: _isLoading 
//                 ? Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         _buildMainChart(),
//                         if (_showDetails) _buildDetailedMetrics(),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: Colors.blue[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(Icons.shopping_bag, size: 30, color: Colors.blue[800]),
//           ),
//           SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Product #${widget.productId}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 'Last updated: ${DateFormat('MMM dd, hh:mm a').format(DateTime.now())}',
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimeRangeSelector() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: TimeRange.values.map((range) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _selectedRange = range;
//                   _fetchAnalyticsData();
//                 });
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: _selectedRange == range 
//                       ? Colors.blue[50] 
//                       : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   range.displayName,
//                   style: TextStyle(
//                     color: _selectedRange == range 
//                         ? Colors.blue[800] 
//                         : Colors.grey[600],
//                     fontWeight: _selectedRange == range 
//                         ? FontWeight.bold 
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildSummaryCards() {
//     if (_analyticsData.isEmpty) return SizedBox();
    
//     final totalViews = _analyticsData.fold(0, (sum, data) => sum + data.views);
//     final totalPurchases = _analyticsData.fold(0, (sum, data) => sum + data.purchases);
//     final totalRevenue = _analyticsData.fold(0.0, (sum, data) => sum + data.revenue);
//     final conversionRate = totalViews > 0 ? (totalPurchases / totalViews * 100) : 0;

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Wrap(
//         spacing: 16,
//         runSpacing: 16,
//         children: [
//           _buildMetricCard(
//             title: 'Total Views',
//             value: NumberFormat.compact().format(totalViews),
//             icon: Icons.remove_red_eye,
//             color: Colors.blue,
//           ),
//           _buildMetricCard(
//             title: 'Purchases',
//             value: NumberFormat.compact().format(totalPurchases),
//             icon: Icons.shopping_cart,
//             color: Colors.green,
//           ),
//           _buildMetricCard(
//             title: 'Revenue',
//             value: '\$${NumberFormat.compact().format(totalRevenue)}',
//             icon: Icons.attach_money,
//             color: Colors.purple,
//           ),
//           _buildMetricCard(
//             title: 'Conversion',
//             value: '${conversionRate.toStringAsFixed(1)}%',
//             icon: Icons.trending_up,
//             color: Colors.orange,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Container(
//       width: 150,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, size: 20, color: color),
//               ),
//               Icon(Icons.more_vert, size: 20, color: Colors.grey),
//             ],
//           ),
//           SizedBox(height: 16),
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainChart() {
//     final dateFormatter = DateFormat(
//       _selectedRange == TimeRange.day ? 'HH:mm' :
//       _selectedRange == TimeRange.week ? 'EEE' :
//       _selectedRange == TimeRange.month ? 'MMM dd' :
//       _selectedRange == TimeRange.quarter ? 'MMM yyyy' :
//       'MMM yyyy'
//     );

//     return Card(
//       margin: EdgeInsets.all(16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Performance Overview',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     _showDetails ? Icons.expand_less : Icons.expand_more,
//                   ),
//                   onPressed: () {
//                     setState(() => _showDetails = !_showDetails);
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Container(
//               height: 250,
//               child: SfCartesianChart(
//                 primaryXAxis: CategoryAxis(
//                   labelRotation: _selectedRange == TimeRange.year ? 45 : 0,
//                   labelIntersectAction: AxisLabelIntersectAction.rotate45,
//                   labelAlignment: LabelAlignment.center,
//                   // labelFormatter: (value) => 
//                   //   dateFormatter.format(_analyticsData[int.parse(value)].date),
//                 ),
//                 series: <CartesianSeries>[
//                   LineSeries<AnalyticsData, String>(
//                     dataSource: _analyticsData,
//                     xValueMapper: (data, _) => 
//                       dateFormatter.format(data.date),
//                     yValueMapper: (data, _) => data.views,
//                     name: 'Views',
//                     color: Colors.blue,
//                     markerSettings: MarkerSettings(isVisible: true),
//                   ),
//                   LineSeries<AnalyticsData, String>(
//                     dataSource: _analyticsData,
//                     xValueMapper: (data, _) => 
//                       dateFormatter.format(data.date),
//                     yValueMapper: (data, _) => data.purchases * 10,
//                     name: 'Purchases (x10)',
//                     color: Colors.green,
//                     markerSettings: MarkerSettings(isVisible: true),
//                   ),
//                 ],
//                 tooltipBehavior: TooltipBehavior(enable: true),
//                 legend: Legend(
//                   isVisible: true,
//                   position: LegendPosition.top,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailedMetrics() {
//     return Card(
//       margin: EdgeInsets.all(16),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Detailed Metrics',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             DataTable(
//               columns: [
//                 DataColumn(label: Text('Date')),
//                 DataColumn(label: Text('Views', textAlign: TextAlign.end)),
//                 DataColumn(label: Text('Purchases', textAlign: TextAlign.end)),
//                 DataColumn(label: Text('Revenue', textAlign: TextAlign.end)),
//               ],
//               rows: _analyticsData.reversed.take(5).map((data) {
//                 return DataRow(cells: [
//                   DataCell(Text(DateFormat('MMM dd').format(data.date))),
//                   DataCell(Text(data.views.toString(), 
//                     textAlign: TextAlign.end)),
//                   DataCell(Text(data.purchases.toString(), 
//                     textAlign: TextAlign.end)),
//                   DataCell(Text('\$${data.revenue.toStringAsFixed(2)}', 
//                     textAlign: TextAlign.end)),
//                 ]);
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AnalyticsData {
//   final DateTime date;
//   final int views;
//   final int purchases;
//   final double revenue;

//   AnalyticsData({
//     required this.date,
//     required this.views,
//     required this.purchases,
//     required this.revenue,
//   });
// }

// enum TimeRange {
//   day('Day'),
//   week('Week'),
//   month('Month'),
//   quarter('Quarter'),
//   year('Year');

//   final String displayName;
//   const TimeRange(this.displayName);
// }