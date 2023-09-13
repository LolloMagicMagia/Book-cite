import 'package:cite/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import 'customBottomNagivator.dart';
import 'home/Home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserApp?>(context);

    if(user == null){
      return Authenticate();
    }else{
      return CustomBottomNavigationBar();
    }

  }
}
