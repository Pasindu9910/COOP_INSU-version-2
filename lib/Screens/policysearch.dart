import 'dart:convert';
import 'package:customer_portal/Screens/newInspection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PolicySearchPage extends StatefulWidget {
  final String policyType;

  const PolicySearchPage({super.key, required this.policyType});

  @override
  State<PolicySearchPage> createState() => _PolicySearchPageState();
}

class _PolicySearchPageState extends State<PolicySearchPage> {
  List<Map<String, dynamic>> _policyList = [];
  List<Map<String, dynamic>> _filteredPolicyList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPolicyInfo(String nicNumber) async {
    if (nicNumber.length < 5) return; // Avoid unnecessary API calls

    try {
      final Uri apiUrl =
          Uri.parse('http://124.43.209.68:9000/api/v1/policies/$nicNumber');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _policyList =
              jsonResponse.map((item) => item as Map<String, dynamic>).toList();
          _filteredPolicyList = _policyList;
        });
      } else {
        setState(() {
          _policyList = [];
          _filteredPolicyList = [];
        });
      }
    } catch (e) {
      setState(() {
        _policyList = [];
        _filteredPolicyList = [];
      });
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim();
    if (query.length >= 5) {
      _fetchPolicyInfo(query);
    }
  }

  void _navigateToVehicleInspection(Map<String, dynamic> policyData) {
    String? policyNumber = policyData['POL_POLICY_NO']?.toString();
    String? proposalNumber = policyData['POL_PROPOSAL_NO']?.toString();
    String? branchNumber = policyData['BRANCH_NAME']?.toString();
    String? vehicleNumber = policyData['PRS_NAME']?.toString();

    String selectedNumber = policyNumber?.isNotEmpty == true
        ? policyNumber!
        : (proposalNumber ?? 'N/A');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newvehicleInspec(
          policyType: widget.policyType,
          policyNumber: selectedNumber,
          branchNumber: branchNumber ?? 'N/A',
          vehicleNumber: vehicleNumber ?? 'N/A',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 68, 124),
          title: Text(
            'Policy Search - ${widget.policyType}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
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
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _filteredPolicyList.isEmpty
                      ? const Center(
                          child: Text('No policy information found.'))
                      : ListView.builder(
                          itemCount: _filteredPolicyList.length,
                          itemBuilder: (context, index) {
                            final policyData = _filteredPolicyList[index];
                            return GestureDetector(
                              onTap: () =>
                                  _navigateToVehicleInspection(policyData),
                              child: _buildPolicyCard(policyData),
                            );
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
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: 'Enter NIC Number',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black),
          cursorColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildPolicyCard(Map<String, dynamic> policyData) {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPolicyTile(
                  'Your Name', policyData['CUS_INDV_SURNAME']?.toString()),
              _buildPolicyTile(
                  'Your NIC', policyData['CUS_INDV_NIC_NO']?.toString()),
              _buildPolicyTile(
                  'Vehicle Number', policyData['PRS_NAME']?.toString()),
              _buildPolicyTile(
                  'Policy Number', policyData['POL_POLICY_NO']?.toString()),
              _buildPolicyTile(
                  'Proposal Number', policyData['POL_PROPOSAL_NO']?.toString()),
              _buildPolicyTile(
                  'Branch Number', policyData['BRANCH_NAME']?.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPolicyTile(String title, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value ?? 'N/A',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    ),
  );
}
