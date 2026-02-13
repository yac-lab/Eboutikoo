import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 1. CLASSE PRODUIT
class Product {
  final String name;
  final String price;
  final String imageUrl;
  final String description;

  Product({
    required this.name, 
    required this.price, 
    required this.imageUrl, 
    required this.description
  });
}

// 2. LISTE DES PRODUITS
final List<Product> kProducts = [
  Product(name: 'Valiz', price: '3000 HTG', imageUrl: 'assets/images/p1.jpg', description: 'Materyèl: Polyester\nKoulè: vet \nRezistan ak dlo'),
  Product(name: 'PS5', price: '150 000 HTG', imageUrl: 'assets/images/p2.jpg', description: 'SSD: 825 Go\nRezolisyon: 4K Ultra HD\nKontwolè: DualSense'),
  Product(name: 'Jonp Sandisk 8gb', price: '1500 HTG', imageUrl: 'assets/images/p3.jpg', description: 'Kapasite: 8 GB\nVites: USB 2.0\nMak: Sandisk'),
  Product(name: 'Tenis', price: '7000 HTG', imageUrl: 'assets/images/p6.jpg', description: ' Son tenis'),
  Product(name: 'Kepi', price: '500 HTG', imageUrl: 'assets/images/p4.jpg', description: 'Materyèl: Koton 100%\nTaille: Ajustable\nKoulè: Ble maren'),
  Product(name: 'Laptop Surface', price: '400 000 HTG', imageUrl: 'assets/images/p5.jpg', description: 'Processeur: Intel i5\nRAM: 8GB\nEkran: 12.3 pous Tactile'),
];

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF4C66E7), useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final stockage = const FlutterSecureStorage();
  int _currentIndex = 0; // 0=Accueil, 1=Liste Produits, 2=Panier
  Map<String, String> _mesAchats = {};

  void lireLesAchats() async {
    Map<String, String> tout = await stockage.readAll();
    setState(() => _mesAchats = tout);
  }

  void viderPanier() async {
    await stockage.deleteAll();
    lireLesAchats();
  }

  @override
  void initState() {
    super.initState();
    lireLesAchats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- LE MENU LATÉRAL (DRAWER) ---
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF4C66E7)),
              accountName: Text("Itilizatè Eboutikoo", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("kliyan@email.com"),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Akèy"),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 0); },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Pwodwi yo"),
              onTap: () { Navigator.pop(context); setState(() => _currentIndex = 1); },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Sipò "),
              onTap: () {},
            ),
          ],
        )
      ),
      
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? "Eboutikoo" : _currentIndex == 1 ? "Lis Pwodwi" : "Panye Mwen"),
        backgroundColor: const Color(0xFF4C66E7),
        foregroundColor: Colors.white,
        actions: [
          if (_currentIndex == 2 && _mesAchats.isNotEmpty)
            IconButton(icon: const Icon(Icons.delete_forever), onPressed: viderPanier)
        ],
      ),

      // CHANGEMENT DE PAGE SELON L'INDEX
      body: _currentIndex == 0 
          ? _buildHomeScreen() 
          : _currentIndex == 1 ? _buildProductList() : _buildPanierList(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          if (i == 2) lireLesAchats();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Akèy"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Pwodwi"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Panye"),
        ],
      ),
    );
  }

  // --- 1. PAGE D'ACCUEIL (STYLE CODE B) ---
  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image (Simulé avec un Container bleu)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: const Color(0xFF4C66E7).withOpacity(0.1),
            child: Column(
              children: const [
                Icon(Icons.bolt, size: 50, color: Color(0xFF4C66E7)),
                Text("Nou kontan w la ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("Pi bon pri sou mache a!", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          
          // Row de Catégories
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildCategoryIcon(Icons.computer, "Tekno"),
                _buildCategoryIcon(Icons.checkroom, "Rad"),
                _buildCategoryIcon(Icons.soap, "Ijyèn"),
                _buildCategoryIcon(Icons.home, "Kay"),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Pwodwi Popilè", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          
          // Un petit aperçu horizontal des produits
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, i) => Container(
                width: 130,
                margin: const EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(kProducts[i].imageUrl, fit: BoxFit.cover))),
                    Text(kProducts[i].name, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          CircleAvatar(radius: 25, backgroundColor: Colors.blue[50], child: Icon(icon, color: const Color(0xFF4C66E7))),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // --- 2. PAGE LISTE PRODUITS (LISTVIEW) ---
  Widget _buildProductList() {
    return ListView.builder(
      itemCount: kProducts.length,
      itemBuilder: (context, index) {
        final p = kProducts[index];
        return ListTile(
          leading: ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.asset(p.imageUrl, width: 50, height: 50, fit: BoxFit.cover)),
          title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(p.price),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(product: p))),
        );
      },
    );
  }

  // --- 3. PAGE PANIER ---
  Widget _buildPanierList() {
    if (_mesAchats.isEmpty) return const Center(child: Text("Panye ou vid"));
    return ListView(
      children: _mesAchats.values.map((img) => ListTile(
        leading: Image.asset(img, width: 40),
        title: const Text("Atik nan panye"),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      )).toList(),
    );
  }
}

// --- PAGE DÉTAIL ---
class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(product.imageUrl, width: double.infinity, height: 250, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(product.price, style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  const Text("Fich Teknik:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.description),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}