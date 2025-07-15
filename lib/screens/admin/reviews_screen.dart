import 'package:flutter/material.dart';
import '../../models/review.dart';
import '../../services/storage_service.dart';

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Review> reviews = [];
  List<Review> filteredReviews = [];
  String selectedRatingFilter = 'All Ratings';

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _searchController.addListener(_filterReviews);
  }

  void _loadReviews() {
    final reviewsData = StorageService.getList('reviews');
    setState(() {
      reviews = reviewsData.map((data) => Review.fromMap(data)).toList();
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      filteredReviews = List.from(reviews);
    });
  }

  void _filterReviews() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredReviews = reviews.where((review) {
        final matchesSearch = review.userName.toLowerCase().contains(query) ||
            review.accommodationName.toLowerCase().contains(query) ||
            review.comment.toLowerCase().contains(query);
        final matchesRating = selectedRatingFilter == 'All Ratings' ||
            review.rating.toString() == selectedRatingFilter;
        return matchesSearch && matchesRating;
      }).toList();
    });
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFFFBBF24),
          size: 16,
        );
      }),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return const Color(0xFF10B981);
    if (rating >= 3) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final averageRating = reviews.isEmpty 
        ? 0.0 
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews Management',
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
                          'Total Reviews',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${reviews.length}',
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
                          'Average Rating',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildStarRating(averageRating.round()),
                          ],
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
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search reviews...',
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
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: selectedRatingFilter,
                  items: const [
                    DropdownMenuItem(value: 'All Ratings', child: Text('All Ratings')),
                    DropdownMenuItem(value: '5', child: Text('5 Stars')),
                    DropdownMenuItem(value: '4', child: Text('4 Stars')),
                    DropdownMenuItem(value: '3', child: Text('3 Stars')),
                    DropdownMenuItem(value: '2', child: Text('2 Stars')),
                    DropdownMenuItem(value: '1', child: Text('1 Star')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRatingFilter = value!;
                      _filterReviews();
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
          
          // Reviews List
          Expanded(
            child: filteredReviews.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star_outline, size: 64, color: Color(0xFF94A3B8)),
                        SizedBox(height: 16),
                        Text(
                          'No reviews found',
                          style: TextStyle(fontSize: 18, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF2563EB),
                                    child: Text(
                                      review.userName.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        Text(
                                          review.accommodationName,
                                          style: const TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getRatingColor(review.rating),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.star, color: Colors.white, size: 14),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${review.rating}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                                        style: const TextStyle(
                                          color: Color(0xFF94A3B8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                review.comment,
                                style: const TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
