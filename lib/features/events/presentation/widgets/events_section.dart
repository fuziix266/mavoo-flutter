import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class EventsSection extends StatefulWidget {
  final EventRepository repository;

  const EventsSection({Key? key, required this.repository}) : super(key: key);

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  List<Event> events = [];
  bool isLoading = true;
  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() => isLoading = true);
    final loadedEvents = await widget.repository.getUpcomingEvents();
    if (mounted) {
      setState(() {
        events = loadedEvents;
        isLoading = false;
      });
    }
  }

  Future<void> _handleEnrollment(Event event) async {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      try {
        final userId = authState.user.id;
        // Mostrar indicador de carga o feedback inmediato si se desea

        final success =
            await widget.repository.registerForEvent(event.id, userId);

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Inscripción exitosa!'),
              backgroundColor: Color(0xFF0046fc),
            ),
          );
          _loadEvents(); // Actualizar lista para reflejar cambios en participantes
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'No se pudo completar la inscripción. Verifica si ya estás inscrito o intenta más tarde.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar usuario: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para inscribirte.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _previousEvent() {
    if (currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextEvent() {
    if (currentIndex < events.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            const Color(0xFF00b2f6).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con gradiente
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0046fc), Color(0xFF00b2f6)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Próximos Eventos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Botón "Ver todos"
                  if (events.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        context.push('/events/all', extra: events);
                      },
                      icon: const Icon(Icons.grid_view,
                          color: Colors.white, size: 18),
                      label: const Text(
                        'Ver todos',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Carrusel de eventos
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (events.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No hay eventos próximos',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Column(
                children: [
                  // Carrusel
                  SizedBox(
                    height: 280,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: _EventCard(
                            event: events[index],
                            onEnroll: _handleEnrollment,
                          ),
                        );
                      },
                    ),
                  ),

                  // Controles de navegación
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón anterior
                        IconButton(
                          onPressed: currentIndex > 0 ? _previousEvent : null,
                          icon: const Icon(Icons.arrow_back_ios),
                          color: const Color(0xFF0046fc),
                          disabledColor: Colors.grey.shade300,
                          style: IconButton.styleFrom(
                            backgroundColor: currentIndex > 0
                                ? const Color(0xFF0046fc).withOpacity(0.1)
                                : Colors.grey.shade100,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),

                        // Indicador de página
                        Row(
                          children: List.generate(
                            events.length > 5 ? 5 : events.length,
                            (index) {
                              final dotIndex = currentIndex >= 5
                                  ? (index == 4
                                      ? events.length - 1
                                      : currentIndex - 2 + index)
                                  : index;
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: dotIndex == currentIndex ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: dotIndex == currentIndex
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF0046fc),
                                            Color(0xFF00b2f6)
                                          ],
                                        )
                                      : null,
                                  color: dotIndex == currentIndex
                                      ? null
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          ),
                        ),

                        // Botón siguiente
                        IconButton(
                          onPressed: currentIndex < events.length - 1
                              ? _nextEvent
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: const Color(0xFF0046fc),
                          disabledColor: Colors.grey.shade300,
                          style: IconButton.styleFrom(
                            backgroundColor: currentIndex < events.length - 1
                                ? const Color(0xFF0046fc).withOpacity(0.1)
                                : Colors.grey.shade100,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contador de eventos
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Evento ${currentIndex + 1} de ${events.length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
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
}

class _EventCard extends StatelessWidget {
  final Event event;
  final Function(Event) onEnroll;

  const _EventCard({
    required this.event,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/events/${event.id}', extra: event);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del evento
                Text(
                  event.name,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0046fc), Color(0xFF00b2f6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.sport,
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
                  event.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Fecha y ubicación
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(event.eventDate),
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                if (event.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location!,
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

            // Participantes y botón
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${event.currentParticipants}/${event.maxParticipants ?? "∞"} participantes',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: event.isFull ? null : () => onEnroll(event),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0046fc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    event.isFull ? 'Lleno' : 'Inscribirme',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
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
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
