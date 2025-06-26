import 'package:flutter/material.dart';
import 'package:mindnews/views/beranda.dart' show DetailPage, newsViralList;
import 'package:mindnews/views/news_card.dart';

class Viraa extends StatefulWidget {
  const Viraa({super.key});

  @override
  _ViraaState createState() => _ViraaState();
}

class _ViraaState extends State<Viraa> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> newsList = List<Map<String, dynamic>>.from(newsViralList);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Virall(
        newsList: newsList,
        onNewsUpdate: (updatedList) {
          setState(() => newsList = updatedList);
        },
      ),
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
        ],
      ),
    );
  }
}

class Virall extends StatefulWidget {
  final List<Map<String, dynamic>> newsList;
  final Function(List<Map<String, dynamic>>) onNewsUpdate;

  const Virall({super.key, required this.newsList, required this.onNewsUpdate});

  @override
  _VirallState createState() => _VirallState();
}

class _VirallState extends State<Virall> {
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
    return Scaffold(
      body: SafeArea(
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
                          Text('MindNews', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Grow Your Plan', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  Icon(Icons.person, color: Colors.white)
                ],
              ),
            ),
            // Tambahkan teks BERITA VIRAL dan tombol kembali di bawah search bar
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: 'Kembali',
                  ),
                  SizedBox(width: 4),
                  Text(
                    'BERITA VIRAL',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
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
                            tanggal: item['date'] ?? item['tanggal'],
                          ),
                        ),
                      );
                    },
                    onFavoriteToggle: () => _toggleFavorite(index),
                    tanggal: item['date'] ?? item['tanggal'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
