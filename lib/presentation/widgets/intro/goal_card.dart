import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.green : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isSelected ? Colors.green.shade700 : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 