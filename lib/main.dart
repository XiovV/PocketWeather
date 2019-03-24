import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new CountryInput(),
  ));
}

class CountryInput extends StatefulWidget {
  @override
  CountryInputState createState() => new CountryInputState();
}

class CountryInputState extends State<CountryInput> {
  String temp = "";
  String humidity = "";
  String windSpeed = "";
  String textInput = "";
  String clouds = "";
  String description = "";
  String descriptionImage = "";

  void choiceAction(String choice) {
    if (choice == "About") {
      print("About");
    } else if (choice == "Settings") {
      print("Settings");
    }
  }

  getData(String country) async {
    final response = await http.get(
        "http://138.68.73.49:6000/w/" + country,
        headers: {"Accept": "application/json"});

    var data = jsonDecode(response.body);

    print(data);

    setState(() {
      temp = data['t'].round().toString();
      windSpeed = data['w'].toString();
      clouds = data['c'].toString();
      humidity = data['h'].toString();
      description = data['d'];

      if(description == "light rain" || description == "moderate rain" || description == "heavy intensity rain" || description == "very heavy rain" || description == "extreme rain" || description == "freezing rain" || description == "light intensity shower rain" || description == "shower rain" || description == "heavy intensity shower rain" || description == "ragged shower rain") {
        descriptionImage = 'images/rain.png';
      } else if (description == "thunderstorm with light rain" || description == "thunderstorm with rain" || description == "thunderstorm with heavy rain" || description == "light thunderstorm" || description == "thunderstorm" || description == "heavy thunderstorm" || description == "ragged thunderstorm" || description == "thunderstorm with light drizzle" || description == "thunderstorm with drizzle" || description == "thunderstorm with heavy drizzle") {
        descriptionImage = 'images/storm.png';
      } else if (description == "light snow" || description == "snow" || description == "heavy snow" || description == "sleet" || description == "shower sleet" || description == "light rain and snow" || description == "rain and snow" || description == "light shower snow" || description == "shower snow" || description == "heavy shower snow") {
        descriptionImage = 'images/snow.png';
      } else if (description == "mist" || description == "smoke" || description == "haze" || description == "sand, dust whirls" || description == "fog" || description == "sand" || description == "dust" || description == "volcanic ash" || description == "squalls" || description == "tornado	") {
        descriptionImage = "images/mist.png";
      } else if (description == 'few clouds' || description == 'scattered clouds' || description == 'broken clouds' || description == 'overcast clouds') {
        descriptionImage = "images/clouds_modified.png";
      } else if (description == 'clear sky') {
        descriptionImage = "images/sun.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const marginMain = 10.0;
    const fontSizeRow = 30.0;

    const String About = "About";
    const String Settings = "Settings";

    const List<String> choices = <String>[
      About,
      Settings
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("PocketWeather"),
        backgroundColor: new Color.fromARGB(500, 79, 192, 141),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: () {
              getData(textInput);
            },
          ),
          new PopupMenuButton(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: new Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(children: <Widget>[
          new ListTile(title: new Text("London"), onTap: () {
            getData("London");
            Navigator.pop(context);
          },),
          new ListTile(title: new Text("Sarajevo"), onTap: () {
            getData("Sarajevo");
            Navigator.pop(context);
          },),
          new ListTile(leading: Icon(Icons.add), title: new Text("Add City"), onTap: () {
            Navigator.pop(context);
          },),
        ],),
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              // new TextField(
              //   decoration: new InputDecoration(hintText: "Enter your city"),
              //   onSubmitted: (String str) {
              //     setState(() {
              //       textInput = str;
              //       getData(str);
              //     });
              //   },
              // ),
              new Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: new Image.asset(descriptionImage, width: 200, height: 200)
              ),
              new Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: new Text(description),
              ),
              new Text(temp + "°C",
                  style: TextStyle(fontSize: 70)),
              new Row(children: <Widget>[
                new Container(
                  margin: const EdgeInsets.all(marginMain),
                  //child: new Text(windSpeed + 'm/s'),
                  child: Row(children: <Widget>[
                    new Container(
                      margin:EdgeInsets.all(5),
                      child: new Image.asset("images/humidity.png", width: 30, height: 30)
                    ),  
                    new Text(humidity + "%", style: TextStyle(fontSize: fontSizeRow))
                  ],),
                ),
                new Container(
                  margin: const EdgeInsets.all(marginMain),
                  child: Row(children: <Widget>[
                    new Container(
                      margin:EdgeInsets.all(5),
                      child: new Image.asset("images/wind.png", width: 30, height: 30)
                    ),  
                    new Text(windSpeed + "m/s", style: TextStyle(fontSize: fontSizeRow))
                  ],),
                ),
                new Container(
                   margin: const EdgeInsets.all(marginMain),
                  child: Row(children: <Widget>[
                    new Container(
                      margin:EdgeInsets.all(5),
                      child: new Image.asset("images/clouds_modified.png", width: 30, height: 30)
                    ),  
                    new Text(clouds + "%", style: TextStyle(fontSize: fontSizeRow))
                  ],),
                ),
              ]),
            ],
          ),
        ),
      ),
    );

    
  }
}

// new Text("Temperature: " + temp + "°C",
//     style: TextStyle(fontSize: 20)),
// new Text("Humidity: " + humidity + "%",
//     style: TextStyle(fontSize: 20)),
// new Text("Wind Speed: " + windSpeed + "m/s",
//     style: TextStyle(fontSize: 20)),
// new Text("Description: " + description,
//     style: TextStyle(fontSize: 20))