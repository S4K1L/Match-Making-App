import 'package:flutter/material.dart';
import 'package:flutter_extension/model/like_you_model.dart';

class LikeCard extends StatelessWidget {
  const LikeCard({super.key, required this.image, required this.user});

  final String image;
  final LikeYouModel user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage('assets/images/amiliva.png')
                          as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 5,
          left: 10,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: user.isOnline == true
                        ? const Color(0xFF00CD07)
                        : Colors.grey,
                    size: 6,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.isOnline == true ? "Active" : "Offline",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                user.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    "${user.distance ?? 0} km",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
