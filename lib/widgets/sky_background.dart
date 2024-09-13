import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';

final colorsNight = [
  const Color.fromARGB(255, 2, 22, 44),
  const Color.fromARGB(255, 9, 62, 110),
];

class SkyBackground extends HookConsumerWidget {
  const SkyBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorsDay = [
      theme.primaryColor,
      const Color.fromARGB(255, 122, 197, 255),
    ];
    
    final currWeather = ref.watch(currentWeatherProvider);
    
    final isDay = useState<bool>(true);
    useEffect(() {
      currWeather.maybeWhen(
        orElse: () {},
        data: (data) {
          isDay.value = data.isDay;
        },
      );
      return null;
    }, [currWeather]);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDay.value ? colorsDay : colorsNight,
          stops: const [0.8, 1.0],
        ),
      ),
    );
  }
}
