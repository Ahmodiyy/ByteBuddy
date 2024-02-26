import 'package:bytebuddy/themes/pallete.dart';
import 'package:flutter/material.dart';

class MessageWidget {
  static OverlayEntry? _overlayEntry;

  static void showErrorOverlay(BuildContext context, String errorMessage) {
    // Remove existing overlay if any
    removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 80.0,
        right: 20,
        left: 20,
        //width: MediaQuery.of(context).size.width * 0.4,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: Card(
              color: Pallete.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Schedule removal of overlay after a delay
    Future.delayed(Duration(seconds: 3), () {
      removeOverlay();
    });
  }

  static void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void showSnackBar(BuildContext context, String message) {
    RegExp regExp = RegExp(r'\[.*?\]');
    String cleanedMessage = message.toString().replaceAll(regExp, '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cleanedMessage),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
      ),
    );
  }
}
