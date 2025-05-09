import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String description;
  final IconData icon;
  final Color color;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class Tips {
  final IconData icon;
  final String title;
  final String content;

  Tips({required this.icon, required this.title, required this.content});
}

// Proveedor para la lista de contactos de emergencia
final emergencyContactsProvider = Provider<List<EmergencyContact>>((ref) {
  return [
    EmergencyContact(
      name: 'Ambulancia',
      phoneNumber: '060',
      description: 'Servicios médicos de emergencia',
      icon: Icons.medical_services_rounded,
      color: Colors.red,
    ),
    EmergencyContact(
      name: 'Grúa',
      phoneNumber: '088',
      description: 'Servicio de remolque y asistencia vehicular',
      icon: Icons.car_repair,
      color: Colors.amber,
    ),
    EmergencyContact(
      name: 'Unidad de Rescate',
      phoneNumber: '065',
      description: 'Rescate en situaciones de emergencia',
      icon: Icons.health_and_safety_rounded,
      color: Colors.green,
    ),
    EmergencyContact(
      name: 'Carro Taller',
      phoneNumber: '078',
      description: 'Asistencia mecánica en carretera',
      icon: Icons.build_rounded,
      color: Colors.blue,
    ),
    EmergencyContact(
      name: 'Policía de Tránsito',
      phoneNumber: '066',
      description: 'Asistencia policial en carretera',
      icon: Icons.local_police_rounded,
      color: Colors.indigo,
    ),
    EmergencyContact(
      name: 'Asistencia Carretera',
      phoneNumber: '074',
      description: 'Información y ayuda general en carretera',
      icon: Icons.info_rounded,
      color: Colors.deepPurple,
    ),
  ];
});

// Proveedor para el filtrado de contactos
final searchQueryProvider = StateProvider<String>((ref) => '');

// Proveedor que filtra los contactos basados en la búsqueda
final filteredContactsProvider = Provider<List<EmergencyContact>>((ref) {
  final contacts = ref.watch(emergencyContactsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) {
    return contacts;
  }

  return contacts.where((contact) {
    return contact.name.toLowerCase().contains(query) ||
        contact.description.toLowerCase().contains(query);
  }).toList();
});

final tipsProvider = Provider<List<Tips>>((ref) {
  return [
    Tips(
      icon: Icons.warning_amber_rounded,
      title: 'Mantén la calma',
      content:
          'En situaciones de emergencia, mantener la calma te ayudará a tomar mejores decisiones.',
    ),
    Tips(
      icon: Icons.visibility,
      title: 'Hazte visible',
      content:
          'Enciende las luces de emergencia y coloca triángulos reflectantes a distancia adecuada.',
    ),
    Tips(
      icon: Icons.location_on,
      title: 'Conoce tu ubicación',
      content:
          'Intenta identificar tu ubicación exacta: kilómetro, dirección, referencias cercanas.',
    ),
    Tips(
      icon: Icons.phone_in_talk,
      title: 'Mantén batería',
      content:
          'Conserva la batería de tu teléfono. Si es posible, mantén un cargador portátil.',
    ),
  ];
});
