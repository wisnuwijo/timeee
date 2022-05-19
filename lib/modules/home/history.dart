// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:timey/app/services/attendance/attendance_service.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  late Future<List<Map<String, dynamic>>> _getHistory;

  @override
  void initState() {
    _getHistory = AttendanceService.getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getHistory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _historyBody(snapshot.data!);
        } else {
          return Center(
          child: CircularProgressIndicator(),
        );
        }
      },
    );
  }

  Widget _historyBody(List<Map<String, dynamic>> data) {
    // ignore: curly_braces_in_flow_control_structures
    if (data.isEmpty) return Center(
      child: Text("Kosong"),
    );
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {},
              title: Text("${data[index]['address']}"),
              subtitle: Text("${data[index]['timestamp']}"),
              leading: Text("${index + 1}. ${data[index]['type'] == "check_in" ? "IN" : "OUT"}"),
            ),
            Divider(
              height: 1,
            )
          ],
        );
      }
    );
  }
}