import 'package:flutter/material.dart';


class FavouritePlacesPage extends StatelessWidget {
  final List<Map<String, String>> places = [
    {
      'title': 'Klebang Beach, Melaka',
      'description':
      'A popular coastal spot known for its sandy shores and scenic sunsets. The area is famous for its coconut shakes and lively atmosphere.',
    },
    {
      'title': 'Batu Caves, Selangor',
      'description':
      'Popular Hindu temple complex set within limestone caves. It features a towering statue of Lord Murugan and 272 colorful steps leading to the main temple cave.',
    },
    {
      'title': 'Petronas Twin Towers, Kuala Lumpur',
      'description':
      'Standing at 452 meters, the Petronas Twin Towers are the tallest twin structures in the world. They offer stunning views of the city from the Skybridge.',
    },
    {
      'title': 'Mount Kinabalu, Sabah',
      'description':
      'The highest peak in Southeast Asia, standing at 4,095 meters. It is a UNESCO World Heritage Site, offering breathtaking views and diverse flora and fauna.',
    },
  ];

  FavouritePlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Favourite Places',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300, // Placeholder for image
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    places[index]['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    places[index]['description']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 16, color: Colors.grey.shade300),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
