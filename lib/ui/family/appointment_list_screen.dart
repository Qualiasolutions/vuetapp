import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../../models/family_entities.dart';
import '../shared/widgets.dart';

/// Appointment List Screen - Shows all Appointment entities
/// Following detailed guide specifications with Modern Palette
class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load from Supabase using MCP tools
      // For now, show sample data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _appointments = [
          Appointment(
            id: 1,
            title: 'Doctor Appointment',
            startDatetime: DateTime.now().add(const Duration(days: 2, hours: 10)),
            endDatetime: DateTime.now().add(const Duration(days: 2, hours: 11)),
            location: 'Medical Center',
            notes: 'Annual checkup',
            patientIds: [1],
          ),
          Appointment(
            id: 2,
            title: 'Dentist Visit',
            startDatetime: DateTime.now().add(const Duration(days: 7, hours: 14)),
            endDatetime: DateTime.now().add(const Duration(days: 7, hours: 15)),
            location: 'Dental Clinic',
            notes: null,
            patientIds: [2],
          ),
          Appointment(
            id: 3,
            title: 'Pediatric Consultation',
            startDatetime: DateTime.now().add(const Duration(days: 14, hours: 9)),
            endDatetime: DateTime.now().add(const Duration(days: 14, hours: 10, minutes: 30)),
            location: 'Children\'s Hospital',
            notes: 'Follow-up appointment',
            patientIds: [3],
          ),
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading appointments: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Appointments'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? _buildEmptyState()
              : _buildAppointmentList(),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/family/appointments/create'),
        tooltip: 'Add Appointment',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_outlined,
            size: 64,
            color: AppColors.steel.withAlpha((255 * 0.5).round()),
          ),
          const SizedBox(height: 16),
          const Text(
            'No appointments yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.steel,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Schedule medical appointments and get automatic reminders',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          VuetSaveButton(
            text: 'Add First Appointment',
            onPressed: () => context.go('/categories/family/appointments/create'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList() {
    // Sort appointments by start date
    _appointments.sort((a, b) => a.startDatetime.compareTo(b.startDatetime));
    
    return RefreshIndicator(
      onRefresh: _loadAppointments,
      color: AppColors.mediumTurquoise,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _appointments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final appointment = _appointments[index];
          return _AppointmentCard(
            appointment: appointment,
            onTap: () => _showAppointmentDetails(appointment),
            onEdit: () => context.go('/categories/family/appointments/${appointment.id}/edit'),
            onDelete: () => _deleteAppointment(appointment),
          );
        },
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appointment.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Start', _formatDateTime(appointment.startDatetime)),
            _DetailRow('End', _formatDateTime(appointment.endDatetime)),
            _DetailRow('Duration', _formatDuration(appointment.startDatetime, appointment.endDatetime)),
            if (appointment.location != null)
              _DetailRow('Location', appointment.location!),
            if (appointment.notes != null)
              _DetailRow('Notes', appointment.notes!),
            _DetailRow('Status', _getAppointmentStatus(appointment.startDatetime)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/categories/family/appointments/${appointment.id}/edit');
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: Text('Are you sure you want to delete "${appointment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete from Supabase using MCP tools
              setState(() {
                _appointments.removeWhere((a) => a.id == appointment.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment deleted'),
                  backgroundColor: AppColors.mediumTurquoise,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  String _getAppointmentStatus(DateTime startTime) {
    final now = DateTime.now();
    if (startTime.isBefore(now)) {
      return 'Past';
    } else if (startTime.difference(now).inDays == 0) {
      return 'Today';
    } else if (startTime.difference(now).inDays == 1) {
      return 'Tomorrow';
    } else {
      return 'Upcoming';
    }
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.appointment,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Appointment appointment;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = appointment.startDatetime.day == now.day &&
                   appointment.startDatetime.month == now.month &&
                   appointment.startDatetime.year == now.year;
    final isPast = appointment.startDatetime.isBefore(now);
    
    return Card(
      color: isToday 
          ? AppColors.orange.withAlpha((255 * 0.1).round()) 
          : isPast 
              ? AppColors.steel.withAlpha((255 * 0.1).round())
              : AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isToday 
              ? AppColors.orange 
              : isPast 
                  ? AppColors.steel.withAlpha((255 * 0.5).round())
                  : AppColors.steel.withAlpha((255 * 0.3).round()),
          width: isToday ? 2 : 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isToday 
                      ? AppColors.orange.withAlpha((255 * 0.2).round())
                      : isPast
                          ? AppColors.steel.withAlpha((255 * 0.2).round())
                          : AppColors.mediumTurquoise.withAlpha((255 * 0.15).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isToday 
                      ? Icons.event_available 
                      : isPast 
                          ? Icons.event_busy
                          : Icons.event,
                  color: isToday 
                      ? AppColors.orange 
                      : isPast
                          ? AppColors.steel
                          : AppColors.mediumTurquoise,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isToday 
                            ? AppColors.orange 
                            : isPast
                                ? AppColors.steel
                                : AppColors.darkJungleGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(appointment.startDatetime),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.steel,
                      ),
                    ),
                    if (appointment.location != null)
                      Text(
                        appointment.location!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isToday 
                              ? AppColors.orange 
                              : AppColors.mediumTurquoise,
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.steel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkJungleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
