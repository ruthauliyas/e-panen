import 'package:flutter/material.dart';
import '../../models/pemanen.dart';
import '../../utils/storage_service.dart';
import 'detail_pemanen_screen.dart';

class MandorDashboard extends StatefulWidget {
  @override
  State<MandorDashboard> createState() => _MandorDashboardState();
}

class _MandorDashboardState extends State<MandorDashboard> {
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
      hadir[i].startBaris = i * perPemanen + 1;
      hadir[i].endBaris = (i == hadir.length - 1)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard Mandor')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: pemanenList.length,
              itemBuilder: (context, index) {
                Pemanen p = pemanenList[index];
                return ListTile(
                  title: Text("${p.nama} (${p.startBaris ?? '-'} - ${p.endBaris ?? '-'})"),
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
                    MaterialPageRoute(builder: (context) => DetailPemanenScreen(pemanen: p)),
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
            onPressed: () => _showAddDialog(),
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
                }
                Navigator.pop(context);
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
                }
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
