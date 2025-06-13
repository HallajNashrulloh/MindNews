import 'package:flutter/material.dart';

void main() {
  runApp(MindNewsApp());
}

class MindNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> newsList = [
    {
      'image': 'https://via.placeholder.com/90',
      'title': 'Dugaan Pungli di SMKN 13 Bandung',
      'desc': 'Isu pungutan liar di SMKN 13 Bandung menjadi sorotan...',
      'isFavorite': false,
    },
    {
      'image': 'https://via.placeholder.com/90',
      'title': 'Siswa Nakal dikirim ke barak militer',
      'desc': 'Kebijakan gubernur Dedi Mulyadi menuai pro-kontra...',
      'isFavorite': false,
    },
    {
      'image': 'https://via.placeholder.com/90',
      'title': 'Potret siswa yang belajar di teras',
      'desc': 'Sejumlah siswa SDN Bojen 2 belajar di teras...',
      'isFavorite': false,
    },
    {
      'image': 'https://via.placeholder.com/90',
      'title': 'Banyak siswa SD di Korsel alami depresi',
      'desc': 'Studi baru melaporkan siswa SD di Korsel alami depresi...',
      'isFavorite': false,
    },
    {
      'image': 'https://via.placeholder.com/90',
      'title': 'Demo Pelajar Karena Guru Cabuli Siswa',
      'desc': 'Pelajar di Lubulllinggi demo karena guru olahraga cabuli siswi...',
      'isFavorite': false,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Utama(
        newsList: newsList,
        onNewsUpdate: (updatedList) {
          setState(() => newsList = updatedList);
        },
      ),
      PopularPage(allNews: newsList),
      CreditPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Populer'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Credit'),
        ],
      ),
    );
  }
}

class Utama extends StatefulWidget {
  final List<Map<String, dynamic>> newsList;
  final Function(List<Map<String, dynamic>>) onNewsUpdate;

  Utama({required this.newsList, required this.onNewsUpdate});

  @override
  _UtamaState createState() => _UtamaState();
}

class _UtamaState extends State<Utama> {
  late List<Map<String, dynamic>> filteredNews;

  @override
  void initState() {
    super.initState();
    filteredNews = widget.newsList;
  }

  void _filterNews(String query) {
    setState(() {
      filteredNews = widget.newsList.where((item) {
        final title = item['title'].toLowerCase();
        final desc = item['desc'].toLowerCase();
        return title.contains(query.toLowerCase()) || desc.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      final newsIndex = widget.newsList.indexOf(filteredNews[index]);
      widget.newsList[newsIndex]['isFavorite'] = !widget.newsList[newsIndex]['isFavorite'];
      widget.onNewsUpdate(widget.newsList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.green[700],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.newspaper, color: Colors.green),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('MindNews',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Grow Your Plan', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    )
                  ],
                ),
                Icon(Icons.person, color: Colors.white)
              ],
            ),
          ),
          // Search bar
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Cari berita...', border: InputBorder.none),
                    onChanged: _filterNews,
                  ),
                ),
              ],
            ),
          ),
          // List berita
          Expanded(
            child: ListView.builder(
              itemCount: filteredNews.length,
              itemBuilder: (context, index) {
                final item = filteredNews[index];
                return NewsCard(
                  image: item['image'],
                  title: item['title'],
                  description: item['desc'],
                  isFavorite: item['isFavorite'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          title: item['title'],
                          description: item['desc'],
                          image: item['image'],
                        ),
                      ),
                    );
                  },
                  onFavoriteToggle: () => _toggleFavorite(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PopularPage extends StatefulWidget {
  final List<Map<String, dynamic>> allNews;

  PopularPage({required this.allNews});

  @override
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  void _toggleFavorite(int index) {
    setState(() {
      final newsItem = widget.allNews[index];
      newsItem['isFavorite'] = !newsItem['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteNews = widget.allNews.where((item) => item['isFavorite']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Berita Populer"),
        backgroundColor: Colors.green[700],
      ),
      body: favoriteNews.isEmpty
          ? Center(child: Text("Belum ada berita favorit."))
          : ListView.builder(
              itemCount: favoriteNews.length,
              itemBuilder: (context, index) {
                final item = favoriteNews[index];
                final originalIndex = widget.allNews.indexOf(item); // Perlu ini agar bisa toggle yang asli
                return NewsCard(
                  image: item['image'],
                  title: item['title'],
                  description: item['desc'],
                  isFavorite: item['isFavorite'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          title: item['title'],
                          description: item['desc'],
                          image: item['image'],
                        ),
                      ),
                    );
                  },
                  onFavoriteToggle: () => _toggleFavorite(originalIndex),
                );
              },
            ),
    );
  }
}

class CreditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit"),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Text("Aplikasi dibuat oleh MindNews Team"),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String image, title, description;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const NewsCard({
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey,
                    child: Icon(Icons.broken_image),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            // Konten teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul + bintang
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  // Deskripsi
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const DetailPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Berita"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image, errorBuilder: (context, error, stackTrace) => Icon(Icons.image)),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}