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
      phone: '+91 9876543210',
      vehicleNumber: 'MH01AB1234',
      joiningDate: DateTime(2023, 1, 15),
      status: DeliveryStatus.active,
      payments: [
        DeliveryPayment(date: DateTime(2023, 6, 1), amount: 1200, isPaid: true),
        DeliveryPayment(date: DateTime(2023, 6, 2), amount: 950, isPaid: true),
        DeliveryPayment(date: DateTime(2023, 6, 3), amount: 1100, isPaid: false),
      ],
    ),
    DeliveryPerson(
      id: 'DEL002',
      name: 'Vikram Patel',
      phone: '+91 8765432109',
      vehicleNumber: 'MH02CD5678',
      joiningDate: DateTime(2023, 3, 10),
      status: DeliveryStatus.active,
      payments: [
        DeliveryPayment(date: DateTime(2023, 6, 1), amount: 850, isPaid: true),
        DeliveryPayment(date: DateTime(2023, 6, 2), amount: 750, isPaid: true),
        DeliveryPayment(date: DateTime(2023, 6, 3), amount: 900, isPaid: false),
      ],
    ),
    DeliveryPerson(
      id: 'DEL003',
      name: 'Sanjay Gupta',
      phone: '+91 7654321098',
      vehicleNumber: 'MH03EF9012',
      joiningDate: DateTime(2023, 5, 20),
      status: DeliveryStatus.inactive,
      payments: [
        DeliveryPayment(date: DateTime(2023, 6, 1), amount: 700, isPaid: true),
        DeliveryPayment(date: DateTime(2023, 6, 2), amount: 650, isPaid: false),
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
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDeliveryPersonDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: deliveryPersons.length,
        itemBuilder: (context, index) {
          final person = deliveryPersons[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
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
              title: Text(person.name),
              subtitle: Text('ID: ${person.id} | ${person.phone}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
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
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDeliveryPersonDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final vehicleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Delivery Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
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

  @override
  void initState() {
    super.initState();
    _currentPerson = widget.person;
  }

  @override
  Widget build(BuildContext context) {
    final unpaidAmount = _currentPerson.payments
        .where((payment) => !payment.isPaid)
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPaymentDialog,
        child: const Icon(Icons.add),
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
          Text(text, style: TextStyle(color: color ?? Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildStatsRow(double unpaidAmount, double monthlyEarnings) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Unpaid Amount',
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
        const Text(
          'Payment History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (_currentPerson.payments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('No payments recorded yet')),),
        if (_currentPerson.payments.isNotEmpty)
          ..._currentPerson.payments.map((payment) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  payment.isPaid ? Icons.check_circle : Icons.pending,
                  color: payment.isPaid ? Colors.green : Colors.orange,
                ),
                title: Text(
                  '₹${payment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('dd MMM yyyy').format(payment.date),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editPayment(payment),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () => _deletePayment(payment),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _currentPerson.name);
    final phoneController = TextEditingController(text: _currentPerson.phone);
    final vehicleController =
        TextEditingController(text: _currentPerson.vehicleNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Delivery Person'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Payment'),
          content: Column(
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
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Mark as paid'),
                value: true,
                onChanged: (value) {},
              ),
            ],
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
                  setState(() {
                    _currentPerson = _currentPerson.copyWith(
                      payments: [
                        ..._currentPerson.payments,
                        DeliveryPayment(
                          date: DateTime.now(),
                          amount: amount,
                          isPaid: true,
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

  void _editPayment(DeliveryPayment payment) {
    final amountController = TextEditingController(text: payment.amount.toString());
    final dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(payment.date),
    );
    var isPaid = payment.isPaid;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
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
                    initialDate: payment.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    dateController.text = DateFormat('dd/MM/yyyy').format(date);
                  }
                },
              ),
              CheckboxListTile(
                title: const Text('Paid'),
                value: isPaid,
                onChanged: (value) {
                  setState(() {
                    isPaid = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                final dateParts = dateController.text.split('/');
                final date = DateTime(
                  int.parse(dateParts[2]),
                  int.parse(dateParts[1]),
                  int.parse(dateParts[0]),
                );

                setState(() {
                  _currentPerson = _currentPerson.copyWith(
                    payments: _currentPerson.payments.map((p) {
                      if (p == payment) {
                        return p.copyWith(
                          amount: amount,
                          date: date,
                          isPaid: isPaid,
                        );
                      }
                      return p;
                    }).toList(),
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
                    payments: _currentPerson.payments.where((p) => p != payment).toList(),
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
}

enum DeliveryStatus { active, inactive }

class DeliveryPerson {
  final String id;
  final String name;
  final String phone;
  final String vehicleNumber;
  final DateTime joiningDate;
  final DeliveryStatus status;
  final List<DeliveryPayment> payments;

  DeliveryPerson({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleNumber,
    required this.joiningDate,
    required this.status,
    required this.payments,
  });

  DeliveryPerson copyWith({
    String? id,
    String? name,
    String? phone,
    String? vehicleNumber,
    DateTime? joiningDate,
    DeliveryStatus? status,
    List<DeliveryPayment>? payments,
  }) {
    return DeliveryPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      joiningDate: joiningDate ?? this.joiningDate,
      status: status ?? this.status,
      payments: payments ?? this.payments,
    );
  }
}

class DeliveryPayment {
  final DateTime date;
  final double amount;
  final bool isPaid;

  DeliveryPayment({
    required this.date,
    required this.amount,
    required this.isPaid,
  });

  DeliveryPayment copyWith({
    DateTime? date,
    double? amount,
    bool? isPaid,
  }) {
    return DeliveryPayment(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}