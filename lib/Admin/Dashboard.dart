import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inventory_manager/Admin/Delivery_partners.dart';
import 'package:inventory_manager/Admin/MenuManagementScreen.dart';
import 'package:inventory_manager/Admin/ProductAnalyticsScreen.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _adminScreens = [
    const AdminDashboard(),
    const MenuManagementScreen(),
    const DeliveryManagementScreen(),
    //const ProductAnalyticsDashboard(productId: '12345',),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;

    return Scaffold(
      appBar: _buildAppBar(theme, isLargeScreen),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _adminScreens[_currentIndex],
        ),
      ),
      bottomNavigationBar: isLargeScreen ? null : _buildAdminNavBar(theme),
      drawer: isLargeScreen ? null : _buildDrawer(theme),
    );
  }
  final List<String> _titles = [
  'Dashboard',
  'Menu Management',
  'Delivery Management',
  'Analytics',
];

AppBar _buildAppBar(ThemeData theme, bool isLargeScreen) {
  return AppBar(
    title: Text(
      _titles[_currentIndex],  // <-- title changes dynamically
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
    centerTitle: !isLargeScreen,
    elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {},
        tooltip: 'Notifications',
      ),
      if (isLargeScreen) ...[
        _NavBarItem(
          icon: Icons.dashboard,
          label: _titles[0], // <-- use titles list here
          isActive: _currentIndex == 0,
          onTap: () => _updateIndex(0),
        ),
        _NavBarItem(
          icon: Icons.restaurant_menu,
          label: _titles[1], // <-- use titles list here
          isActive: _currentIndex == 1,
          onTap: () => _updateIndex(1),
        ),
        _NavBarItem(
          icon: Icons.delivery_dining,
          label: _titles[2], // <-- use titles list here
          isActive: _currentIndex == 2,
          onTap: () => _updateIndex(2),
        ),
        _NavBarItem(
          icon: Icons.analytics,
          label: _titles[3], // <-- use titles list here
          isActive: _currentIndex == 3,
          onTap: () => _updateIndex(3),
        ),
      ],
      const SizedBox(width: 12),
    ],
  );
}


  Widget _buildDrawer(ThemeData theme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColorDark,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                  const Text('Admin User', style: TextStyle(color: Colors.white, fontSize: 18)),
                  const Text('admin@example.com', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          _DrawerItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isActive: _currentIndex == 0,
            onTap: () => _updateIndex(0),
          ),
          _DrawerItem(
            icon: Icons.restaurant_menu,
            label: 'Menu Management',
            isActive: _currentIndex == 1,
            onTap: () => _updateIndex(1),
          ),
          _DrawerItem(
            icon: Icons.delivery_dining,
            label: 'Delivery Management',
            isActive: _currentIndex == 2,
            onTap: () => _updateIndex(2),
          ),
          _DrawerItem(
            icon: Icons.analytics,
            label: 'Analytics',
            isActive: _currentIndex == 3,
            onTap: () => _updateIndex(3),
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {},
          ),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAdminNavBar(ThemeData theme) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _updateIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu_outlined),
          activeIcon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining_outlined),
          activeIcon: Icon(Icons.delivery_dining),
          label: 'Delivery',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
      ],
    );
  }

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
      _animationController.reset();
      _animationController.forward();
    });
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overview', style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 16),
                _buildStatsGrid(context),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Orders', style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    TextButton(
                      child: const Text('View All'),
                      onPressed: () {},
                    ),
                  ],
                ),
                _buildRecentOrders(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth <= 1200;

    if (isSmallScreen) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Today\'s Orders',
                  value: '124',
                  icon: Icons.shopping_bag,
                  trend: 12.5,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Active Delivery',
                  value: '8',
                  icon: Icons.delivery_dining,
                  trend: -2.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Revenue',
                  value: '\$2,450',
                  icon: Icons.attach_money,
                  trend: 18.7,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'New Customers',
                  value: '24',
                  icon: Icons.people,
                  trend: 5.2,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (isMediumScreen) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          _StatCard(
            title: 'Today\'s Orders',
            value: '124',
            icon: Icons.shopping_bag,
            trend: 12.5,
          ),
          _StatCard(
            title: 'Active Delivery',
            value: '8',
            icon: Icons.delivery_dining,
            trend: -2.3,
          ),
          _StatCard(
            title: 'Revenue',
            value: '\$2,450',
            icon: Icons.attach_money,
            trend: 18.7,
          ),
          _StatCard(
            title: 'New Customers',
            value: '24',
            icon: Icons.people,
            trend: 5.2,
          ),
        ],
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          _StatCard(
            title: 'Today\'s Orders',
            value: '124',
            icon: Icons.shopping_bag,
            trend: 12.5,
          ),
          _StatCard(
            title: 'Active Delivery',
            value: '8',
            icon: Icons.delivery_dining,
            trend: -2.3,
          ),
          _StatCard(
            title: 'Revenue',
            value: '\$2,450',
            icon: Icons.attach_money,
            trend: 18.7,
          ),
          _StatCard(
            title: 'New Customers',
            value: '24',
            icon: Icons.people,
            trend: 5.2,
          ),
        ],
      );
    }
  }

  Widget _buildRecentOrders(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
        child: Column(
          children: [
            if (isLargeScreen) _buildOrderTableHeader(),
            SizedBox(
              height: isLargeScreen ? 400 : 300, // Fixed height to prevent overflow
              child: ListView.separated(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) => isLargeScreen 
                  ? _OrderTableRow(orderIndex: index)
                  : _OrderListItem(orderIndex: index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Items', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double trend;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = trend >= 0;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 120,
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: theme.primaryColor),
                  ),
                ],
              ),
              Text(value, style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              )),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${trend.abs()}% ${isPositive ? 'increase' : 'decrease'}',
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 80,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: isActive ? Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: isActive ? Theme.of(context).primaryColor : Colors.grey),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: 12,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, size: 24, color: isActive ? Theme.of(context).primaryColor : null),
      title: Text(label, style: TextStyle(
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? Theme.of(context).primaryColor : null,
      )),
      selected: isActive,
      onTap: onTap,
    );
  }
}

class _OrderTableRow extends StatelessWidget {
  final int orderIndex;

  const _OrderTableRow({required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    final statuses = ['Preparing', 'On the way', 'Delivered', 'Cancelled'];
    final statusColors = [Colors.orange, Colors.blue, Colors.green, Colors.red];
    final status = statuses[orderIndex % statuses.length];
    final statusColor = statusColors[statuses.indexOf(status)];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('#${1230 + orderIndex}', overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Text('Customer ${orderIndex + 1}', 
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Text('${orderIndex + 2} items', overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 1,
            child: Text('\$${24.50 + orderIndex * 5}', overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderListItem extends StatelessWidget {
  final int orderIndex;

  const _OrderListItem({required this.orderIndex});

  @override
  Widget build(BuildContext context) {
    final statuses = ['Preparing', 'On the way', 'Delivered', 'Cancelled'];
    final statusColors = [Colors.orange, Colors.blue, Colors.green, Colors.red];
    final status = statuses[orderIndex % statuses.length];
    final statusColor = statusColors[statuses.indexOf(status)];

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.blue[50],
        child: Text('#${1230 + orderIndex}', style: const TextStyle(color: Colors.blue)),
      ),
      title: Text('Customer ${orderIndex + 1}', 
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text('${orderIndex + 2} items • \$${24.50 + orderIndex * 5}',
        overflow: TextOverflow.ellipsis),
      trailing: SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 80),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}


class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Analytics', style: TextStyle(fontSize: 24)));
  }
}