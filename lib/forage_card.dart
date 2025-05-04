import 'package:flutter/material.dart';

class ForageCard extends StatelessWidget {
  const ForageCard({
    super.key,
    required this.plantName,
    required this.plantImage,
    required this.plantDescription,
    required this.onClick,
  });

  final String plantName;
  final String plantImage;
  final String plantDescription;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with subtle gradient overlay
            Stack(
              children: [
                Image.asset(
                  plantImage,
                  fit: BoxFit.cover,
                  height: 160,
                  width: double.infinity,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant name with modern typography
                  Text(
                    plantName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Description with improved readability
                  Text(
                    plantDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Minimalist "Learn more" indicator
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
