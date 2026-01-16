import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen  extends StatelessWidget {
  const SplashScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3), (){
        Navigator.pushReplacementNamed(context, "select_user");
      }
    );
    return Scaffold(
      appBar: AppBar(systemOverlayStyle:
        SystemUiOverlayStyle.dark,backgroundColor: Colors.transparent,
        ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Center(
                  child: Hero(
                    tag: "logo",
                    child: Image.asset("assets/img/image.png", width: 200,)
                    )
              ),
            ),
          ],
        ),
      ),
    );
  }
}