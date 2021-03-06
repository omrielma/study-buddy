import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/studentProviders/user_provider.dart';
import '../../../app_localizations.dart';

class PointsStatus extends StatelessWidget {
  final double width;
  final double height;
  const PointsStatus({
    this.height = 100,
    this.width = double.infinity,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String t(String text) => AppLocalizations.of(context).translate(text);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor.withOpacity(0.6)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                date,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                userProvider.points.toString() + t(' Points'),
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
