import 'package:flutter/material.dart';

class SaunaTurnedOffModePage extends StatefulWidget {
  final Function() onTap;
  const SaunaTurnedOffModePage({Key? key, required this.onTap}) : super(key: key);

  @override
  _SaunaTurnedOffModePageState createState() => _SaunaTurnedOffModePageState();
}

class _SaunaTurnedOffModePageState extends State<SaunaTurnedOffModePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: InkWell(
        onTap: widget.onTap,
        child: Container(
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
