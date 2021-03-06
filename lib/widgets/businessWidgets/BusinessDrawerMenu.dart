import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_buddy/providers/studentProviders/user_provider.dart';

import '../../app_localizations.dart';

class BusinessDrawerMenu extends StatelessWidget {
  const BusinessDrawerMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String t(String text) => AppLocalizations.of(context).translate(text);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  DrawerHeader(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.height * 0.1,
                                margin: EdgeInsets.only(left: 10),
                                child: CircleAvatar(
                                  backgroundImage: userProvider.imageProvider,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(userProvider.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ]),
          ),
          Column(
            children: [
              Divider(),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text(t("Logout")),
                  onTap: () {
                    Navigator.pop(context);
                    userProvider.logout();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
