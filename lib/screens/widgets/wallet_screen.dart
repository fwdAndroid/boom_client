import 'package:boom_client/screens/widgets/add_waleet.dart';
import 'package:boom_client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$120.50', // Replace with actual balance
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),

            // Transaction History
            Text(
              'Recent Transactions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with actual transaction count
                itemBuilder: (context, index) {
                  return TransactionItem(
                    date: '2023-03-10', // Replace with actual date
                    description:
                        'Ride from City A to City B', // Replace with actual description
                    amount: '- \$15.00', // Replace with actual amount
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add money to wallet logic
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AddWallet()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String date;
  final String description;
  final String amount;

  const TransactionItem({
    Key? key,
    required this.date,
    required this.description,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              amount,
              style: TextStyle(
                color: amount.startsWith('-') ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
