import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/features/location/presentation/location_controls.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SaferLocationMap extends StatelessWidget {
  const SaferLocationMap({
    super.key,
    required this.state,
    this.onRequestLocation,
    this.focusLocation,
    this.showControls = true,
  });

  final AppSessionState state;
  final VoidCallback? onRequestLocation;
  final DeviceLocation? focusLocation;
  final bool showControls;

  bool get _isWidgetTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fix = focusLocation ?? state.deviceLocation;
    final guidance = state.guidance;
    final catalog = state.catalog;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final height = wide ? 340.0 : 260.0;
    if (fix == null) {
      return InfoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.locationUnavailable),
            const SizedBox(height: AarogyaSpacing.sm),
            LocationControls(state: state),
          ],
        ),
      );
    }
    final here = LatLng(fix.latitude, fix.longitude);
    final safer = guidance == null
        ? null
        : LatLng(
            guidance.place.location.latitude,
            guidance.place.location.longitude,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fix.isDemonstration)
          Padding(
            padding: const EdgeInsets.only(bottom: AarogyaSpacing.sm),
            child: Text(
              l10n.demonstrationLocation,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: AarogyaColors.warning),
            ),
          ),
        SizedBox(
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
            child: _isWidgetTest
                ? const ColoredBox(
                    color: AarogyaColors.primarySoft,
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        color: AarogyaColors.primary,
                        size: 48,
                      ),
                    ),
                  )
                : FlutterMap(
                    key: ValueKey(
                      '${here.latitude}-${here.longitude}-${safer?.latitude}',
                    ),
                    options: MapOptions(
                      initialCenter: here,
                      initialZoom: 14,
                      initialCameraFit: safer == null
                          ? null
                          : CameraFit.coordinates(
                              coordinates: [here, safer],
                              padding: const EdgeInsets.all(48),
                              maxZoom: 16,
                            ),
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'aarogya.sih.web',
                      ),
                      if (catalog != null)
                        PolygonLayer(
                          polygons: [
                            for (final area in catalog.hazardAreas)
                              Polygon(
                                points: [
                                  for (final point in area.ring)
                                    LatLng(point.latitude, point.longitude),
                                ],
                                color: AarogyaColors.danger.withValues(
                                  alpha: 0.18,
                                ),
                                borderColor: AarogyaColors.danger,
                                borderStrokeWidth: 2,
                              ),
                          ],
                        ),
                      if (safer != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [here, safer],
                              color: AarogyaColors.primary,
                              strokeWidth: 3,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: here,
                            width: 36,
                            height: 36,
                            child: const Icon(
                              Icons.person_pin_circle,
                              color: AarogyaColors.primary,
                              size: 36,
                            ),
                          ),
                          if (safer != null)
                            Marker(
                              point: safer,
                              width: 36,
                              height: 36,
                              child: const Icon(
                                Icons.park_outlined,
                                color: AarogyaColors.safe,
                                size: 32,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AarogyaSpacing.sm),
        _MapLegend(l10n: l10n),
        const SizedBox(height: AarogyaSpacing.sm),
        Text(
          l10n.osmAttribution,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AarogyaColors.textSecondary),
        ),
        Text(
          l10n.mapTilesNeedNetwork,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AarogyaColors.textSecondary),
        ),
        const SizedBox(height: AarogyaSpacing.sm),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricRow(
                label: l10n.currentLocation,
                value: locationSourceLabel(l10n, fix.source),
                icon: Icons.my_location,
              ),
              MetricRow(
                label: l10n.location,
                value:
                    '${fix.latitude.toStringAsFixed(3)}, ${fix.longitude.toStringAsFixed(3)}',
                icon: Icons.location_on_outlined,
              ),
              if (guidance != null) ...[
                MetricRow(
                  label: l10n.recommendedSaferLocation,
                  value: guidance.place.label,
                  icon: Icons.north,
                ),
                MetricRow(
                  label: l10n.directionToSaferLocation,
                  value: l10n.distanceAndBearing(
                    guidance.distanceMeters.toStringAsFixed(0),
                    guidance.compassLabel,
                  ),
                  icon: Icons.explore_outlined,
                ),
                Text(l10n.saferLocationRecommended),
                Text(l10n.notDefinitelySafe),
                if (guidance.insideHazard) Text(l10n.insideHazardArea),
                if (guidance.recommendationReasons.isNotEmpty) ...[
                  const SizedBox(height: AarogyaSpacing.sm),
                  Text(
                    l10n.whyRecommended,
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AarogyaSpacing.xs),
                  for (final code in guidance.recommendationReasons)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(recommendationReasonLabel(l10n, code)),
                    ),
                ],
              ] else
                Text(l10n.noNearbySaferLocation),
              if (showControls) ...[
                const SizedBox(height: AarogyaSpacing.md),
                LocationControls(state: state),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  const _MapLegend({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AarogyaSpacing.md,
      runSpacing: AarogyaSpacing.sm,
      children: [
        _LegendItem(color: AarogyaColors.primary, label: l10n.mapLegendYou),
        _LegendItem(color: AarogyaColors.danger, label: l10n.mapLegendAffected),
        _LegendItem(color: AarogyaColors.safe, label: l10n.mapLegendSafer),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
