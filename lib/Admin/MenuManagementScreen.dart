import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Category> _categories = [
    Category(id: '1', name: 'Burgers', itemCount: 5, color: Colors.orange.shade600),
    Category(id: '2', name: 'Pizzas', itemCount: 8, color: Colors.red.shade600),
    Category(id: '3', name: 'Drinks', itemCount: 12, color: Colors.blue.shade600),
    Category(id: '4', name: 'Desserts', itemCount: 6, color: Colors.purple.shade600),
    Category(id: '5', name: 'Sushi', itemCount: 9, color: Colors.green.shade600),
    Category(id: '6', name: 'Salads', itemCount: 4, color: Colors.lightGreen.shade600),
  ];

  final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1', 
      name: 'Cheeseburger Deluxe', 
      category: 'Burgers', 
      price: 12.99, 
      isAvailable: true,
      image: 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      description: 'Juicy beef patty with cheddar cheese, lettuce, tomato, and special sauce',
    ),
    MenuItem(
      id: '2', 
      name: 'Margherita Pizza', 
      category: 'Pizzas', 
      price: 14.99, 
      isAvailable: true,
      image: 'assets/pizza.jpg',
      description: 'Classic pizza with tomato sauce, mozzarella, and fresh basil',
    ),
    MenuItem(
      id: '3', 
      name: 'Craft Cola', 
      category: 'Drinks', 
      price: 3.50, 
      isAvailable: true,
      image: 'assets/cola.jpg',
      description: 'Handcrafted cola with natural flavors',
    ),
    MenuItem(
      id: '4', 
      name: 'Chocolate Lava Cake', 
      category: 'Desserts', 
      price: 7.99, 
      isAvailable: false,
      image: 'assets/cake.jpg',
      description: 'Warm chocolate cake with a molten center, served with vanilla ice cream',
    ),
  ];

  String _selectedCategoryFilter = 'All';
  bool _isGridLayout = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;

    return Scaffold(
      backgroundColor: Colors.white, // Changed to white background
appBar: AppBar(
  centerTitle: false,
  elevation: 0,
  backgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.black87),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Align(
      alignment: Alignment.centerLeft, // remove extra top space
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 3,
        indicatorColor: colorScheme.primary,
        labelColor: colorScheme.primary,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        tabs: const [
          Tab(
            icon: Icon(Icons.category_outlined, size: 22),
            text: 'Categories',
          ),
          Tab(
            icon: Icon(Icons.restaurant_menu_outlined, size: 22),
            text: 'Menu Items',
          ),
        ],
      ),
    ),
  ),
  actions: const [
    SizedBox(width: 8), // No grid/list view button anymore
  ],
),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Categories Tab
            _buildCategoriesTab(theme, isLargeScreen),
            // Menu Items Tab
            _buildMenuItemsTab(theme, isLargeScreen),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(
          _tabController.index == 0 ? 'Add Category' : 'Add Item',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCategoriesTab(ThemeData theme, bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isLargeScreen ? 4 : 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1,
        ),
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          if (index == _categories.length) {
            return _buildAddCategoryCard(theme);
          }
          return _buildCategoryCard(_categories[index], theme);
        },
      ),
    );
  }

  Widget _buildMenuItemsTab(ThemeData theme, bool isLargeScreen) {
    final filteredItems = _selectedCategoryFilter == 'All'
        ? _menuItems
        : _menuItems.where((item) => item.category == _selectedCategoryFilter).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isLargeScreen ? 24 : 16,
            right: isLargeScreen ? 24 : 16,
            top: 16,
            bottom: 8),
          child: _buildCategoryFilter(theme),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 24 : 16),
            child: _isGridLayout
                ? _buildMenuItemsGrid(filteredItems, isLargeScreen, theme)
                : _buildMenuItemsList(filteredItems, theme)),
        ),
      ],
    );
  }

 Widget _buildCategoryCard(Category category, ThemeData theme) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: Colors.black.withOpacity(0.1),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          _tabController.animateTo(1);
          _selectedCategoryFilter = category.name;
        });
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: 150, // Set a minimum height for the card
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              category.color.withOpacity(0.05),
              category.color.withOpacity(0.02),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Important to prevent overflow
            children: [
              Container(
                width: 48, // Reduced size
                height: 48, // Reduced size
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12), // Reduced radius
                ),
                child: Icon(Icons.fastfood_rounded,
                    size: 24, color: category.color), // Reduced icon size
              ),
              const SizedBox(height: 12), // Reduced spacing
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Add max lines
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
              const SizedBox(height: 8), // Reduced spacing
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8), // Reduced radius
                ),
                child: Text(
                  '${category.itemCount} items',
                  style: TextStyle(
                    fontSize: 11, // Reduced font size
                    fontWeight: FontWeight.w500,
                    color: category.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildAddCategoryCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showAddDialog(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade50,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  child: Icon(Icons.add_rounded,
                      size: 32, color: theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemsGrid(
      List<MenuItem> items, bool isLargeScreen, ThemeData theme) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLargeScreen ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildMenuItemGridCard(items[index], theme),
    );
  }

  Widget _buildMenuItemsList(List<MenuItem> items, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildMenuItemCard(items[index], theme),
    );
  }

  Widget _buildMenuItemGridCard(MenuItem item, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showMenuItemDetails(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.grey.shade100,
                  child: item.image != null
                      ? Image.asset(item.image!,
                          fit: BoxFit.cover,
                          color: !item.isAvailable
                              ? Colors.black.withOpacity(0.3)
                              : null,
                          colorBlendMode: !item.isAvailable
                              ? BlendMode.darken
                              : BlendMode.dst)
                      : Center(
                          child: Icon(Icons.fastfood_rounded,
                              size: 60,
                              color: Colors.grey.shade400),
                        )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!item.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Unavailable',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Switch.adaptive(
                        value: item.isAvailable,
                        onChanged: (value) {
                          setState(() {
                            item.isAvailable = value;
                          });
                        },
                        activeColor: theme.colorScheme.primary,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.edit_rounded,
                            size: 20, color: Colors.grey.shade700),
                        onPressed: () => _showEditMenuItemDialog(item),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem item, ThemeData theme) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showMenuItemDetails(item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade100,
                  child: item.image != null
                      ? Image.asset(item.image!,
                          fit: BoxFit.cover,
                          color: !item.isAvailable
                              ? Colors.black.withOpacity(0.3)
                              : null,
                          colorBlendMode: !item.isAvailable
                              ? BlendMode.darken
                              : BlendMode.dst)
                      : Center(
                          child: Icon(Icons.fastfood_rounded,
                              size: 36,
                              color: Colors.grey.shade400),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!item.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Unavailable',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Switch.adaptive(
                    value: item.isAvailable,
                    onChanged: (value) {
                      setState(() {
                        item.isAvailable = value;
                      });
                    },
                    activeColor: theme.colorScheme.primary,
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_rounded,
                        size: 20, color: Colors.grey.shade700),
                    onPressed: () => _showEditMenuItemDialog(item),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategoryFilter,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded,
              color: Colors.grey.shade700),
          items: [
            DropdownMenuItem(
              value: 'All',
              child: Text('All Categories',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87)),
            ),
            ..._categories.map((category) => DropdownMenuItem(
                  value: category.name,
                  child: Text(category.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87)),
                )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCategoryFilter = value!;
            });
          },
        ),
      ),
    );
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tabController.index == 0
                      ? 'Add New Category'
                      : 'Add New Menu Item',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                _tabController.index == 0
                    ? _buildAddCategoryForm()
                    : _buildAddMenuItemForm(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          // Handle save logic
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditMenuItemDialog(MenuItem item) {
    final TextEditingController nameController =
        TextEditingController(text: item.name);
    final TextEditingController priceController =
        TextEditingController(text: item.price.toString());
    final TextEditingController descController =
        TextEditingController(text: item.description);
    String? selectedCategory = item.category;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Menu Item',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      value: selectedCategory,
                      items: _categories
                          .map((category) => DropdownMenuItem(
                                value: category.name,
                                child: Text(
                                  category.name,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedCategory = value;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.amberAccent,
                        ),
                        onPressed: () {
                          // TODO: Handle save logic here
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMenuItemDetails(MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: item.image != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        child: Image.asset(item.image!,
                            fit: BoxFit.cover,
                            color: !item.isAvailable
                                ? Colors.black.withOpacity(0.3)
                                : null,
                            colorBlendMode: !item.isAvailable
                                ? BlendMode.darken
                                : BlendMode.dst),
                      )
                    : Center(
                        child: Icon(Icons.fastfood_rounded,
                            size: 80,
                            color: Colors.grey.shade400),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        const Text(
                          'Availability:',
                          style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                        ),
                        const SizedBox(width: 16),
                        Switch.adaptive(
                          value: item.isAvailable,
                          onChanged: (value) {
                            setState(() {
                              item.isAvailable = value;
                            });
                            Navigator.pop(context);
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showEditMenuItemDialog(item);
                          },
                          icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                          label: const Text(
                            'Edit Item',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCategoryForm() {
    final TextEditingController nameController = TextEditingController();
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Category Name',
        labelStyle: TextStyle(color: Colors.grey.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildAddMenuItemForm() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    String? selectedCategory;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Item Name',
            labelStyle: TextStyle(color: Colors.grey.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: 'Price',
            labelStyle: TextStyle(color: Colors.grey.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: TextStyle(color: Colors.grey.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: TextStyle(color: Colors.grey.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          value: selectedCategory,
          items: _categories
              .map((category) => DropdownMenuItem(
                    value: category.name,
                    child: Text(
                      category.name,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ))
              .toList(),
          onChanged: (value) => selectedCategory = value,
        ),
      ],
    );
  }
}

class Category {
  final String id;
  final String name;
  final int itemCount;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.color,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  bool isAvailable;
  final String? image;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.isAvailable,
    this.image,
    required this.description,
  });
}