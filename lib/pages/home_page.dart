import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/models/weather_units.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/providers/weather_repository_provider.dart';
import 'package:weather_app/widgets/basic_responsive.dart';
import 'package:weather_app/widgets/icon_and_text.dart';
import 'package:weather_app/widgets/percent_sized_box.dart';
import 'package:weather_app/widgets/weather_display.dart';
import 'package:weather_app/widgets/weather_display_simple.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currWeather = ref.watch(currentWeatherProvider);

    final unit = ref.watch(selectedUnitProvider);
    final provider = ref.watch(selectedServicePrefProvider);

    final colorsDay = [
      theme.primaryColor,
      const Color.fromARGB(255, 122, 197, 255),
    ];
    final colorsNight = [
      const Color.fromARGB(255, 2, 22, 44),
      const Color.fromARGB(255, 9, 62, 110),
    ];

    final isDay = useState<bool>(false);
    useEffect(() {
      currWeather.maybeWhen(
        orElse: () {},
        data: (data) {
          isDay.value = data.isDay;
        },
      );
      return null;
    }, [currWeather]);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDay.value ? colorsDay : colorsNight,
                  stops: const [0.8, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Weather App',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  currWeather.when(
                    error: (_, __) => const SizedBox(),
                    data: (data) => WeatherDisplaySimple(data: data),
                    loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ),
                ],
              ),
            ),

            // service provider popup
            PopupMenuButton(
              itemBuilder: (_) => buildWeatherProviderMenu(ref),
              child: ListTile(
                leading: const Icon(UniconsLine.server_network_alt),
                trailing: const Icon(UniconsLine.angle_right_b),
                title: const Text('Data Provider'),
                subtitle: Text(provider),
              ),
            ),

            // unit popup
            PopupMenuButton(
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: WeatherUnits.metric,
                  child: const Text('Metric'),
                  onTap: () => ref.read(selectedUnitProvider.notifier).update(WeatherUnits.metric),
                ),
                PopupMenuItem(
                  value: WeatherUnits.imperial,
                  child: const Text('Imperial'),
                  onTap: () => ref.read(selectedUnitProvider.notifier).update(WeatherUnits.imperial),
                ),
              ],
              child: ListTile(
                leading: const Icon(UniconsLine.ruler),
                trailing: const Icon(UniconsLine.angle_right_b),
                title: const Text('Unit'),
                subtitle: Text(unit.name),
              ),
            ),
            
            const Divider(),

            // refresh button
            ListTile(
              leading: const Icon(UniconsLine.refresh),
              trailing: const Icon(UniconsLine.angle_right_b),
              title: const Text('Refresh'),
              onTap: () {
                ref.invalidate(weatherRepositoryProvider);
              },
            ),

            const Divider(),

            // logout button
            ListTile(
              leading: const Icon(UniconsLine.signout),
              trailing: const Icon(UniconsLine.angle_right_b),
              title: const Text('Logout'),
              onTap: () {
                
              },
            ),
          ],
        ),
      ),
      backgroundColor: theme.primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDay.value ? colorsDay : colorsNight,
                stops: const [0.8, 1.0],
              ),
            ),
          ),

          currWeather.when(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
            error: (ex, _) {
              final err = ex is String ? ex : 'Unknown error';
              return Center(
                child: BasicResponsive(
                  mobile: _buildError(err, 1.0, ref),
                  tablet: _buildError(err, 0.9, ref),
                  desktop: _buildError(err, 0.6, ref),
                  desktopHQ: _buildError(err, 0.3, ref),
                ),
              );
            },
            data: (data) => SingleChildScrollView(
              child: BasicResponsive(
                mobile: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48.0),
                  child: _buildWeatherDisplay(data, 1.0),
                ),
                tablet: _buildWeatherDisplay(data, 0.9),
                desktop: _buildWeatherDisplay(data, 0.6),
                desktopHQ: _buildWeatherDisplay(data, 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, double widthFactor, WidgetRef ref) {
    return PercentSizedBox(
      widthFactor: widthFactor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(UniconsLine.exclamation_triangle, color: Colors.black87),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  itemBuilder: (_) => buildWeatherProviderMenu(ref),
                  child: const IconAndText(
                    icon: Icon(UniconsLine.angle_down),
                    text: 'Switch Provider',
                  ),
                ),
                const SizedBox(width: 8.0),
                TextButton.icon(
                  onPressed: () {
                    ref.invalidate(weatherRepositoryProvider);
                  },
                  icon: const Icon(UniconsLine.refresh, color: Colors.black87),
                  label: const Text('Retry', style: TextStyle(color: Colors.black87)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDisplay(Weather data, double widthFactor) {
    return PercentSizedBox(
      widthFactor: widthFactor,
      child: WeatherDisplay(data: data),
    );
  }
}
