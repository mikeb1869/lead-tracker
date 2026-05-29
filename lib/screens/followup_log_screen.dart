import 'package:flutter/material.dart';
import '../models/lead.dart';
import '../utils/formatters.dart';
import 'add_followup_screen.dart';
import 'package:lead_tracker/locator.dart';
import '../viewmodels/lead_viewmodel.dart';

class FollowUpLogScreen extends StatelessWidget {
  final Lead lead;

  const FollowUpLogScreen({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lead.name)),
      body: StreamBuilder<List<FollowUp>>(
        stream: locator<LeadViewModel>().getFollowUpsStream(lead.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final followUps = snapshot.data ?? [];
          if (followUps.isEmpty) {
            return const Center(child: Text('No follow-ups yet.'));
          }
          return ListView.builder(
            itemCount: followUps.length,
            itemBuilder: (context, index) {
              final followUp = followUps[index];
              return ListTile(
                title: Text(formatEnum(followUp.channel.name)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatDate(followUp.timestamp.toLocal())),
                    if (followUp.note.isNotEmpty)
                      Text(
                        followUp.note,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
                trailing: Chip(
                  label: Text(
                    followUp.responded ? 'Responded' : 'No response',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: followUp.responded
                      ? Colors.green.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.15),
                  labelStyle: TextStyle(
                    color: followUp.responded ? Colors.green : Colors.grey,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddFollowUpScreen(lead: lead)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
