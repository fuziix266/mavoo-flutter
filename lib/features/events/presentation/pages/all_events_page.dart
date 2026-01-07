import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

class AllEventsPage extends StatelessWidget {
  final List<Event> events;

  const AllEventsPage({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      appBar: AppBar(
        title: const Text(
          'Todos los Eventos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0046fc), Color(0xFF00b2f6)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: events.isEmpty
          ? const Center(
              child: Text(
                'No hay eventos disponibles',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _EventCard(event: events[index]);
              },
            ),
    );
  }
}

class _EventCard extends StatefulWidget {
  final Event event;

  const _EventCard({required this.event});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  late int _currentParticipants;
  bool _isLoading = false;
  bool _isRegistered = false; // We don't know initial state, defaulting to false

  @override
  void initState() {
    super.initState();
    _currentParticipants = widget.event.currentParticipants;
  }

  Future<void> _handleEnrollment() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para inscribirte')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = sl<EventRepository>();
      final success = await repository.registerForEvent(
        widget.event.id,
        authState.user.id
      );

      if (mounted) {
        if (success) {
          setState(() {
            _isRegistered = true;
            _currentParticipants++;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscripción exitosa'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo realizar la inscripción'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFull = widget.event.maxParticipants != null &&
                  _currentParticipants >= widget.event.maxParticipants!;

    return GestureDetector(
      onTap: () {
        context.push('/events/${widget.event.id}', extra: widget.event);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del evento
            Text(
              widget.event.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0046fc),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            
            // Badge de deporte
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0046fc), Color(0xFF00b2f6)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.event.sport,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Descripción
            Text(
              widget.event.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Fecha
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDate(widget.event.eventDate),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            
            // Ubicación
            if (widget.event.location != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.event.location!,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            
            // Participantes y botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_currentParticipants/${widget.event.maxParticipants ?? "∞"} participantes',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    if (isFull)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Cupos llenos',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                ElevatedButton(
                  onPressed: (isFull && !_isRegistered) || _isLoading || _isRegistered
                      ? null
                      : _handleEnrollment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0046fc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    disabledBackgroundColor: _isRegistered ? Colors.green.withOpacity(0.1) : Colors.grey.shade300,
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : Text(
                        _isRegistered
                          ? 'Inscrito'
                          : (isFull ? 'Lleno' : 'Inscribirme'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _isRegistered ? Colors.green : (isFull ? Colors.grey.shade600 : Colors.white),
                        ),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 
                    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
