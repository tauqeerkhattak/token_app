import 'dart:io';

import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:token_app/utils/constants.dart';

class PrintOrders extends StatefulWidget {
  final String orderType;
  final String orderNumber;
  final String customerName;
  final String deliveryTime;
  final String instruction;
  final List<String> items;

  const PrintOrders({
    Key? key,
    required this.orderNumber,
    required this.orderType,
    required this.instruction,
    required this.items,
    required this.customerName,
    required this.deliveryTime,
  }) : super(key: key);

  @override
  State<PrintOrders> createState() => _PrintOrdersState();
}

class _PrintOrdersState extends State<PrintOrders> {
  final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String? _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  bool isLoading = true;

  void initPrinter() {
    _printerManager.startScan(const Duration(seconds: 2));
    _printerManager.scanResults.listen((event) {
      print('Listening');
      setState(() {
        _devices = event;
        isLoading = false;
      });

      if (_devices.isEmpty) {
        setState(() {
          _devicesMsg = 'No devices';
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    if (Platform.isIOS) {
      initPrinter();
    } else {
      bluetoothManager.state.listen((val) {
        print("state = $val");
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() {
            _devicesMsg = 'Please enable bluetooth to print';
          });
        }
        print('state is $val');
      });
    }
    super.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printer page"),
      ),
      backgroundColor: Constants.primaryColor,
      body: LoadingOverlay(
        isLoading: true,
        child: _devices.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, position) => ListTile(
                  onTap: () {
                    //  _startPrint(_devices[position]);
                  },
                  leading: const Icon(Icons.print),
                  title: Text(_devices[position].name!),
                  subtitle: Text(_devices[position].address!),
                ),
                itemCount: _devices.length,
              )
            : Center(
                child: Text(
                  _devicesMsg ?? 'Ops something went wrong!',
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
      ),
    );
  }
}
