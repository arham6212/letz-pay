// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;

  final IconData icon;
}

const List<Choice> choices = const [
  const Choice(title: 'ALL', icon: Icons.abc),
  const Choice(title: 'Cards', icon: Icons.card_membership),
  const Choice(title: 'International', icon: Icons.language_sharp),
  const Choice(title: 'UPI', icon: Icons.directions_bus),
  const Choice(title: 'NB', icon: Icons.account_balance_sharp),
  // const Choice(title: 'More', icon: Icons.directions_walk),
  // const Choice(title: 'More', icon: Icons.directions_car),
  const Choice(title: 'Wallet', icon: Icons.account_balance_wallet),
  const Choice(title: 'UPI QR', icon: Icons.qr_code_2),
  const Choice(title: 'PG QR', icon: Icons.qr_code_2),
  const Choice(title: 'Static QR', icon: Icons.qr_code_2),
  const Choice(title: 'Cash', icon: Icons.directions_car),
];
