import 'package:drivemanager/presenter/controllers/fleet_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/presenter/widgets/empty_fleet.dart';
import 'package:drivemanager/presenter/widgets/fleet_list.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  late FleetController _controller;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _controller = FleetController(
      supabase: supabase,
      onFleetUpdated: _updateFleetList,
      onCoordinatesUpdated: _updateCoordinatesList,
    );
    _controller.fetchFleetList();
    _controller.fetchCoordinatesList();
    _controller.subscribeToFleetUpdates();
    _controller.subscribeToCoordinatesUpdates();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateFleetList() {
    setState(() {});
  }

  void _updateCoordinatesList() {
    setState(() {});
  }

  void _openFleetRegisterScreen() async {
    await Navigator.pushNamed(context, '/fleet-register');
    _controller.fetchFleetList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _controller.fleetList.isEmpty && !_controller.isLoading
                ? EmptyFleet(onClick: _openFleetRegisterScreen)
                : FleetList(
                    onButtonClick: _openFleetRegisterScreen,
                    fleetList: _controller.fleetList,
                    coordinatesList: _controller.coordinatesList,
                  ),
          ),
        ),
        if (_controller.isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
