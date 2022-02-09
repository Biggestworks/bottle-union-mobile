import 'package:flutter/material.dart';

class SliverTitle extends StatefulWidget {
  final Widget child;
  final Widget secondChild;

  const SliverTitle({Key? key, required this.child, required this.secondChild}) : super(key: key);
  @override
  _SliverTitleState createState() => _SliverTitleState();
}

class _SliverTitleState extends State<SliverTitle> {
  ScrollPosition? _position;
  bool _visible = false;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }
  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }
  void _removeListener() {
    _position?.removeListener(_positionListener);
  }
  void _positionListener() {
    final FlexibleSpaceBarSettings? settings = context.dependOnInheritedWidgetOfExactType();
    bool visible = settings == null || settings.currentExtent > settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: _visible ? widget.child : widget.secondChild,
    );
  }
}
