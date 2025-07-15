import 'package:flutter/material.dart';
import '../../models/payment.dart';
import '../../services/storage_service.dart';

class AdminPaymentsScreen extends StatefulWidget {
  const AdminPaymentsScreen({super.key});

  @override
  State<AdminPaymentsScreen> createState() => _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState extends State<AdminPaymentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Payment> payments = [];
  List<Payment> filteredPayments = [];
  String selectedStatusFilter = 'All Status';
  String selectedMethodFilter = 'All Methods';

  @override
  void initState() {
    super.initState();
    _loadPayments();
    _searchController.addListener(_filterPayments);
  }

  void _loadPayments() {
    final paymentsData = StorageService.getList('payments');
    setState(() {
      payments = paymentsData.map((data) => Payment.fromMap(data)).toList();
      payments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      filteredPayments = List.from(payments);
    });
  }

  void _filterPayments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPayments = payments.where((payment) {
        final matchesSearch = payment.bookingId.toLowerCase().contains(query) ||
            payment.referenceNumber?.toLowerCase().contains(query) == true;
        final matchesStatus = selectedStatusFilter == 'All Status' ||
            payment.status.toString().split('.').last == selectedStatusFilter.toLowerCase();
        final matchesMethod = selectedMethodFilter == 'All Methods' ||
            payment.method.toString().split('.').last == selectedMethodFilter.toLowerCase();
        return matchesSearch && matchesStatus && matchesMethod;
      }).toList();
    });
  }

  void _updatePaymentStatus(Payment payment, PaymentStatus newStatus) {
    final updatedPayment = Payment(
      id: payment.id,
      bookingId: payment.bookingId,
      userId: payment.userId,
      amount: payment.amount,
      method: payment.method,
      status: newStatus,
      createdAt: payment.createdAt,
      referenceNumber: payment.referenceNumber,
      notes: payment.notes,
      proofImageUrl: payment.proofImageUrl,
    );

    final paymentIndex = payments.indexWhere((p) => p.id == payment.id);
    if (paymentIndex != -1) {
      setState(() {
        payments[paymentIndex] = updatedPayment;
        StorageService.setList('payments', payments.map((p) => p.toMap()).toList());
        _filterPayments();
      });
    }
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return const Color(0xFFF59E0B);
      case PaymentStatus.completed:
        return const Color(0xFF10B981);
      case PaymentStatus.failed:
        return const Color(0xFFEF4444);
    }
  }

  String _getStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }

  String _getMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.gcash:
        return 'GCash';
      case PaymentMethod.paypal:
        return 'PayPal';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = payments.where((p) => p.status == PaymentStatus.completed)
        .fold(0.0, (sum, payment) => sum + payment.amount);
    final pendingCount = payments.where((p) => p.status == PaymentStatus.pending).length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payments Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 24),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Revenue',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₱${totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pending Payments',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$pendingCount',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Payments',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${payments.length}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Filters
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search payments...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatusFilter,
                  items: const [
                    DropdownMenuItem(value: 'All Status', child: Text('All Status')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'Failed', child: Text('Failed')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatusFilter = value!;
                      _filterPayments();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedMethodFilter,
                  items: const [
                    DropdownMenuItem(value: 'All Methods', child: Text('All Methods')),
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'GCash', child: Text('GCash')),
                    DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer')),
                    DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
                    DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedMethodFilter = value!;
                      _filterPayments();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Payments Table
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: filteredPayments.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.payment, size: 64, color: Color(0xFF94A3B8)),
                          SizedBox(height: 16),
                          Text(
                            'No payments found',
                            style: TextStyle(fontSize: 18, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                        columns: const [
                          DataColumn(label: Text('Payment ID', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Booking ID', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Method', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Reference', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.w600))),
                          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                        ],
                        rows: filteredPayments.map((payment) {
                          return DataRow(
                            cells: [
                              DataCell(Text(payment.id)),
                              DataCell(Text(payment.bookingId)),
                              DataCell(Text('₱${payment.amount.toStringAsFixed(0)}')),
                              DataCell(Text(_getMethodText(payment.method))),
                              DataCell(Text(payment.referenceNumber ?? 'N/A')),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(payment.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getStatusText(payment.status),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text('${payment.createdAt.day}/${payment.createdAt.month}/${payment.createdAt.year}')),
                              DataCell(
                                payment.status == PaymentStatus.pending
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.check, color: Color(0xFF10B981)),
                                            onPressed: () => _updatePaymentStatus(payment, PaymentStatus.completed),
                                            tooltip: 'Approve Payment',
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.close, color: Color(0xFFEF4444)),
                                            onPressed: () => _updatePaymentStatus(payment, PaymentStatus.failed),
                                            tooltip: 'Reject Payment',
                                          ),
                                        ],
                                      )
                                    : Text(_getStatusText(payment.status)),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
