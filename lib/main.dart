import 'package:flutter/material.dart';
import 'package:transactions/Widgets/new_transaction.dart';
import 'package:transactions/Widgets/transaction_list.dart';

import './Widgets/transaction_list.dart';
import './Widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(fontFamily: 'OpenSane',fontSize: 18,fontWeight: FontWeight.bold),
          button: TextStyle(color: Colors.white),
        ),
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(headline6:
        TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
        )))
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // late String titleInput;

  final List<Transaction> userTransactions = [
    // Transaction(id: 'T1', title: 'New Shoes', amount: 4000, date: DateTime.now(),),
    // Transaction(id: 'T2', title: 'Groceries', amount: 1500, date: DateTime.now(),),
  ];

  List<Transaction> get recentTransactions{
    return userTransactions.where((tx){
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days:7),
      ),);
    }).toList();
  }

  void addNewTransaction(String txTitle, double txAmount, DateTime chosenDate)
  {
    final newTx = Transaction(title: txTitle, amount: txAmount, date: chosenDate, id: DateTime.now().toString());
    setState(() {
      userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return GestureDetector(
          onTap:(){},
          behavior: HitTestBehavior.opaque,
        child:
          NewTransaction(addNewTransaction)
      );
    });
  }

  void deleteTransaction(String id){
    setState(() {
      userTransactions.removeWhere(
          (tx){
            return tx.id == id;
          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => startAddNewTransaction(context),
            icon: Icon(Icons.add),
          )
        ],
        title: Text("Personal Expenses", ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              Chart(recentTransactions),
            TransactionList(userTransactions, deleteTransaction),
        ]
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}