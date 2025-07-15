import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back, Admin!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Here\'s what\'s happening with your business today',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.dashboard,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Section Title
            const Text(
              'Business Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            
            // Summary Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Total Bookings',
                              value: '101',
                              icon: Icons.book_online,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFEAB308)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              growth: '+12%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Available Rooms',
                              value: '3',
                              icon: Icons.hotel,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              growth: '-2%',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Available Cottages',
                              value: '12',
                              icon: Icons.cottage,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              growth: '+8%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Total Revenue',
                              value: '₱50k',
                              icon: Icons.attach_money,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF059669)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              growth: '+25%',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Mobile: 1 column
                  return Column(
                    children: [
                      _SummaryCard(
                        title: 'Total Bookings',
                        value: '101',
                        icon: Icons.book_online,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFEAB308)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        growth: '+12%',
                      ),
                      const SizedBox(height: 16),
                      _SummaryCard(
                        title: 'Available Rooms',
                        value: '3',
                        icon: Icons.hotel,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        growth: '-2%',
                      ),
                      const SizedBox(height: 16),
                      _SummaryCard(
                        title: 'Available Cottages',
                        value: '12',
                        icon: Icons.cottage,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        growth: '+8%',
                      ),
                      const SizedBox(height: 16),
                      _SummaryCard(
                        title: 'Total Revenue',
                        value: '₱50k',
                        icon: Icons.attach_money,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        growth: '+25%',
                      ),
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: 32),
            
            // Chart Section
            const Text(
              'Analytics Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              height: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Revenue Analytics',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Last 30 days',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              size: 48,
                              color: Color(0xFF94A3B8),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Chart/Graph Area',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Connect your analytics service',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final String growth;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.growth,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = growth.startsWith('+');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      growth,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}