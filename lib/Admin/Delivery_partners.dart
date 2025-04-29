import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryManagementScreen extends StatefulWidget {
  const DeliveryManagementScreen({super.key});

  @override
  State<DeliveryManagementScreen> createState() => _DeliveryManagementScreenState();
}

class _DeliveryManagementScreenState extends State<DeliveryManagementScreen> {
  final List<DeliveryPerson> deliveryPersons = [
    DeliveryPerson(
      id: 'DEL001',
      name: 'Rahul Sharma',
      email: 'rahul.sharma@example.com',
      phone: '+91 9876543210',
      vehicleNumber: 'MH01AB1234',
      joiningDate: DateTime(2023, 1, 15),
      status: DeliveryStatus.active,
      payments: [
        DeliveryPayment(
          id: 'PAY001',
          date: DateTime(2023, 6, 1), 
          amount: 1200, 
          status: PaymentStatus.paid
        ),
        DeliveryPayment(
          id: 'PAY002',
          date: DateTime(2023, 6, 2), 
          amount: 950, 
          status: PaymentStatus.paid
        ),
        DeliveryPayment(
          id: 'PAY003',
          date: DateTime(2023, 6, 3), 
          amount: 1100, 
          status: PaymentStatus.pending
        ),
      ],
    ),
    DeliveryPerson(
      id: 'DEL002',
      name: 'Vikram Patel',
      email: 'vikram.patel@example.com',
      phone: '+91 8765432109',
      vehicleNumber: 'MH02CD5678',
      joiningDate: DateTime(2023, 3, 10),
      status: DeliveryStatus.active,
      payments: [
        DeliveryPayment(
          id: 'PAY004',
          date: DateTime(2023, 6, 1), 
          amount: 850, 
          status: PaymentStatus.paid
        ),
        DeliveryPayment(
          id: 'PAY005',
          date: DateTime(2023, 6, 2), 
          amount: 750, 
          status: PaymentStatus.paid
        ),
        DeliveryPayment(
          id: 'PAY006',
          date: DateTime(2023, 6, 3), 
          amount: 900, 
          status: PaymentStatus.pending
        ),
      ],
    ),
    DeliveryPerson(
      id: 'DEL003',
      name: 'Sanjay Gupta',
      email: 'sanjay.gupta@example.com',
      phone: '+91 7654321098',
      vehicleNumber: 'MH03EF9012',
      joiningDate: DateTime(2023, 5, 20),
      status: DeliveryStatus.inactive,
      payments: [
        DeliveryPayment(
          id: 'PAY007',
          date: DateTime(2023, 6, 1), 
          amount: 700, 
          status: PaymentStatus.paid
        ),
        DeliveryPayment(
          id: 'PAY008',
          date: DateTime(2023, 6, 2), 
          amount: 650, 
          status: PaymentStatus.pending
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: deliveryPersons.length,
        itemBuilder: (context, index) {
          final person = deliveryPersons[index];
          return _buildDeliveryPersonCard(person, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDeliveryPersonDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDeliveryPersonCard(DeliveryPerson person, int index) {
    final pendingPayments = person.payments.where((p) => p.status == PaymentStatus.pending).length;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: () => _navigateToDetailScreen(person, index),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: person.status == DeliveryStatus.active
                        ? Colors.green[100]
                        : Colors.red[100],
                    child: Icon(
                      Icons.delivery_dining,
                      color: person.status == DeliveryStatus.active
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          person.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pendingPayments > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$pendingPayments pending',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${person.id}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  ElevatedButton(
                    onPressed: () => _showPaymentsDialog(person, index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text('Payments'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetailScreen(DeliveryPerson person, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryPersonDetailScreen(
          person: person,
          onUpdate: (updatedPerson) {
            setState(() {
              deliveryPersons[index] = updatedPerson;
            });
          },
          onDelete: () {
            setState(() {
              deliveryPersons.removeAt(index);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showPaymentsDialog(DeliveryPerson person, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${person.name}\'s Payments'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...person.payments.map((payment) => _buildPaymentListItem(
                    payment,
                    person,
                    index,
                    showActions: true,
                  )),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentListItem(
    DeliveryPayment payment, 
    DeliveryPerson person,
    int personIndex, {
    bool showActions = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              payment.status == PaymentStatus.paid 
                ? Icons.check_circle 
                : Icons.pending,
              color: payment.status == PaymentStatus.paid 
                ? Colors.green 
                : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${payment.amount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(payment.date),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            if (showActions)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (payment.status == PaymentStatus.pending)
                    IconButton(
                      icon: const Icon(Icons.payment, size: 20),
                      color: Colors.green,
                      onPressed: () => _markAsPaid(person, personIndex, payment),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    color: Colors.red,
                    onPressed: () => _deletePayment(person, personIndex, payment),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _markAsPaid(DeliveryPerson person, int personIndex, DeliveryPayment payment) {
    setState(() {
      deliveryPersons[personIndex] = person.copyWith(
        payments: person.payments.map((p) {
          if (p.id == payment.id) {
            return p.copyWith(status: PaymentStatus.paid);
          }
          return p;
        }).toList(),
      );
    });
  }

  void _deletePayment(DeliveryPerson person, int personIndex, DeliveryPayment payment) {
    setState(() {
      deliveryPersons[personIndex] = person.copyWith(
        payments: person.payments.where((p) => p.id != payment.id).toList(),
      );
    });
  }

  void _showAddDeliveryPersonDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final vehicleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Delivery Person'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: vehicleController,
                  decoration: const InputDecoration(labelText: 'Vehicle Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPerson = DeliveryPerson(
                  id: 'DEL${deliveryPersons.length + 1}'.padLeft(3, '0'),
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  vehicleNumber: vehicleController.text,
                  joiningDate: DateTime.now(),
                  status: DeliveryStatus.active,
                  payments: [],
                );
                setState(() {
                  deliveryPersons.add(newPerson);
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('All Delivery Persons'),
                onTap: () {
                  // Implement filter logic
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Active Only'),
                onTap: () {
                  // Implement filter logic
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('With Pending Payments'),
                onTap: () {
                  // Implement filter logic
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeliveryPersonDetailScreen extends StatefulWidget {
  final DeliveryPerson person;
  final Function(DeliveryPerson) onUpdate;
  final Function() onDelete;

  const DeliveryPersonDetailScreen({
    super.key,
    required this.person,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DeliveryPersonDetailScreen> createState() =>
      _DeliveryPersonDetailScreenState();
}

class _DeliveryPersonDetailScreenState extends State<DeliveryPersonDetailScreen> {
  late DeliveryPerson _currentPerson;
  final _paymentAmountController = TextEditingController();
  final List<DeliveryPayment> _selectedPayments = [];

  @override
  void initState() {
    super.initState();
    _currentPerson = widget.person;
  }

  @override
  Widget build(BuildContext context) {
    final unpaidAmount = _currentPerson.payments
        .where((payment) => payment.status == PaymentStatus.pending)
        .fold(0.0, (sum, payment) => sum + payment.amount);

    final monthlyEarnings = _currentPerson.payments
        .where((payment) =>
            payment.date.month == DateTime.now().month &&
            payment.date.year == DateTime.now().year)
        .fold(0.0, (sum, payment) => sum + payment.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPerson.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildStatsRow(unpaidAmount, monthlyEarnings),
            const SizedBox(height: 20),
            _buildPaymentSection(),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedPayments.isNotEmpty)
            FloatingActionButton(
              heroTag: 'paySelected',
              onPressed: _paySelectedPayments,
              backgroundColor: Colors.green,
              child: const Icon(Icons.payment),
            ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addPayment',
            onPressed: _showAddPaymentDialog,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _currentPerson.status == DeliveryStatus.active
                      ? Colors.green[100]
                      : Colors.red[100],
                  child: Icon(
                    Icons.person,
                    color: _currentPerson.status == DeliveryStatus.active
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentPerson.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${_currentPerson.id}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.email, _currentPerson.email),
            _buildDetailRow(Icons.phone, _currentPerson.phone),
            _buildDetailRow(Icons.directions_bike, _currentPerson.vehicleNumber),
            _buildDetailRow(
              Icons.calendar_today,
              'Joined on ${DateFormat('dd MMM yyyy').format(_currentPerson.joiningDate)}',
            ),
            _buildDetailRow(
              Icons.circle,
              'Status: ${_currentPerson.status == DeliveryStatus.active ? 'Active' : 'Inactive'}',
              color: _currentPerson.status == DeliveryStatus.active
                  ? Colors.green
                  : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text, style: TextStyle(color: color ?? Colors.grey[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(double unpaidAmount, double monthlyEarnings) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Pending Payments',
            '₹${unpaidAmount.toStringAsFixed(2)}',
            Colors.orange,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'This Month',
            '₹${monthlyEarnings.toStringAsFixed(2)}',
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (_currentPerson.payments.isNotEmpty)
              TextButton(
                onPressed: _toggleSelectMode,
                child: Text(
                  _selectedPayments.isNotEmpty ? 'Cancel' : 'Select',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (_currentPerson.payments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('No payments recorded yet')),
          ),
        if (_currentPerson.payments.isNotEmpty)
          ..._currentPerson.payments.map((payment) {
            return _buildPaymentListItem(payment);
          }).toList(),
      ],
    );
  }

  Widget _buildPaymentListItem(DeliveryPayment payment) {
    final isSelected = _selectedPayments.contains(payment);
    
    return InkWell(
      onLongPress: _selectedPayments.isEmpty ? () {
        setState(() {
          _selectedPayments.add(payment);
        });
      } : null,
      onTap: _selectedPayments.isNotEmpty ? () {
        setState(() {
          if (isSelected) {
            _selectedPayments.remove(payment);
          } else {
            _selectedPayments.add(payment);
          }
        });
      } : null,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: isSelected ? Colors.blue[50] : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (_selectedPayments.isNotEmpty)
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              if (_selectedPayments.isNotEmpty) const SizedBox(width: 8),
              Icon(
                payment.status == PaymentStatus.paid 
                  ? Icons.check_circle 
                  : Icons.pending,
                color: payment.status == PaymentStatus.paid 
                  ? Colors.green 
                  : Colors.orange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${payment.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy').format(payment.date),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (_selectedPayments.isEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (payment.status == PaymentStatus.pending)
                      IconButton(
                        icon: const Icon(Icons.payment, size: 20),
                        color: Colors.green,
                        onPressed: () => _markPaymentAsPaid(payment),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      color: Colors.red,
                      onPressed: () => _deletePayment(payment),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSelectMode() {
    setState(() {
      if (_selectedPayments.isNotEmpty) {
        _selectedPayments.clear();
      }
    });
  }

  void _paySelectedPayments() {
    setState(() {
      _currentPerson = _currentPerson.copyWith(
        payments: _currentPerson.payments.map((payment) {
          if (_selectedPayments.contains(payment)) {
            return payment.copyWith(status: PaymentStatus.paid);
          }
          return payment;
        }).toList(),
      );
      _selectedPayments.clear();
    });
    widget.onUpdate(_currentPerson);
  }

  void _markPaymentAsPaid(DeliveryPayment payment) {
    setState(() {
      _currentPerson = _currentPerson.copyWith(
        payments: _currentPerson.payments.map((p) {
          if (p.id == payment.id) {
            return p.copyWith(status: PaymentStatus.paid);
          }
          return p;
        }).toList(),
      );
    });
    widget.onUpdate(_currentPerson);
  }

  void _deletePayment(DeliveryPayment payment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this payment record?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() {
                  _currentPerson = _currentPerson.copyWith(
                    payments: _currentPerson.payments.where((p) => p.id != payment.id).toList(),
                  );
                });
                widget.onUpdate(_currentPerson);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _currentPerson.name);
    final emailController = TextEditingController(text: _currentPerson.email);
    final phoneController = TextEditingController(text: _currentPerson.phone);
    final vehicleController = TextEditingController(text: _currentPerson.vehicleNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Delivery Person'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: vehicleController,
                  decoration: const InputDecoration(labelText: 'Vehicle Number'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DeliveryStatus>(
                  value: _currentPerson.status,
                  items: DeliveryStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status == DeliveryStatus.active
                          ? 'Active'
                          : 'Inactive'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _currentPerson = _currentPerson.copyWith(status: value);
                      });
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentPerson = _currentPerson.copyWith(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    vehicleNumber: vehicleController.text,
                  );
                });
                widget.onUpdate(_currentPerson);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this delivery person?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                widget.onDelete();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPaymentDialog() {
    _paymentAmountController.clear();
    final dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Payment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _paymentAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      dateController.text = DateFormat('dd/MM/yyyy').format(date);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(_paymentAmountController.text) ?? 0;
                if (amount > 0) {
                  final dateParts = dateController.text.split('/');
                  final date = DateTime(
                    int.parse(dateParts[2]),
                    int.parse(dateParts[1]),
                    int.parse(dateParts[0]),
                  );

                  setState(() {
                    _currentPerson = _currentPerson.copyWith(
                      payments: [
                        ..._currentPerson.payments,
                        DeliveryPayment(
                          id: 'PAY${_currentPerson.payments.length + 1}'.padLeft(3, '0'),
                          date: date,
                          amount: amount,
                          status: PaymentStatus.pending,
                        ),
                      ],
                    );
                  });
                  widget.onUpdate(_currentPerson);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

enum DeliveryStatus { active, inactive }
enum PaymentStatus { pending, paid }

class DeliveryPerson {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String vehicleNumber;
  final DateTime joiningDate;
  final DeliveryStatus status;
  final List<DeliveryPayment> payments;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.vehicleNumber,
    required this.joiningDate,
    required this.status,
    required this.payments,
  });

  DeliveryPerson copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? vehicleNumber,
    DateTime? joiningDate,
    DeliveryStatus? status,
    List<DeliveryPayment>? payments,
  }) {
    return DeliveryPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      joiningDate: joiningDate ?? this.joiningDate,
      status: status ?? this.status,
      payments: payments ?? this.payments,
    );
  }
}

class DeliveryPayment {
  final String id;
  final DateTime date;
  final double amount;
  final PaymentStatus status;

  DeliveryPayment({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
  });

  DeliveryPayment copyWith({
    String? id,
    DateTime? date,
    double? amount,
    PaymentStatus? status,
  }) {
    return DeliveryPayment(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      status: status ?? this.status,
    );
  }
}