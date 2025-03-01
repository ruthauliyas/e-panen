import 'package:flutter/material.dart';
import '../../models/pemanen.dart';

class DetailPemanenScreen extends StatefulWidget {
  final Pemanen pemanen;

  DetailPemanenScreen({required this.pemanen});

  @override
  State<DetailPemanenScreen> createState() => _DetailPemanenScreenState();
}

class _DetailPemanenScreenState extends State<DetailPemanenScreen> {
  final List<String> _statusOptions = ['Belum Diisi', 'Baik', 'Perlu Perbaikan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail ${widget.pemanen.nama}")),
      body: ListView.builder(
        itemCount: widget.pemanen.statusBaris.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Baris ${widget.pemanen.startBaris! + index}"),
            subtitle: Text("Status: ${widget.pemanen.statusBaris[index]}"),
            trailing: DropdownButton<String>(
              value: widget.pemanen.statusBaris[index],
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (newStatus) {
                setState(() {
                  widget.pemanen.statusBaris[index] = newStatus!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          Navigator.pop(context, widget.pemanen);  // Kembalikan data yang sudah diubah
        },
      ),
    );
  }
}
