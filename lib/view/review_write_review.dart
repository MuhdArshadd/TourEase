import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReviewWriteReviewPage extends StatefulWidget {
  const ReviewWriteReviewPage({super.key});

  @override
  _ReviewWriteReviewPageState createState() => _ReviewWriteReviewPageState();
}

class _ReviewWriteReviewPageState extends State<ReviewWriteReviewPage> {
  int _selectedRating = 0;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = []; // Track selected images
  final TextEditingController _reviewController = TextEditingController();

  // Function to pick images
  Future<void> _pickMedia() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images); // Add selected images to the list
        });
      }
    } catch (e) {
      // Handle any errors
      print(e);
    }
  }

  // Function to remove an image
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index); // Remove image by index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petronas Twin Tower'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Review Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile and Name
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: AssetImage('assets/profile_picture.jpg'),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Hana',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Interactive Star Rating
                    StarRating(
                      rating: _selectedRating,
                      starSize: 30.0,
                      onRatingSelected: (rating) {
                        setState(() {
                          _selectedRating = rating;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Review Text Field
                    TextField(
                      controller: _reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Share details of your own experience at this place',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Add Photos & Videos Button
                    ElevatedButton.icon(
                      onPressed: _pickMedia,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Add photos & videos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Display selected images with remove option
                    if (_selectedImages.isNotEmpty)
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: List.generate(_selectedImages.length, (index) {
                          return Stack(
                            children: [
                              Image.file(
                                File(_selectedImages[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () {
                                    _removeImage(index); // Remove image when pressed
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // Submit Review Button
            Center(
              child: ElevatedButton(
                onPressed: _selectedRating > 0 && _reviewController.text.isNotEmpty
                    ? () {
                  print('Rating: $_selectedRating');
                  print('Review: ${_reviewController.text}');
                  print('Selected images: ${_selectedImages.map((img) => img.path).toList()}');
                  Navigator.pop(context); // Return to the previous page
                }
                    : null, // Disable button if validation fails
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;
  final double starSize;
  final Color starColor;
  final ValueChanged<int> onRatingSelected;

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 24.0,
    this.starColor = Colors.amber,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: starColor,
            size: starSize,
          ),
          onPressed: () {
            onRatingSelected(index + 1);
          },
        );
      }),
    );
  }
}
