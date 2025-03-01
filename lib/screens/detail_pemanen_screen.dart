import 'package:flutter/material.dart';
import '../../models/pemanen.dart';

class DetailPemanenScreen extends StatefulWidget {
  final Pemanen pemanen;
  DetailPemanenScreen({required this.pemanen});

  @override
  State<DetailPemanenScreen> createState() => _DetailPemanenScreenState();
}

class _DetailPemanenScreenState extends State<DetailPemanenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail ${widget.pemanen.nama}")),
      body: ListView.builder(
        itemCount: widget.pemanen.statusBaris.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Baris ${index + 1}"),
            subtitle: Text("Status: ${widget.pemanen.statusBaris[index]}"),
          );
        },
      ),
    );
  }
}
