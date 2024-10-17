import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Policyinfo extends StatefulWidget {
  final String nicNumber;

  const Policyinfo({super.key, required this.nicNumber});

  @override
  State<Policyinfo> createState() => _PolicyinfoState();
}

class _PolicyinfoState extends State<Policyinfo> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _policyList = [];
  List<Map<String, dynamic>> _filteredPolicyList = [];

  @override
  void initState() {
    super.initState();
    _fetchPolicyInfo();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPolicyInfo() async {
    try {
      final Uri apiUrl = Uri.parse(
          'http://124.43.209.68:9000/api/v1/getuserbyid/${widget.nicNumber}');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _policyList =
              jsonResponse.map((item) => item as Map<String, dynamic>).toList();
          _filteredPolicyList = _policyList;
        });
      } else {
        throw Exception(
            'Failed to load policy info, status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _policyList = [];
        _filteredPolicyList = [];
      });
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPolicyList = _policyList.where((policy) {
        String vehicleNumber =
            policy['riskname']?.toString().toLowerCase() ?? '';
        return vehicleNumber.contains(query);
      }).toList();
    });
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd - HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 68, 124),
          title: Text(
            'Policy Information',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: _buildSearchBar(),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/background2.png',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _policyList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _filteredPolicyList.isEmpty
                      ? Center(child: Text('No policy information found.'))
                      : ListView.builder(
                          itemCount: _filteredPolicyList.length,
                          itemBuilder: (context, index) {
                            final policyData = _filteredPolicyList[index];
                            return _buildPolicyCard(policyData);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: 'Search by Vehicle Number',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
          cursorColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildPolicyCard(Map<String, dynamic> policyData) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPolicyTile('Customer Name', policyData['surname']),
              _buildPolicyTile(
                  'Customer Identity Card Number', policyData['nic']),
              _buildPolicyTile('Vehicle Number', policyData['riskname']),
              _buildPolicyTile('Policy Number', policyData['polno']),
              _buildPolicyTile(
                  'Policy Period From', _formatDate(policyData['fdate'])),
              _buildPolicyTile(
                  'Policy Period To', _formatDate(policyData['tdate'])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[700],
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
