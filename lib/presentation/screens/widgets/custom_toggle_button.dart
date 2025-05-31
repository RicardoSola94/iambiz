import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  final double width;
  final double height;

  final Color toggleColor;
  final Color toggleBackgroundColor;
  final Color toggleBorderColor;

  final Color inactiveTextColor;
  final Color activeTextColor;

  final VoidCallback onLeftToggleActive;
  final VoidCallback onRightToggleActive;

  const CustomToggleButton({
    Key? key,
    required this.width,
    required this.height,
    required this.toggleBackgroundColor,
    required this.toggleBorderColor,
    required this.toggleColor,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.onLeftToggleActive,
    required this.onRightToggleActive,
  }) : super(key: key);

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  double _toggleXAlign = -1;
  late Color _leftTextColor;
  late Color _rightTextColor;

  @override
  void initState() {
    super.initState();
    _leftTextColor = widget.activeTextColor;
    _rightTextColor = widget.inactiveTextColor;
  }

  void _setLeftSelected() {
    setState(() {
      _toggleXAlign = -1;
      _leftTextColor = widget.activeTextColor;
      _rightTextColor = widget.inactiveTextColor;
    });
    widget.onLeftToggleActive();
  }

  void _setRightSelected() {
    setState(() {
      _toggleXAlign = 1;
      _leftTextColor = widget.inactiveTextColor;
      _rightTextColor = widget.activeTextColor;
    });
    widget.onRightToggleActive();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.toggleBackgroundColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: widget.toggleBorderColor),
      ),
      child: Stack(
        children: [
          // Toggle background slider
          AnimatedAlign(
            alignment: Alignment(_toggleXAlign, 0),
            duration: const Duration(milliseconds: 250),
            child: Container(
              width: widget.width * 0.5,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.toggleColor,
                borderRadius: BorderRadius.only(
                  topLeft:
                      _toggleXAlign == -1 ? Radius.circular(50.0) : Radius.zero,
                  bottomLeft:
                      _toggleXAlign == -1 ? Radius.circular(50.0) : Radius.zero,
                  topRight:
                      _toggleXAlign == 1 ? Radius.circular(50.0) : Radius.zero,
                  bottomRight:
                      _toggleXAlign == 1 ? Radius.circular(50.0) : Radius.zero,
                ),
              ),
            ),
          ),
          // Productos (left)
          GestureDetector(
            onTap: _setLeftSelected,
            child: Align(
              alignment: Alignment(-1, 0),
              child: Container(
                width: widget.width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "Productos",
                  style: TextStyle(
                    color: _leftTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Servicios (right)
          GestureDetector(
            onTap: _setRightSelected,
            child: Align(
              alignment: Alignment(1, 0),
              child: Container(
                width: widget.width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  "Servicios",
                  style: TextStyle(
                    color: _rightTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
