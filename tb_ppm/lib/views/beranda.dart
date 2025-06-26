import 'package:flutter/material.dart';
import 'package:mindnews/views/utaa.dart';
import 'package:mindnews/views/viraa.dart';
import 'package:mindnews/views/news_card.dart';

void main() {
  runApp(MindNewsApp());
}

class MindNewsApp extends StatelessWidget {
  const MindNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BerandaPage(),
    );
  }
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _selectedIndex = 0;

  // Gabungkan list utama dan viral
  List<Map<String, dynamic>> get newsList => [...newsUtamaList, ...newsViralList];

  // Callback untuk update status favorite di kedua list
  void _onNewsUpdate(List<Map<String, dynamic>> updatedList) {
    setState(() {
      // Update berita utama
      for (int i = 0; i < newsUtamaList.length; i++) {
        newsUtamaList[i]['isFavorite'] = updatedList[i]['isFavorite'];
      }
      // Update berita viral
      for (int i = 0; i < newsViralList.length; i++) {
        newsViralList[i]['isFavorite'] = updatedList[newsUtamaList.length + i]['isFavorite'];
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddNewsDialog() {
    String title = '';
    String desc = '';
    String imageUrl = '';
    String jenis = 'Berita Utama';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
        return AlertDialog(
          title: Text('Tambah Berita'),
          content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            TextField(
              decoration: InputDecoration(labelText: 'Judul'),
              onChanged: (val) => title = val,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Deskripsi'),
              onChanged: (val) => desc = val,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'URL Gambar'),
              onChanged: (val) => imageUrl = val,
            ),
            DropdownButton<String>(
              value: jenis,
              isExpanded: true,
              items: [
              DropdownMenuItem(value: 'Berita Utama', child: Text('Berita Utama')),
              DropdownMenuItem(value: 'Berita Viral', child: Text('Berita Viral')),
              ],
              onChanged: (val) {
              if (val != null) {
                jenis = val;
                setStateDialog(() {});
              }
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
              Expanded(
                child: Text(
                selectedDate == null
                  ? 'Tanggal belum dipilih'
                  : 'Tanggal: ${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setStateDialog(() {
                  selectedDate = picked;
                  });
                }
                },
                child: Text('Pilih Tanggal'),
              ),
              ],
            ),
            ],
          ),
          ),
          actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
            if (title.isNotEmpty && desc.isNotEmpty && imageUrl.isNotEmpty && selectedDate != null) {
              final newNews = {
              'image': imageUrl,
              'title': title,
              'desc': desc,
              'isFavorite': false,
              'date': "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
              };
              setState(() {
              if (jenis == 'Berita Utama') {
                newsUtamaList.add(newNews);
              } else {
                newsViralList.add(newNews);
              }
              });
              Navigator.pop(context);
            }
            },
            child: Text('Tambah'),
          ),
          ],
        );
        },
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Bintang(
        newsList: List<Map<String, dynamic>>.from(newsList),
        onNewsUpdate: _onNewsUpdate,
      ),
      PopularPage(allNews: List<Map<String, dynamic>>.from(newsList)),
      InforPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewsDialog,
        backgroundColor: Colors.green[700],
        tooltip: 'Tambah Berita',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Populer'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }
}

class Bintang extends StatefulWidget {
  final List<Map<String, dynamic>> newsList;
  final Function(List<Map<String, dynamic>>) onNewsUpdate;

  const Bintang({super.key, required this.newsList, required this.onNewsUpdate});

  @override
  _berita createState() => _berita();
}

class _berita extends State<Bintang> {
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
          
          
          Expanded(
            child: ListView(
              children: [
                SectionTitle(title: "Berita Utama"),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: newsUtamaList.length,
                    itemBuilder: (context, index) {
                      final item = newsUtamaList[index];
                      return HorizontalNewsItem(
                        image: item['image'],
                        title: item['title'],
                        tanggal: item['date'] ?? item['tanggal'], // Pastikan tanggal dikirim
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Utamaa(
                                newsList: List<Map<String, dynamic>>.from(newsUtamaList),
                                onNewsUpdate: (updatedUtama) {
                                  setState(() {
                                    for (int i = 0; i < newsUtamaList.length; i++) {
                                      newsUtamaList[i]['isFavorite'] = updatedUtama[i]['isFavorite'];
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SectionTitle(title: "Berita Viral"),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    itemCount: newsViralList.length,
                    itemBuilder: (context, index) {
                      final item = newsViralList[index];
                      return HorizontalNewsItem(
                        image: item['image'],
                        title: item['title'],
                        tanggal: item['date'] ?? item['tanggal'], // Pastikan tanggal dikirim
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Virall(
                                newsList: List<Map<String, dynamic>>.from(newsViralList),
                                onNewsUpdate: (updatedViral) {
                                  setState(() {
                                    for (int i = 0; i < newsViralList.length; i++) {
                                      newsViralList[i]['isFavorite'] = updatedViral[i]['isFavorite'];
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SectionTitle(title: "Keseluruhan Berita"),
                ...widget.newsList.map((item) {
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
                            tanggal: item['date'] ?? item['tanggal'], // Perbaiki fallback tanggal
                          ),
                        ),
                      );
                    },
                    onFavoriteToggle: () {
                      setState(() {
                        int indexUtama = newsUtamaList.indexOf(item);
                        if (indexUtama != -1) {
                          newsUtamaList[indexUtama]['isFavorite'] = !newsUtamaList[indexUtama]['isFavorite'];
                        }
                        int indexViral = newsViralList.indexOf(item);
                        if (indexViral != -1) {
                          newsViralList[indexViral]['isFavorite'] = !newsViralList[indexViral]['isFavorite'];
                        }
                      });
                    },
                    tanggal: item['date'] ?? item['tanggal'], // Perbaiki fallback tanggal
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 6),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: onTap != null ? const Color.fromARGB(255, 0, 0, 0) : Colors.black,
            decoration: onTap != null ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}

class HorizontalNewsItem extends StatelessWidget {
  final String image, title;
  final String? tanggal;
  final VoidCallback onTap;

  const HorizontalNewsItem({super.key, required this.image, required this.title, this.tanggal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100, width: 2),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                image,
                width: double.infinity,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            if ((tanggal ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: Text(
                  tanggal!,
                  style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ),
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
  final String? tanggal;

  const DetailPage({super.key, required this.title, required this.description, required this.image, this.tanggal});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Detail Berita"),
      backgroundColor: Colors.green[700],
    ),
    body: SingleChildScrollView( // Tambahkan scroll di sini
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            // Gambar
            Center(
              child: Image.network(
                image,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image, size: 100),
              ),
            ),
            // Tanggal
            if ((tanggal ?? '').isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    tanggal!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ),
            // Isi berita
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}

}

class PopularPage extends StatefulWidget {
  final List<Map<String, dynamic>> allNews;
  const PopularPage({super.key, required this.allNews});

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
                final originalIndex = widget.allNews.indexOf(item);
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
                          tanggal: item['date'] ?? item['tanggal'], // Kirim tanggal ke DetailPage
                        ),
                      ),
                    );
                  },
                  onFavoriteToggle: () => _toggleFavorite(originalIndex),
                  tanggal: item['date'] ?? item['tanggal'], // Tambahkan tanggal di NewsCard
                );
              },
            ),
    );
  }
}

class InforPage extends StatelessWidget {
  const InforPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Tentang MindNews"),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Logo
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.15),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 54,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.newspaper, color: Colors.green[700], size: 62),
                ),
              ),
              SizedBox(height: 18),
              Text(
                "MindNews",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Grow Your Plan",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 24),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 28),
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        "MindNews adalah aplikasi berita yang menyajikan informasi terkini, inspiratif, dan viral untuk membantu Anda tetap update dan berkembang setiap hari.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green[900],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 18),
                      Divider(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.group, color: Colors.green[700]),
                          SizedBox(width: 8),
                          Text(
                            "Dibuat oleh MindNews Team",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.green[700]),
                          SizedBox(width: 8),
                          Text(
                            "mindnews.team@gmail.com",
                            style: TextStyle(
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.link, color: Colors.green[700]),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "www.mindnews.com",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Versi 1.0.0",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Pisahkan konten berita utama dan berita viral
typedef NewsItem = Map<String, dynamic>;

final List<NewsItem> newsUtamaList = [
  {
    'title': 'Jadwal Tahun Ajaran Baru dan video SPMB 2025: Dari SD HIngga Perguruan Tinggi',
    'image': 'https://th.bing.com/th/id/OIP.ixKd3-WyuGBls8H6Ub90kwHaE6?w=281&h=186&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    'desc': 'Pemerintah telah menetapkan jadwal tahun ajaran baru dan periode Seleksi Penerimaan Murid Baru (SPMB) tahun 2025 untuk semua jenjang pendidikan, mulai dari Sekolah Dasar (SD) hingga perguruan tinggi. SPMB tahun ini akan dilaksanakan dalam dua tahap, yaitu tahap pertama pada tanggal 16–20 Juni 2025 dan tahap kedua pada tanggal 23–28 Juni 2025. Kebijakan ini diambil untuk memberi waktu yang cukup bagi sekolah dan orang tua dalam mempersiapkan proses penerimaan peserta didik baru secara lebih teratur.\n\nUntuk jenjang SD, proses penerimaan melalui jalur afirmasi dan domisili akan dimulai lebih awal, yaitu pada 16–18 Juni 2025. Sementara itu, jalur lainnya akan tetap mengikuti jadwal umum pada 16–20 Juni 2025. Di tingkat SMP, jalur domisili baru akan dibuka pada 30 Juni 2025, setelah proses penerimaan tahap awal selesai dilaksanakan. Dengan pembagian ini, diharapkan tidak terjadi penumpukan pendaftar dan semua calon peserta didik dapat mengikuti proses seleksi dengan lebih nyaman.\n\nSementara itu, untuk jenjang perguruan tinggi, jadwal pendaftaran mengikuti periode yang sama dengan jenjang sekolah, yakni 16–20 Juni dan 23–28 Juni 2025. Pemerintah daerah dan pihak sekolah atau kampus diminta untuk aktif menyosialisasikan jadwal ini kepada para calon peserta dan orang tua. Hal ini penting agar tidak terjadi keterlambatan dalam pendaftaran, serta untuk memastikan bahwa seluruh proses SPMB berjalan lancar dan transparan.',
    'isFavorite': false,
    'date': '2024-06-01',
  },
  {
    'title': 'Kekhawatiran Mahasiswa Fakultas Teknik Pertanian IPB Yang Berubah Jadi Sekolah Teknik',
    'image': 'https://th.bing.com/th/id/OIP.34gF1icceMSW7ubii-isbAHaEu?w=275&h=180&c=7&r=0&o=5&dpr=1.1&pid=1.7',
    'desc': 'IPB University baru‑baru ini resmi mengubah nama Fakultas Teknologi Pertanian (Fateta) menjadi “Sekolah Teknik” tanpa melakukan dialog formal terlebih dahulu dengan mahasiswa. Keputusan mendadak ini memicu reaksi dari mahasiswa yang khawatir materi kuliah dan fokus kompetensi akan bergeser dari teknologi pertanian ke bidang teknik umum, sementara justru diperlukan penguatan dalam ranah agroekologi dan keberlanjutan \n\nMenurut penjelasan dari pihak kampus, perubahan ini dilakukan karena sebagian besar program studi di Fateta sejatinya berfokus pada aspek teknis—seperti mesin dan sistem teknik—sehingga lebih relevan untuk berada di bawah naungan “Sekolah Teknik”. Dekan Fateta menegaskan bahwa perubahan nama ini bukan berarti fakultas dibubarkan, melainkan mengakomodasi tiga program studi yang secara kolektif sepakat akan lebih efisien dan produktif bila digabung ke dalam format sekolah teknik .\n\nNamun, mantan rektor IPB memperingatkan bahwa transformasi ini bisa menggeser paradigma penelitian dan pengajaran dari model agroekologi berkelanjutan ke orientasi teknik semata. Mahasiswa dan akademisi berharap agar pemilihan nama dan struktur kelembagaan tetap menjaga keseimbangan antara elemen teknik dan pendekatan keberlanjutan, agar visi pendidikan tinggi di bidang teknologi pertanian tidak kehilangan identitas dan arah strategisnya .',
    'isFavorite': false,
    'date': '2024-06-02',
  },
];

final List<NewsItem> newsViralList = [
  {
    'title': 'P2G Sebut Dedi Mulyadi Tak Bisa Serta-Merta Menghapus PR Sekolah',
    'image': 'https://th.bing.com/th/id/OIP.ImeIvuYetCy9gHSFQNx4xwHaE8?w=273&h=182&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    'desc': 'Gubernur Jawa Barat Dedi Mulyadi menuai kritik tajam usai menyatakan akan menghapus pekerjaan rumah (PR) bagi siswa di sekolah-sekolah di daerahnya. Pernyataan tersebut dianggap sebagai langkah populis atau "pansos" ketimbang kebijakan strategis yang benar-benar menyelesaikan masalah pendidikan. Hal ini disampaikan oleh Perhimpunan Pendidikan dan Guru (P2G), yang menekankan bahwa penghapusan PR tidak bisa diputuskan secara sepihak tanpa kajian matang.\n\nP2G menegaskan bahwa meski niat mengurangi beban siswa dengan menghapus PR terkesan baik, kebijakan tersebut harus mempertimbangkan aspek pedagogis dan pedagogik dari tugas rumah. Menurut organisasi ini, PR merupakan bagian dari strategi penguatan pembelajaran dan sebaiknya diberikan sesuai dengan prinsip pendidikan yang mendalam, bukan dihilangkan secara total .\n\nMenanggapi wacana tersebut, Menteri Pendidikan Dasar dan Menengah Abdul Mu\'ti juga menyatakan bahwa PR tetap mempunyai peran penting dalam model pembelajaran mendalam (deep learning), selama digunakan secara tepat. Ia menegaskan bahwa tugas rumah boleh diberikan asalkan konseptual dan mendukung pengembangan kompetensi siswa, bukan sekadar beban tambahan.',
    'isFavorite': false,
    'date': '2024-06-03',
  },
  {
    'title': 'Gubernur Jawa Barat Dedi Mulyadi Kirim Pelajar Bandel Ke Barak Militer - Apa Akibatnya?',
    'image': 'https://th.bing.com/th/id/OIP.VKm3Y51o72cXz12xZdIX8QHaEK?w=294&h=180&c=7&r=0&o=7&dpr=1.1&pid=1.7&rm=3',
    'desc': 'Gubernur Dedi Mulyadi kembali menjadi sorotan setelah menyampaikan wacana kontroversial, seperti mengirimkan siswa yang dianggap "bandel" ke barak militer dan melarang guru memberikan PR. Menurut analisis dari BBC, meskipun kebijakan tersebut di antaranya bertujuan membentuk disiplin dan karakter, banyak pihak mempertanyakan dasar kajian dan efektivitas pendekatannya.\n\nPara pakar dan organisasi seperti KPAI dan Federasi Serikat Guru Indonesia (FSGI) menilai program militerisasi pelajar berisiko melanggar hak anak, menimbulkan stigma, serta kurang berdasarkan riset pedagogis. Mereka menyebut belum ada kurikulum khusus, modul ajar, atau payung hukum yang jelas, sehingga pendekatan ini dianggap naratif sepihak dan berbahaya.\n\nDari perspektif publik dan media sosial, sejumlah wacana Dedi Mulyadi menuai kritik sebagai bentuk "gubernur konten" yang lebih fokus menciptakan publisitas daripada membangun kebijakan terukur. Pengamat komunikasi menyatakan bahwa cara penyampaian ide yang belum matang dan berorientasi panggung publik justru bisa menimbulkan kegaduhan masyarakat',
    'isFavorite': false,
    'date': '2024-06-04',
  },
];
