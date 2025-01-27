import 'package:flutter/material.dart';
import 'child_form.dart';
import 'allergy_grid.dart';
import 'goal_card.dart';

class IntroContent extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? image;
  final bool showButton;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showCards;
  final List<GoalCard>? cards;
  final bool showAllergies;
  final bool showRecipeGrid;
  final bool centerContent;
  final bool showChildForm;
  final GlobalKey<FormState>? formKey;

  const IntroContent({
    super.key,
    required this.title,
    this.subtitle,
    this.image,
    this.showButton = false,
    this.buttonText,
    this.onButtonPressed,
    this.showCards = false,
    this.cards,
    this.showAllergies = false,
    this.showRecipeGrid = false,
    this.centerContent = false,
    this.showChildForm = false,
    this.formKey,
  });

  @override
  State<IntroContent> createState() => _IntroContentState();
}

class _IntroContentState extends State<IntroContent> {
  final childFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.green.shade50],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: widget.centerContent
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                textAlign:
                    widget.centerContent ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  height: 1.2,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.subtitle!,
                  textAlign:
                      widget.centerContent ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
              if (widget.image != null) ...[
                const SizedBox(height: 30),
                Expanded(
                  flex: 6,
                  child: Image.asset(
                    widget.image!,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ],
              if (widget.showCards && widget.cards != null) ...[
                const SizedBox(height: 20),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.cards!.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => widget.cards![index],
                  ),
                ),
              ],
              if (widget.showAllergies)
                Expanded(
                  flex: 4,
                  child: const AllergyGrid(),
                ),
              if (widget.showRecipeGrid)
                Expanded(
                  flex: 4,
                  child: _buildRecipeGrid(),
                ),
              if (widget.showChildForm)
                Expanded(
                  flex: 5,
                  child: ChildForm(
                    formKey: widget.formKey,
                  ),
                ),
              if (widget.showButton) ...[
                const Spacer(),
                _buildContinueButton(),
                const SizedBox(height: 60),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeGrid() {
    final List<String> recipeImages = [
      'assets/images/pic1.png',
      'assets/images/pic2.png',
      'assets/images/pic3.png',
      'assets/images/pic4.png',
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1,
      ),
      itemCount: recipeImages.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              recipeImages[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (widget.showChildForm) {
            if (widget.formKey?.currentState?.validate() ?? false) {
              widget.onButtonPressed?.call();
            }
          } else {
            widget.onButtonPressed?.call();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          widget.buttonText!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
