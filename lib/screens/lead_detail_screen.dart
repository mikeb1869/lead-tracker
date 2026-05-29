import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/lead.dart';
import '../utils/formatters.dart';
import 'followup_log_screen.dart';
import '../viewmodels/lead_viewmodel.dart';
import '../locator.dart';

class LeadDetailScreen extends StatelessWidget {
  final Lead lead;

  const LeadDetailScreen({super.key, required this.lead});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _showStatusUpdateDialog(BuildContext context) async {
    final leadViewModel = locator<LeadViewModel>();
    LeadStatus? newStatus = lead.status;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Update Lead Status'),
              content: DropdownButtonFormField<LeadStatus>(
                initialValue: newStatus,
                onChanged: (value) => setDialogState(() => newStatus = value),
                items: LeadStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(formatEnum(status.name)),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newStatus != null && newStatus != lead.status) {
                      final updatedLead = lead.copyWith(status: newStatus);
                      leadViewModel.updateLead(updatedLead);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lead.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showStatusUpdateDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Contact',
            children: [
              _InfoRow(icon: Icons.person, label: 'Name', value: lead.name),
              _InfoRow(icon: Icons.phone, label: 'Phone', value: lead.phone),
              _InfoRow(
                icon: Icons.email,
                label: 'Email',
                value: lead.email.isEmpty ? '(not provided)' : lead.email,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Lead Info',
            children: [
              _InfoRow(
                icon: Icons.campaign,
                label: 'Channel',
                value: formatEnum(lead.channel.name),
              ),
              _InfoRow(
                icon: Icons.flag,
                label: 'Status',
                value: formatEnum(lead.status.name),
                valueColor: _statusColor(lead.status),
              ),
              _InfoRow(
                icon: Icons.access_time,
                label: 'Received',
                value: formatDate(lead.timestamp),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Message',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  lead.message.isEmpty ? '(no message)' : lead.message,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Actions',
            children: [
              _ActionTile(
                icon: Icons.phone,
                label: 'Call',
                color: Colors.green,
                onTap: () => _launch('tel:${lead.phone}'),
              ),
              _ActionTile(
                icon: Icons.sms,
                label: 'Text',
                color: Colors.blue,
                onTap: () => _launch('sms:${lead.phone}'),
              ),
              _ActionTile(
                icon: Icons.email,
                label: 'Email',
                color: Colors.orange,
                onTap: () => _launch('mailto:${lead.email}'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Follow-Up Log'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FollowUpLogScreen(lead: lead),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(LeadStatus status) {
    switch (status) {
      case LeadStatus.fresh:
        return Colors.blue;
      case LeadStatus.contacted:
        return Colors.orange;
      case LeadStatus.closed:
        return Colors.green;
      case LeadStatus.lost:
        return Colors.red;
    }
  }
}

// Reusable section card widget for grouping lead details
class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

// Reusable info row widget for displaying lead details
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Action tile for call/email/sms
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
