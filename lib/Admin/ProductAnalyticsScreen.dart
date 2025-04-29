import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Analysis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProductAnalysisScreen(),
    );
  }
}

class ProductAnalysisScreen extends StatefulWidget {
  @override
  _ProductAnalysisScreenState createState() => _ProductAnalysisScreenState();
}

class _ProductAnalysisScreenState extends State<ProductAnalysisScreen> {
  // Dummy data
  final List<Map<String, dynamic>> _salesData = [
    {'day': 'Mon', 'value': 1200},
    {'day': 'Tue', 'value': 1800},
    {'day': 'Wed', 'value': 900},
    {'day': 'Thu', 'value': 2100},
    {'day': 'Fri', 'value': 1500},
    {'day': 'Sat', 'value': 3000},
    {'day': 'Sun', 'value': 2700},
  ];

  final List<Map<String, dynamic>> _topProducts = [
    {'name': 'Wireless Headphones', 'sales': 2450, 'rating': 4.8, 'image': Icons.headset},
    {'name': 'Smart Watch', 'sales': 1890, 'rating': 4.5, 'image': Icons.watch},
    {'name': 'Running Shoes', 'sales': 1230, 'rating': 4.3, 'image': Icons.directions_run},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Electronics', 'percentage': 65, 'color': Colors.blue},
    {'name': 'Clothing', 'percentage': 42, 'color': Colors.green},
    {'name': 'Home Goods', 'percentage': 38, 'color': Colors.orange},
  ];

  String _selectedTimeRange = 'Last 30 Days';
  String _selectedCategory = 'All Categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Insights'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDateSelector(),
            SizedBox(height: 20),
            _buildSummaryCards(),
            SizedBox(height: 20),
            _buildSalesChart(),
            SizedBox(height: 20),
            _buildCategoryPerformance(),
            SizedBox(height: 20),
            _buildTopProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedTimeRange,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        OutlinedButton(
          onPressed: () => _showTimeRangeDialog(),
          child: Row(
            children: [
              Text('May 2023'),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Total Sales', '\$12,345', Icons.attach_money, Colors.blue, '+12%')),
        SizedBox(width: 10),
        Expanded(child: _buildSummaryCard('Products', '248', Icons.shopping_bag, Colors.green, '+5%')),
        SizedBox(width: 10),
        Expanded(child: _buildSummaryCard('Avg. Rating', '4.2', Icons.star, Colors.orange, '+0.3')),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String change) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Spacer(),
                Text(change, style: TextStyle(color: Colors.green)),
              ],
            ),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    final maxValue = _salesData.map((e) => e['value']).reduce((a, b) => a > b ? a : b).toDouble();
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sales Trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: CustomPaint(
                painter: _BarChartPainter(
                  data: _salesData,
                  maxValue: maxValue,
                  barColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeRangeButton('Week', _selectedTimeRange == 'Week'),
                _buildTimeRangeButton('Month', _selectedTimeRange == 'Last 30 Days'),
                _buildTimeRangeButton('Quarter', _selectedTimeRange == 'Quarter'),
                _buildTimeRangeButton('Year', _selectedTimeRange == 'Year'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String text, bool isSelected) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedTimeRange = text == 'Month' ? 'Last 30 Days' : text;
        });
      },
      child: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.blue : Colors.grey,
      ),
    );
  }

  Widget _buildCategoryPerformance() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Category Performance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              children: _categories.map((category) => _buildCategoryItem(category)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: category['color'],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12),
              Expanded(child: Text(category['name'])),
              Text('${category['percentage']}%'),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: category['percentage'] / 100,
            backgroundColor: category['color'].withOpacity(0.2),
            color: category['color'],
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Top Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              children: _topProducts.map((product) => _buildProductItem(product)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(product['image'], color: Colors.grey),
      ),
      title: Text(product['name']),
      subtitle: Row(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 16),
          Text(' ${product['rating']}'),
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('\$${product['sales'].toString()}', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Sales', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter Analysis'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Date Range', _selectedTimeRange),
            _buildFilterOption('Product Category', _selectedCategory),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, you would refresh data here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filters applied')),
              );
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showTimeRangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Time Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeRangeOption('Last 7 Days'),
            _buildTimeRangeOption('Last 30 Days'),
            _buildTimeRangeOption('Last Quarter'),
            _buildTimeRangeOption('Last Year'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeOption(String text) {
    return ListTile(
      title: Text(text),
      trailing: _selectedTimeRange == text ? Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        setState(() {
          _selectedTimeRange = text;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildFilterOption(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          TextButton(
            onPressed: () {
              if (title == 'Date Range') {
                _showTimeRangeDialog();
              }
              // Add other filter dialogs here
            },
            child: Row(
              children: [
                Text(value),
                Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the bar chart
class _BarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxValue;
  final Color barColor;

  _BarChartPainter({required this.data, required this.maxValue, required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    final barWidth = size.width / data.length - 10;
    final scale = size.height / maxValue;

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final barHeight = item['value'] * scale;
      final x = i * (barWidth + 10) + 5;
      final y = size.height - barHeight;

      // Draw bar
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        paint,
      );

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: item['day'],
          style: TextStyle(color: Colors.black, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, size.height + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}