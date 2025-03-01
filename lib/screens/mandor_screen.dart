import 'package:flutter/material.dart';
import '../../models/pemanen.dart';
import '../../utils/storage_service.dart';
import 'detail_pemanen_screen.dart';

class MandorScreen extends StatefulWidget {
  final String mandorName;

  MandorScreen({required this.mandorName});

  @override
  State<MandorScreen> createState() => _MandorScreenState();
}

class _MandorScreenState extends State<MandorScreen> {
  List<Pemanen> pemanenList = [];

  @override
  void initState() {
    super.initState();
    _loadPemanen();
  }

  Future<void> _loadPemanen() async {
    pemanenList = await StorageService.loadPemanen();
    setState(() {});
  }

  void _hitungAlokasi() {
    int totalBaris = 42;
    List<Pemanen> hadir = pemanenList.where((p) => p.hadir).toList();
    int perPemanen = hadir.isEmpty ? 0 : (totalBaris ~/ hadir.length);

    for (int i = 0; i < hadir.length; i++) {
      hadir[i].barisAwal = i * perPemanen + 1;
      hadir[i].barisAkhir = (i == hadir.length - 1)
          ? totalBaris
          : (i + 1) * perPemanen;
    }

    StorageService.savePemanen(pemanenList);
    setState(() {});
  }

  void _toggleKehadiran(int index, bool hadir) {
    pemanenList[index].hadir = hadir;
    StorageService.savePemanen(pemanenList);
    setState(() {});
  }

  void _addPemanen(String nama) {
    Pemanen newPemanen = Pemanen(nama: nama, hadir: true);
    pemanenList.add(newPemanen);
    StorageService.savePemanen(pemanenList);
    setState(() {});
  }

  void _editPemanen(int index, String nama) {
    pemanenList[index].nama = nama;
    StorageService.savePemanen(pemanenList);
    setState(() {});
  }

  void _deletePemanen(int index) {
    pemanenList.removeAt(index);
    StorageService.savePemanen(pemanenList);
    setState(() {});
  }

  void _logout() {
    Navigator.of(context).pop(); // Kembali ke login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Mandor'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selamat Datang, ${widget.mandorName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pemanenList.length,
              itemBuilder: (context, index) {
                Pemanen p = pemanenList[index];
                return ListTile(
                  title: Text("${p.nama} (${p.barisAwal ?? '-'} - ${p.barisAkhir ?? '-'})"),
                  subtitle: Text(p.hadir ? "Hadir" : "Absen"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: p.hadir,
                        onChanged: (value) => _toggleKehadiran(index, value),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditDialog(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePemanen(index),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPemanenScreen(pemanen: p),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _hitungAlokasi,
            child: Text("Hitung Alokasi"),
          ),
          ElevatedButton(
            onPressed: _showAddDialog,
            child: Text("Tambah Pemanen"),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    String nama = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Pemanen"),
          content: TextField(
            onChanged: (value) => nama = value,
            decoration: InputDecoration(labelText: 'Nama Pemanen'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (nama.isNotEmpty) {
                  _addPemanen(nama);
                  Navigator.pop(context);
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(int index) {
    String nama = pemanenList[index].nama;
    TextEditingController controller = TextEditingController(text: nama);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Nama Pemanen"),
          content: TextField(
            controller: controller,
            onChanged: (value) => nama = value,
            decoration: InputDecoration(labelText: 'Nama Pemanen'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (nama.isNotEmpty) {
                  _editPemanen(index, nama);
                  Navigator.pop(context);
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
