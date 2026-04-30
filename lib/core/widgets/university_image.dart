import 'package:flutter/material.dart';

class UniversityImage extends StatelessWidget {
  final String imageUrl;

  const UniversityImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,

      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },

      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.image_not_supported, size: 40),
          ),
        );
      },
    );
  }
}