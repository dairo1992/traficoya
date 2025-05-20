import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TollPoint {
  final String name;
  final double price;
  final LatLng position;

  TollPoint({required this.name, required this.price, required this.position});
}

class RouteMap {
  final String name;
  final String image;
  final String description;
  final List<TollPoint> tollPoints;
  final LatLng center;
  final double initialZoom;

  RouteMap({
    required this.name,
    required this.image,
    required this.description,
    required this.tollPoints,
    required this.center,
    required this.initialZoom,
  });
}

// Providers
final selectedRouteProvider = StateProvider<String?>((ref) => null);

final routesProvider = Provider<List<RouteMap>>((ref) {
  return [
    RouteMap(
      name: 'Ruta del Sol',
      image:
          'assets/ruta_sol.jpg', // Asegúrate de incluir estas imágenes en tu proyecto
      description: 'Conecta Bogotá con la Costa Caribe colombiana',
      center: const LatLng(5.7, -74.2),
      initialZoom: 7.0,
      tollPoints: [
        TollPoint(
          name: 'Peaje Los Patios',
          price: 12600.0,
          position: const LatLng(7.8452, -72.5086),
        ),
        TollPoint(
          name: 'Peaje Morrison',
          price: 8400.0,
          position: const LatLng(8.1734, -73.3918),
        ),
        TollPoint(
          name: 'Peaje Pailitas',
          price: 9700.0,
          position: const LatLng(8.9568, -73.6276),
        ),
        TollPoint(
          name: 'Peaje El Copey',
          price: 10300.0,
          position: const LatLng(10.1503, -73.9587),
        ),
      ],
    ),
    RouteMap(
      name: 'Ruta Caribe',
      image: 'assets/ruta_caribe.jpg',
      description: 'Recorre la costa norte de Colombia',
      center: const LatLng(10.3, -75.4),
      initialZoom: 8.0,
      tollPoints: [
        TollPoint(
          name: 'Peaje Galapa',
          price: 8700.0,
          position: const LatLng(10.8417, -74.8809),
        ),
        TollPoint(
          name: 'Peaje Papiros',
          price: 9500.0,
          position: const LatLng(10.9099, -74.7875),
        ),
        TollPoint(
          name: 'Peaje Puerto Colombia',
          price: 8100.0,
          position: const LatLng(11.0233, -74.8645),
        ),
        TollPoint(
          name: 'Peaje Marahuaco',
          price: 10800.0,
          position: const LatLng(10.9876, -75.0654),
        ),
      ],
    ),
    RouteMap(
      name: 'Ruta Paraíso',
      image: 'assets/ruta_paraiso.jpg',
      description: 'Conecta con los principales destinos turísticos del país',
      center: const LatLng(4.6, -74.8),
      initialZoom: 7.5,
      tollPoints: [
        TollPoint(
          name: 'Peaje Cajicá',
          price: 9200.0,
          position: const LatLng(4.9467, -74.0292),
        ),
        TollPoint(
          name: 'Peaje Jalisco',
          price: 11400.0,
          position: const LatLng(4.8239, -74.4511),
        ),
        TollPoint(
          name: 'Peaje Zambito',
          price: 12200.0,
          position: const LatLng(5.3028, -74.6529),
        ),
        TollPoint(
          name: 'Peaje Cocorná',
          price: 8900.0,
          position: const LatLng(6.0587, -75.1821),
        ),
      ],
    ),
  ];
});
