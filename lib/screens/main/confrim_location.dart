import 'package:boom_client/screens/main/home_screen.dart.dart';
import 'package:boom_client/screens/widgets/save_button.dart';
import 'package:flutter/material.dart';

class ConfrimLocation extends StatefulWidget {
  const ConfrimLocation({super.key});

  @override
  State<ConfrimLocation> createState() => _ConfrimLocationState();
}

class _ConfrimLocationState extends State<ConfrimLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/cars.png"),
              SizedBox(
                  height: 220,
                  child: Card(
                      child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/person.png"),
                        ),
                        title: Text("Geroge Smith"),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                              "4.7",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/Call.png",
                                width: 50,
                              ),
                              Image.asset(
                                "assets/Oval 2.png",
                                width: 50,
                              )
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.car_rental,
                              color: Colors.black,
                            ),
                            Column(
                              children: [Text("Distance"), Text("2.3 KM")],
                            ),
                            Column(
                              children: [Text("Time"), Text("2.3 Hr")],
                            ),
                            Column(
                              children: [Text("Price"), Text("2000\$")],
                            )
                          ],
                        ),
                      ),
                      SaveButton(
                          title: "Confrim",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => HomePage()));
                          })
                    ],
                  )))
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/aa.png",
                ),
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover)),
      ),
    );
  }
}
