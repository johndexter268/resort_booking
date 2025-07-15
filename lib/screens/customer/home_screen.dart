import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Experience Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
            child: Column(
              children: [
                const Text(
                  'Experience the Best of Beach Life',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Inter',
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: NetworkImage(
                              '../../assets/images/image1.jpg?w=400',
                            ), // Beach sunset placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: NetworkImage(
                              '../../assets/images/image2.png?w=400',
                            ), // Beach huts placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: NetworkImage(
                              '../../assets/images/image3.jpg?w=400',
                            ), // Room interior placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to accommodations
                    DefaultTabController.of(context).animateTo(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'View More',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          // Testimonials Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
            color: const Color(0xFFF8FAFC),
            child: Column(
              children: [
                const Text(
                  'What Our Guests Say',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Inter',
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                // First row of testimonials
                Row(
                  children: [
                    Expanded(
                      child: _buildTestimonialCard(
                        "The most beautiful beach I've ever seen. The staff was incredibly attentive and the food was amazing. Can't wait to come back!",
                        "Michael T.",
                        5,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTestimonialCard(
                        "The view, the vibe, and the service were all top-notch. Perfect spot for a relaxing getaway.",
                        "Lisa R.",
                        5,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTestimonialCard(
                        "Our family had the best vacation ever! The kids loved the activities and we enjoyed the spa. The booking process was seamless and wonderful.",
                        "Sara H.",
                        5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Second row of testimonials
                Row(
                  children: [
                    Expanded(
                      child: _buildTestimonialCard(
                        "The most beautiful beach I've ever seen. The staff was incredibly attentive and the food was amazing. Can't wait to come back!",
                        "Chris D.",
                        5,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTestimonialCard(
                        "Loved every moment. From the hammocks under the palms to the ocean breeze—pure bliss.",
                        "Lara K.",
                        5,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildTestimonialCard(
                        "My kids had a blast with the activities, and we enjoyed the spa and the seafood. A great experience for all ages.",
                        "Monica L.",
                        5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(String review, String name, int rating) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '"$review"',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              fontFamily: 'Inter',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFFBBF24),
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 12),
          CircleAvatar(
            backgroundColor: const Color(0xFF2563EB),
            radius: 20,
            child: Text(
              name.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
