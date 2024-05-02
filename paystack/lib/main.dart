import 'package:flutter/material.dart';
import 'package:paystack_flutter/paystack_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paystack Withdrawal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WithdrawPage(),
    );
  }
}

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _bankAccountController = TextEditingController();

  Future<void> _withdraw() async {
    double amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showErrorDialog('Invalid amount');
      return;
    }

    String bankAccount = _bankAccountController.text;
    if (bankAccount.isEmpty) {
      _showErrorDialog('Bank account is required');
      return;
    }

    try {
      await PaystackPlugin.initialize(
          publicKey: "YOUR_PUBLIC_KEY", secretKey: "YOUR_SECRET_KEY");
      var response = await PaystackPlugin.chargeBankTransfer(
        context,
        bank: bankAccount,
        amount: amount * 100, // Amount should be in kobo (100 kobo = 1 Naira)
        email: "user@example.com",
      );
      // Handle response
      if (response.status == true) {
        _showSuccessDialog('Withdrawal successful');
        // Update user's balance, transaction history, etc.
      } else {
        _showErrorDialog(response.message);
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw Earnings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _bankAccountController,
              decoration: InputDecoration(labelText: 'Bank Account'),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: _withdraw,
              child: Text('Withdraw'),
            ),
          ],
        ),
      ),
    );
  }
}
