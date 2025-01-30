import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Email: support@dentalclinic.com'),
            const Text('Phone: +1 (555) 123-4567'),
            const Text('Address: 123 Dental Street, Clinic City'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement contact form or communication method
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact form coming soon!')),
                );
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
