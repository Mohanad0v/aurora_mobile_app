// lib/features/contact_us/presentation/widgets/contact_info.dart
import 'package:flutter/material.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text("123 Main Street, City, Country"),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text("+1 234 567 890"),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text("support@example.com"),
        ),
      ],
    );
  }
}
