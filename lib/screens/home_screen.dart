import 'package:flutter/material.dart';
import '../models/lead.dart';
import '../viewmodels/lead_viewmodel.dart';
import '../locator.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/formatters.dart';
import 'add_lead_screen.dart';
import 'lead_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leadViewModel = locator<LeadViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => locator<AuthViewModel>().signOut(),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Lead>>(
        valueListenable: leadViewModel,
        builder: (context, leads, child) {
          if (leads.isEmpty) {
            return Center(child: Text('No leads found'));
          }
          return ListView.builder(
            itemCount: leads.length,
            itemBuilder: (context, index) {
              final lead = leads[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(lead.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatEnum(lead.status.name),
                        style: TextStyle(color: statusColor(lead.status)),
                      ),
                      Text(formatEnum(lead.channel.name)),
                      Text(formatDate(lead.timestamp)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LeadDetailScreen(lead: lead),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      // Floating action button to add a new lead
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddLeadScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
