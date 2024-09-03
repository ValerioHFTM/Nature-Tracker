import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nature_tracker/models/app_colors.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:battery_plus/battery_plus.dart'; // Add the battery_plus package to your pubspec.yaml

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final Battery _battery = Battery();
  late StreamSubscription<BatteryState> _batterySubscription;
  int _batteryLevel = 0; // Store battery level

  @override
  void initState() {
    super.initState();
    _updateBatteryLevel(); // Initialize battery level
    _batterySubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      _updateBatteryLevel();
    });
  }

  @override
  void dispose() {
    _batterySubscription.cancel(); // Cancel subscription when disposing
    super.dispose();
  }

  Future<void> _updateBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  Widget _getBatteryIcon(int batteryLevel) {
    if (batteryLevel >= 75) {
      return Icon(Icons.battery_full, color: AppColors.color1, size: 20);
    } else if (batteryLevel >= 50) {
      return Icon(Icons.battery_3_bar, color: AppColors.color5, size: 20);
    } else if (batteryLevel >= 25) {
      return Icon(Icons.battery_2_bar, color: AppColors.color4, size: 20);
    } else {
      return Icon(Icons.battery_alert, color: AppColors.redColor, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Color.fromARGB(24, 116, 142, 85), // Desired color
                BlendMode.srcIn, // Blend mode to apply color
              ),
              child: Image.asset(
                'assets/images/Icon_White.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: AppColors.color3,
                elevation: 6.0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.color1),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: SizedBox(
                  height: 40,
                  child: Image.asset(
                    'assets/images/Logo_Black_NatureTracker_Long.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.color1,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("data"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Footer Styled Part
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: AppColors.color3,
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Author Information
                      Text(
                        'author.username',
                        style: TextStyle(
                          color: AppColors.color1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Battery Icon and Level
                      Row(
                        children: [
                          _getBatteryIcon(_batteryLevel),
                          const SizedBox(width: 8),
                          Text(
                            '$_batteryLevel%', // Display battery level
                            style: TextStyle(
                              color: AppColors.color1,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
