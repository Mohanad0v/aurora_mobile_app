import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// ------------------ Aurora Icon ------------------
class AuroraIcon extends StatelessWidget {
  final double size;
  final bool gradient;
  const AuroraIcon({super.key, this.size = 24.0, this.gradient = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" xmlns="http://www.w3.org/2000/svg">
  <defs>
    ${gradient ? '''
    <linearGradient id="aurora-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#3550E1" />
      <stop offset="50%" stop-color="#6B78E0" />
      <stop offset="100%" stop-color="#9B59B6" />
    </linearGradient>
    ''' : ''}
  </defs>
  <path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" fill="${gradient ? 'url(#aurora-gradient)' : 'currentColor'}"/>
  <path d="M19 19L19.5 20.5L21 21L19.5 21.5L19 23L18.5 21.5L17 21L18.5 20.5L19 19Z" fill="${gradient ? 'url(#aurora-gradient)' : 'currentColor'}"/>
  <path d="M5 5L5.5 6.5L7 7L5.5 7.5L5 9L4.5 7.5L3 7L4.5 6.5L5 5Z" fill="${gradient ? 'url(#aurora-gradient)' : 'currentColor'}"/>
</svg>
      ''',
      width: size,
      height: size,
      color: gradient ? null : Theme.of(context).colorScheme.primary,
    );
  }
}

/// ------------------ Property Icons ------------------
class PropertyIcon extends StatelessWidget {
  final String type;
  final double size;
  const PropertyIcon({super.key, required this.type, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    final icons = {
      'Villa': '''<svg viewBox="0 0 24 24"><path d="M12 3L2 12H5V20H19V12H22L12 3Z"/></svg>''',
      'Apartment': '''<svg viewBox="0 0 24 24"><path d="M17 11V3H7V11H3V21H21V11H17Z"/></svg>''',
      'Office': '''<svg viewBox="0 0 24 24"><path d="M12 7V3H2V21H22V7H12Z"/></svg>''',
      'Shop': '''<svg viewBox="0 0 24 24"><path d="M19 7H22V9H20V20C20 21.1 19.1 22 18 22H6C4.9 22 4 21.1 4 20V9H2V7H5V6C5 3.79 6.79 2 9 2H15C17.21 2 19 3.79 19 6V7Z"/></svg>''',
      'Penthouse': '''<svg viewBox="0 0 24 24"><path d="M12 2L22 12H19V20H5V12H2L12 2Z"/></svg>''',
    };

    final svg = icons[type] ?? icons['Villa']!;
    return SvgPicture.string(svg, width: size, height: size, color: Theme.of(context).colorScheme.onSurface);
  }
}

/// ------------------ Status Badge Icons ------------------
class StatusBadgeIcon extends StatelessWidget {
  final String status;
  final double size;
  const StatusBadgeIcon({super.key, required this.status, this.size = 12.0});

  @override
  Widget build(BuildContext context) {
    final colors = {
      'Available': '#10B981',
      'Rented': '#3B82F6',
      'Sold': '#EF4444',
    };
    final fill = colors[status] ?? '#10B981';

    return SvgPicture.string(
      '''
<svg viewBox="0 0 24 24" width="$size" height="$size">
  <circle cx="12" cy="12" r="10" fill="$fill"/>
</svg>
      ''',
      width: size,
      height: size,
    );
  }
}

/// ------------------ Amenity Icons ------------------
class AmenityIcons {
  static Widget pool({double size = 24}) => SvgPicture.string(
    '''<svg viewBox="0 0 24 24" width="$size" height="$size"><path d="M2 15C3.67 15 4.33 16.67 6 16.67S8.33 15 10 15 12.33 16.67 14 16.67 16.33 15 18 15 20.33 16.67 22 16.67V18.33C20.33 18.33 19.67 16.67 18 16.67S15.67 18.33 14 18.33 11.67 16.67 10 16.67 7.67 18.33 6 18.33 3.67 16.67 2 16.67V15Z"/></svg>''',
  );

  static Widget garden({double size = 24}) => SvgPicture.string(
    '''<svg viewBox="0 0 24 24" width="$size" height="$size"><path d="M12 22C10.69 22 9.58 21.16 9.19 20H4C2.9 20 2 19.11 2 18V16C2 14.89 2.9 14 4 14H9.19C9.58 12.84 10.69 12 12 12S14.42 12.84 14.81 14H20C21.11 14 22 14.89 22 16V18C22 19.11 21.11 20 20 20H14.81C14.42 21.16 13.31 22 12 22Z"/></svg>''',
  );
// Add others: Gym, Parking, Security...
}

/// ------------------ Navigation Icons ------------------
class NavigationIcons {
  static Widget vr({double size = 24}) => SvgPicture.string(
    '''<svg viewBox="0 0 24 24" width="$size" height="$size"><path d="M20.84 4.61A5.96 5.96 0 0 0 16.97 3C14.77 3 13.03 4.74 13.03 6.94C13.03 7.71 13.26 8.42 13.66 9H10.34C10.74 8.42 10.97 7.71 10.97 6.94C10.97 4.74 9.23 3 7.03 3C5.39 3 4.05 4.34 4.05 5.98C4.05 7.62 5.39 8.96 7.03 8.96H16.97C18.61 8.96 19.95 7.62 19.95 5.98C19.95 5.41 19.78 4.87 19.47 4.42L20.84 4.61ZM17 11H7C3.69 11 1 13.69 1 17S3.69 23 7 23H17C20.31 23 23 20.31 23 17S20.31 11 17 11Z"/></svg>''',
  );

  static Widget ar({double size = 24}) => SvgPicture.string(
    '''<svg viewBox="0 0 24 24" width="$size" height="$size"><path d="M12 2C6.48 2 2 6.48 2 12S6.48 22 12 22 22 17.52 22 12 17.52 2 12 2Z"/></svg>''',
  );

  static Widget model3D({double size = 24}) => SvgPicture.string(
    '''<svg viewBox="0 0 24 24" width="$size" height="$size"><path d="M12 2L2 7L12 12L22 7L12 2ZM2 17L12 22L22 17L18.5 15L12 18L5.5 15L2 17ZM2 12L12 17L22 12L18.5 10L12 13L5.5 10L2 12Z"/></svg>''',
  );
}
