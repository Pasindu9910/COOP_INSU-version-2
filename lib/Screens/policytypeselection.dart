import 'package:customer_portal/Screens/policysearch.dart';
import 'package:flutter/material.dart';

class PolicyTypeSelectionPage extends StatelessWidget {
  const PolicyTypeSelectionPage({super.key});

  void _onTileTap(BuildContext context, String policyType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PolicySearchPage(policyType: policyType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Policy type selection',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTile(
                context,
                icon: Icons.assignment,
                label: 'New Policy',
                onTap: () => _onTileTap(context, 'New Policy'),
              ),
              const SizedBox(height: 20),
              _buildTile(
                context,
                icon: Icons.people,
                label: 'Renewal',
                onTap: () => _onTileTap(context, 'Renewal'),
              ),
              const SizedBox(height: 20),
              _buildTile(
                context,
                icon: Icons.settings,
                label: 'Policy Cancellation',
                onTap: () => _onTileTap(context, 'Policy Cancellation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.black),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
