import 'package:flutter/material.dart';

class UiRecipe extends StatefulWidget {
  const UiRecipe({Key? key}) : super(key: key);

  @override
  _UiRecipeState createState() => _UiRecipeState();
}

class _UiRecipeState extends State<UiRecipe> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Recipe%20card-f3QE9SnKHLXc0RSNBknEHpSYm29U2g.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Creamy Roasted Pumpkin Soup',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(3, (index) => const Icon(Icons.star, color: Colors.orange, size: 18)),
                      const Icon(Icons.star_half, color: Colors.orange, size: 18),
                      const Icon(Icons.star_border, color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                      const Text('3.5 (163)', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(Icons.access_time, '30 min'),
                      _buildInfoItem(Icons.local_fire_department, '317 kcal'),
                      _buildInfoItem(Icons.person_outline, '1 serve'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Super creamy dairy-free pumpkin soup, with a little help from coconut milk or cream. It would be a welcome addition to your holiday table.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Ingredients'),
                      Tab(text: 'Instructions'),
                      Tab(text: 'Nutrition'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIngredientsTab(),
                _buildInstructionsTab(),
                _buildNutritionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildIngredientsTab() {
    final ingredients = [
      '4 tablespoons olive oil, divided',
      'One 4-pound sugar pie pumpkin',
      '1 large yellow onion, chopped',
      '4 large or 6 medium garlic cloves, pressed or minced',
      '½ teaspoon sea salt',
      '½ teaspoon ground cinnamon',
      '½ teaspoon ground nutmeg',
      '⅛ teaspoon cloves',
      'Tiny dash of cayenne pepper',
      'Freshly ground black pepper',
      '4 cups (32 ounces) vegetable broth',
      '½ cup full fat coconut milk or heavy cream',
      '2 tablespoons maple syrup or honey',
      '¼ cup pepitas (green pumpkin seeds)'
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.check, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(ingredients[index]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab() {
    final instructions = [
      'Preheat oven to 425 degrees Fahrenheit and line a baking sheet with parchment paper for easy cleanup. Carefully halve the pumpkin and scoop out the seeds.',
      'Slice each pumpkin halve in half to make quarters. Brush or rub 1 tablespoon olive oil over the flesh of the pumpkin and place the quarters, cut sides down, onto the baking sheet. Roast for 35 minutes or longer, until the orange flesh is easily pierced through with a fork.',
      'Heat the remaining 3 tablespoons olive oil in a large Dutch oven or heavy-bottomed pot over medium heat. Once the oil is shimmering, add onion, garlic and salt to the skillet. Stir to combine. Cook, stirring occasionally, until onion is translucent, about 8 to 10 minutes.',
      'Add the pumpkin flesh, cinnamon, nutmeg, cloves, cayenne pepper (if using), and a few twists of freshly ground black pepper. Use your stirring spoon to break up the pumpkin a bit. Pour in the broth. Bring the mixture to a boil, then reduce heat and simmer for about 15 minutes, to give the flavors time to meld.',
      'Once the pumpkin mixture is done cooking, stir in the coconut milk and maple syrup. Remove the soup from heat and let it cool slightly.',
      'Transfer the puréed soup to a serving bowl and repeat with the remaining batches. Taste and adjust if necessary.'
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.green,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instructions[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNutritionCircle('Carbs', 0.59, '59%'),
            _buildNutritionCircle('Protein', 0.16, '16%'),
            _buildNutritionCircle('Fat', 0.25, '25%'),
          ],
        ),
        const SizedBox(height: 24),
        _buildNutritionRow('Protein', '6g'),
        _buildNutritionRow('Carbs', '20g'),
        _buildNutritionRow('Fat', '24g'),
        _buildNutritionRow('Sugars', '6g'),
        _buildNutritionRow('Fibre', '0g'),
        _buildNutritionRow('Salt', '0.54g'),
      ],
    );
  }

  Widget _buildNutritionCircle(String label, double percentage, String text) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
                strokeWidth: 8,
              ),
            ),
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
