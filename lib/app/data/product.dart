// // lib/data/products.dart

// import 'package:test_ecommerce_app/app/models/product_model.dart';

// final List<Product> products = [
//   // Bangles
//   Product(
//     id: 'b1',
//     name: 'Traditional Gold Bangle',
//     description:
//         'Handcrafted 22K gold bangle featuring intricate traditional motifs with antique finish',
//     price: 45999.99,
//     imageUrls: ['assets/Images/b1-1.jpg', 'assets/Images/b1-2.jpg'],
//     category: 'Bangles',
//     rating: 4.8,
//     stock: 10,
//     material: '22K Gold',
//     isFeatured: true,
//   ),
//   Product(
//     id: 'b2',
//     name: 'Diamond Studded Kada',
//     description:
//         'Contemporary gold kada with brilliant-cut diamonds in floral pattern',
//     price: 89999.99,
//     imageUrls: ['assets/Images/b2-1.jpg', 'assets/Images/b2-2.jpg'],
//     category: 'Bangles',
//     rating: 4.9,
//     stock: 5,
//     material: '18K Gold with Diamonds',
//   ),
//   Product(
//     id: 'b3',
//     name: 'Pearl Embellished Bangle',
//     description: 'Elegant bangle with freshwater pearls and meenakari work',
//     price: 35999.99,
//     imageUrls: ['assets/Images/b3-1.jpg', 'assets/Images/b3-2.jpg'],
//     category: 'Bangles',
//     rating: 4.7,
//     stock: 8,
//     material: '22K Gold with Pearls',
//   ),
//   Product(
//     id: 'b4',
//     name: 'Antique Kundan Bangle',
//     description: 'Traditional kundan bangle with intricate enamel work',
//     price: 67999.99,
//     imageUrls: ['assets/Images/b4-1.jpg', 'assets/Images/b4-2.jpg'],
//     category: 'Bangles',
//     rating: 4.6,
//     stock: 12,
//     material: '22K Gold with Kundan',
//   ),

//   // Earrings
//   Product(
//     id: 'e1',
//     name: 'Solitaire Diamond Studs',
//     description: 'Classic solitaire diamond studs in prong setting',
//     price: 129999.99,
//     imageUrls: ['assets/Images/e1-1.jpg', 'assets/Images/e1-2.jpg'],
//     category: 'Earrings',
//     rating: 4.9,
//     stock: 6,
//     material: '18K White Gold with Diamonds',
//     isFeatured: true,
//   ),
//   Product(
//     id: 'e2',
//     name: 'Traditional Jhumkas',
//     description: 'Gold jhumkas with pearl drops and intricate filigree work',
//     price: 49999.99,
//     imageUrls: ['assets/Images/e2-1.jpg', 'assets/Images/e2-2.jpg'],
//     category: 'Earrings',
//     rating: 4.8,
//     stock: 15,
//     material: '22K Gold with Pearls',
//   ),
//   Product(
//     id: 'e3',
//     name: 'Emerald Drop Earrings',
//     description: 'Contemporary emerald and diamond drop earrings',
//     price: 89999.99,
//     imageUrls: ['assets/Images/e3-1.jpg', 'assets/Images/e3-2.jpg'],
//     category: 'Earrings',
//     rating: 4.7,
//     stock: 8,
//     material: '18K Gold with Emeralds and Diamonds',
//   ),
//   Product(
//     id: 'e4',
//     name: 'Ruby Studs',
//     description: 'Classic ruby studs surrounded by diamond halo',
//     price: 74999.99,
//     imageUrls: ['assets/Images/e4-1.jpg', 'assets/Images/e4-2.jpg'],
//     category: 'Earrings',
//     rating: 4.6,
//     stock: 10,
//     material: '18K Gold with Rubies and Diamonds',
//   ),
//   Product(
//     id: 'e5',
//     name: 'Pearl Chandelier Earrings',
//     description: 'Elegant chandelier earrings with pearl and diamond accents',
//     price: 59999.99,
//     imageUrls: ['assets/Images/e5-1.jpg', 'assets/Images/e5-2.jpg'],
//     category: 'Earrings',
//     rating: 4.5,
//     stock: 12,
//     material: '18K Gold with Pearls and Diamonds',
//   ),

//   // Necklaces
//   Product(
//     id: 'n1',
//     name: 'Diamond Mangalsutra',
//     description: 'Modern diamond mangalsutra with black beads',
//     price: 149999.99,
//     imageUrls: ['assets/Images/n1-1.jpg', 'assets/Images/n1-2.jpg'],
//     category: 'Necklaces',
//     rating: 4.9,
//     stock: 8,
//     material: '18K Gold with Diamonds',
//     isFeatured: true,
//   ),
//   Product(
//     id: 'n2',
//     name: 'Kundan Choker',
//     description: 'Traditional kundan choker with emerald drops',
//     price: 189999.99,
//     imageUrls: ['assets/Images/n2-1.jpg', 'assets/Images/n2-2.jpg'],
//     category: 'Necklaces',
//     rating: 4.8,
//     stock: 5,
//     material: '22K Gold with Kundan and Emeralds',
//   ),
//   Product(
//     id: 'n3',
//     name: 'Pearl String Necklace',
//     description: 'Multi-strand pearl necklace with diamond clasp',
//     price: 99999.99,
//     imageUrls: ['assets/Images/n3-1.jpg', 'assets/Images/n3-2.jpg'],
//     category: 'Necklaces',
//     rating: 4.7,
//     stock: 10,
//     material: 'South Sea Pearls with 18K Gold',
//   ),

//   // Rings
//   Product(
//     id: 'r1',
//     name: 'Solitaire Engagement Ring',
//     description:
//         'Classic solitaire diamond engagement ring in cathedral setting',
//     price: 249999.99,
//     imageUrls: ['assets/Images/r1-1.jpg', 'assets/Images/r1-2.jpg'],
//     category: 'Rings',
//     rating: 5.0,
//     stock: 6,
//     material: 'Platinum with Diamond',
//     isFeatured: true,
//   ),
//   Product(
//     id: 'r2',
//     name: 'Three Stone Ring',
//     description: 'Trilogy ring with diamonds and sapphire center stone',
//     price: 179999.99,
//     imageUrls: ['assets/Images/r2-1.jpg', 'assets/Images/r2-2.jpg'],
//     category: 'Rings',
//     rating: 4.8,
//     stock: 8,
//     material: '18K White Gold with Sapphire and Diamonds',
//   ),
//   Product(
//     id: 'r3',
//     name: 'Antique Style Ring',
//     description: 'Vintage inspired ring with milgrain details',
//     price: 89999.99,
//     imageUrls: ['assets/Images/r3-1.jpg', 'assets/Images/r3-2.jpg'],
//     category: 'Rings',
//     rating: 4.7,
//     stock: 12,
//     material: '18K Rose Gold with Diamonds',
//   ),
//   Product(
//     id: 'r4',
//     name: 'Cocktail Ring',
//     description: 'Statement cocktail ring with emerald center and diamond halo',
//     price: 159999.99,
//     imageUrls: ['assets/Images/r4-1.jpg', 'assets/Images/r4-2.jpg'],
//     category: 'Rings',
//     rating: 4.6,
//     stock: 7,
//     material: '18K Gold with Emerald and Diamonds',
//   ),

//   // Sets
//   Product(
//     id: 'set1',
//     name: 'Bridal Kundan Set',
//     description: 'Complete bridal set with necklace, earrings, and maang tikka',
//     price: 499999.99,
//     imageUrls: ['assets/Images/set1-1.jpg', 'assets/Images/set1-2.jpg'],
//     category: 'Sets',
//     rating: 5.0,
//     stock: 3,
//     material: '22K Gold with Kundan and Diamonds',
//     isFeatured: true,
//   ),
//   Product(
//     id: 'set2',
//     name: 'Diamond Wedding Set',
//     description: 'Modern diamond set with necklace and earrings',
//     price: 399999.99,
//     imageUrls: ['assets/Images/set2-1.jpg', 'assets/Images/set2-2.jpg'],
//     category: 'Sets',
//     rating: 4.9,
//     stock: 4,
//     material: '18K White Gold with Diamonds',
//   ),
//   Product(
//     id: 'set3',
//     name: 'Pearl Collection Set',
//     description: 'Elegant pearl set with necklace, earrings, and bracelet',
//     price: 299999.99,
//     imageUrls: ['assets/Images/set3-1.jpg', 'assets/Images/set3-2.jpg'],
//     category: 'Sets',
//     rating: 4.8,
//     stock: 6,
//     material: '18K Gold with South Sea Pearls',
//   ),
//   Product(
//     id: 'set4',
//     name: 'Traditional Antique Set',
//     description:
//         'Complete antique finish set with necklace, earrings, and bangles',
//     price: 449999.99,
//     imageUrls: ['assets/Images/set4-1.jpg', 'assets/Images/set4-2.jpg'],
//     category: 'Sets',
//     rating: 4.9,
//     stock: 4,
//     material: '22K Gold with Kundan and Gemstones',
//   ),
// ];
List<Map<String, dynamic>> products = [
  // Bangles
  {
    "id": 'b1',
    "name": 'Traditional Gold Bangle',
    "description":
        'Handcrafted 22K gold bangle featuring intricate traditional motifs with antique finish',
    "price": 45999.99,
    "imageUrls": ['assets/Images/b1-1.jpg', 'assets/Images/b1-2.jpg'],
    "category": 'Bangles',
    "rating": 4.8,
    "stock": 10,
    "material": '22K Gold',
    "isFeatured": true,
  },
  {
    "id": 'b2',
    "name": 'Diamond Studded Kada',
    "description":
        'Contemporary gold kada with brilliant-cut diamonds in floral pattern',
    "price": 89999.99,
    "imageUrls": ['assets/Images/b2-1.jpg', 'assets/Images/b2-2.jpg'],
    "category": 'Bangles',
    "rating": 4.9,
    "stock": 5,
    "material": '18K Gold with Diamonds',
  },
  {
    "id": 'b3',
    "name": 'Pearl Embellished Bangle',
    "description": 'Elegant bangle with freshwater pearls and meenakari work',
    "price": 35999.99,
    "imageUrls": ['assets/Images/b3-1.jpg', 'assets/Images/b3-2.jpg'],
    "category": 'Bangles',
    "rating": 4.7,
    "stock": 8,
    "material": '22K Gold with Pearls',
  },
  {
    "id": 'b4',
    "name": 'Antique Kundan Bangle',
    "description": 'Traditional kundan bangle with intricate enamel work',
    "price": 67999.99,
    "imageUrls": ['assets/Images/b4-1.jpg', 'assets/Images/b4-2.jpg'],
    "category": 'Bangles',
    "rating": 4.6,
    "stock": 12,
    "material": '22K Gold with Kundan',
  },

  // Earrings
  {
    "id": 'e1',
    "name": 'Solitaire Diamond Studs',
    "description": 'Classic solitaire diamond studs in prong setting',
    "price": 129999.99,
    "imageUrls": ['assets/Images/e1-1.jpg', 'assets/Images/e1-2.jpg'],
    "category": 'Earrings',
    "rating": 4.9,
    "stock": 6,
    "material": '18K White Gold with Diamonds',
    "isFeatured": true,
  },
  {
    "id": 'e2',
    "name": 'Traditional Jhumkas',
    "description": 'Gold jhumkas with pearl drops and intricate filigree work',
    "price": 49999.99,
    "imageUrls": ['assets/Images/e2-1.jpg', 'assets/Images/e2-2.jpg'],
    "category": 'Earrings',
    "rating": 4.8,
    "stock": 15,
    "material": '22K Gold with Pearls',
  },
  {
    "id": 'e3',
    "name": 'Emerald Drop Earrings',
    "description": 'Contemporary emerald and diamond drop earrings',
    "price": 89999.99,
    "imageUrls": ['assets/Images/e3-1.jpg', 'assets/Images/e3-2.jpg'],
    "category": 'Earrings',
    "rating": 4.7,
    "stock": 8,
    "material": '18K Gold with Emeralds and Diamonds',
  },
  {
    "id": 'e4',
    "name": 'Ruby Studs',
    "description": 'Classic ruby studs surrounded by diamond halo',
    "price": 74999.99,
    "imageUrls": ['assets/Images/e4-1.jpg', 'assets/Images/e4-2.jpg'],
    "category": 'Earrings',
    "rating": 4.6,
    "stock": 10,
    "material": '18K Gold with Rubies and Diamonds',
  },
  {
    "id": 'e5',
    "name": 'Pearl Chandelier Earrings',
    "description": 'Elegant chandelier earrings with pearl and diamond accents',
    "price": 59999.99,
    "imageUrls": ['assets/Images/e5-1.jpg', 'assets/Images/e5-2.jpg'],
    "category": 'Earrings',
    "rating": 4.5,
    "stock": 12,
    "material": '18K Gold with Pearls and Diamonds',
  },

  // Necklaces
  {
    "id": 'n1',
    "name": 'Diamond Mangalsutra',
    "description": 'Modern diamond mangalsutra with black beads',
    "price": 149999.99,
    "imageUrls": ['assets/Images/n1-1.jpg', 'assets/Images/n1-2.jpg'],
    "category": 'Necklaces',
    "rating": 4.9,
    "stock": 8,
    "material": '18K Gold with Diamonds',
    "isFeatured": true,
  },
  {
    "id": 'n2',
    "name": 'Kundan Choker',
    "description": 'Traditional kundan choker with emerald drops',
    "price": 189999.99,
    "imageUrls": ['assets/Images/n2-1.jpg', 'assets/Images/n2-2.jpg'],
    "category": 'Necklaces',
    "rating": 4.8,
    "stock": 5,
    "material": '22K Gold with Kundan and Emeralds',
  },
  {
    "id": 'n3',
    "name": 'Pearl String Necklace',
    "description": 'Multi-strand pearl necklace with diamond clasp',
    "price": 99999.99,
    "imageUrls": ['assets/Images/n3-1.jpg', 'assets/Images/n3-2.jpg'],
    "category": 'Necklaces',
    "rating": 4.7,
    "stock": 10,
    "material": 'South Sea Pearls with 18K Gold',
  },

  // Rings
  {
    "id": 'r1',
    "name": 'Solitaire Engagement Ring',
    "description":
        'Classic solitaire diamond engagement ring in cathedral setting',
    "price": 249999.99,
    "imageUrls": ['assets/Images/r1-1.jpg', 'assets/Images/r1-2.jpg'],
    "category": 'Rings',
    "rating": 5.0,
    "stock": 6,
    "material": 'Platinum with Diamond',
    "isFeatured": true,
  },
  {
    "id": 'r2',
    "name": 'Three Stone Ring',
    "description": 'Trilogy ring with diamonds and sapphire center stone',
    "price": 179999.99,
    "imageUrls": ['assets/Images/r2-1.jpg', 'assets/Images/r2-2.jpg'],
    "category": 'Rings',
    "rating": 4.8,
    "stock": 8,
    "material": '18K White Gold with Sapphire and Diamonds',
  },
  {
    "id": 'r3',
    "name": 'Antique Style Ring',
    "description": 'Vintage inspired ring with milgrain details',
    "price": 89999.99,
    "imageUrls": ['assets/Images/r3-1.jpg', 'assets/Images/r3-2.jpg'],
    "category": 'Rings',
    "rating": 4.7,
    "stock": 12,
    "material": '18K Rose Gold with Diamonds',
  },
  {
    "id": 'r4',
    "name": 'Cocktail Ring',
    "description":
        'Statement cocktail ring with emerald center and diamond halo',
    "price": 159999.99,
    "imageUrls": ['assets/Images/r4-1.jpg', 'assets/Images/r4-2.jpg'],
    "category": 'Rings',
    "rating": 4.6,
    "stock": 7,
    "material": '18K Gold with Emerald and Diamonds',
  },

  // Sets
  {
    "id": 'set1',
    "name": 'Bridal Kundan Set',
    "description":
        'Complete bridal set with necklace, earrings, and maang tikka',
    "price": 499999.99,
    "imageUrls": ['assets/Images/set1-1.jpg', 'assets/Images/set1-2.jpg'],
    "category": 'Sets',
    "rating": 5.0,
    "stock": 3,
    "material": '22K Gold with Kundan and Diamonds',
    "isFeatured": true,
  },
  {
    "id": 'set2',
    "name": 'Diamond Wedding Set',
    "description": 'Modern diamond set with necklace and earrings',
    "price": 399999.99,
    "imageUrls": ['assets/Images/set2-1.jpg', 'assets/Images/set2-2.jpg'],
    "category": 'Sets',
    "rating": 4.9,
    "stock": 4,
    "material": '18K White Gold with Diamonds',
  },
  {
    "id": 'set3',
    "name": 'Pearl Collection Set',
    "description": 'Elegant pearl set with necklace, earrings, and bracelet',
    "price": 299999.99,
    "imageUrls": ['assets/Images/set3-1.jpg', 'assets/Images/set3-2.jpg'],
    "category": 'Sets',
    "rating": 4.8,
    "stock": 6,
    "material": '18K Gold with South Sea Pearls',
  },
  {
    "id": 'set4',
    "name": 'Traditional Antique Set',
    "description":
        'Complete antique jewelry set with necklace, earrings, and bangles',
    "price": 249999.99,
    "imageUrls": ['assets/Images/set4-1.jpg', 'assets/Images/set4-2.jpg'],
    "category": 'Sets',
    "rating": 4.7,
    "stock": 5,
    "material": '22K Gold with Kundan and Pearls',
  },
];