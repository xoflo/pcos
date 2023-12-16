import 'package:flutter/material.dart';

class LogHandler {

  static const cream = Color(0xFFFCEDE0);
  static const green = Color(0xFF00504A);
  static const orange = Color(0xFFFF6600);
  static const sand = Color(0xFFEDB687);
  static const blue = Color(0xFF5B84E0);
  static const pink = Color(0xFFFFC6C2);
  static const red = Color(0xFFFB4A44);

  handleCM(int forExport, int cm) {
    return forExport == 0 ? cm == 0 ? Text(""): Tooltip(
        message: 'Has Cervical Mucus',
        child: Icon(Icons.circle, color: green, size: 10,)): cm == 0 ? Text("") : Icon(Icons.circle, color: green, size: 10);
  }

  handleSI(int forExport, int si) {

    final message = si == 1 ? 'Protected' : si == 2 ? "Unprotected" : si == 3 ? "Insemination" : si == 4 ? "Withdrawal" : "";

    return forExport == 0 ? si == 0 ? Text("") : Tooltip(
        message: message,
        child: Icon(Icons.circle, color: green, size: 10)) : si == 0 ? Text("") : Icon(Icons.circle, color: green, size: 10);
  }

  Widget handlePeriod(int forExport, int prd, int prds) {
    String message = "";
    String spotting = "";

    switch(prds) {
      case 0:
        spotting = "Spotting: None";
        break;
      case 1:
        spotting = "Spotting: Yes";
        break;
    }

    switch(prd) {
      case 1:
        message = "Light";
        break;
      case 2:
        message = "Medium";
        break;
      case 3:
        message = "Heavy";
        break;
    }

    return forExport == 0 ? prd != 0 ? Tooltip(
      message: "$message\n$spotting",
      child: Icon(Icons.circle, color: green, size: 10),
    ) : Text("") : prd != 0 ? Icon(Icons.circle, color: green, size: 10) : Text("");



  }


  Widget handleProgesterone(int forExport, int pgrs) {


    return forExport == 0 ? pgrs == 0 ? Text("") : Tooltip(
      message: 'Yes',
      child: Icon(Icons.circle, color: green, size: 10),
    ) : pgrs == 0 ? Text("") : Icon(Icons.circle, color: green, size: 10);

  }



  Widget handleMood(int forExport, List<int> moods) {

    List<String> messages = [];

    moods.forEach((mood) {
      switch (mood) {
        case 0:
          messages.add('Anxious');
          break;
        case 1:
          messages.add('Apathetic');
          break;
        case 2:
          messages.add('Chilled');
          break;
        case 3:
          messages.add('Contented');
          break;
        case 4:
          messages.add('Angry');
          break;
        case 5:
          messages.add('Happy');
          break;
        case 6:
          messages.add('Irritable');
          break;
        case 7:
          messages.add('Sad');
          break;
        case 8:
          messages.add('Stressed');
          break;
      }
    });


    final message = messages.join(", ").toString();


    return forExport == 0 ? Tooltip(
      message: message,
      child: Icon(Icons.circle, color: green, size: 10,),
    ): Icon(Icons.circle, color: green, size: 10);

  }


  Widget handleSymptoms(int forExport, List<int> symptoms) {

    List<String> messages = [];

    symptoms.forEach((mood) {
      switch (mood) {
        case 0:
          messages.add('Cramps');
          break;
        case 1:
          messages.add('Breast Pain');
          break;
        case 2:
          messages.add('Mood Changes');
          break;
        case 3:
          messages.add('Irritability');
          break;
        case 4:
          messages.add('Constipation');
          break;
        case 5:
          messages.add('Diarrhea');
          break;
        case 6:
          messages.add('Irritable');
          break;
        case 7:
          messages.add('Headache');
          break;
        case 8:
          messages.add('Acne');
          break;
      }
    });


    final message = messages.join(", ").toString();


    return forExport == 0 ? Tooltip(
      message: message,
      child: Icon(Icons.circle, color: green, size: 10)
    ) : Icon(Icons.circle, color: green, size: 10);

  }

  Widget handleEnr(int forExport, int enr) {
    String message = "";

    switch(enr) {
      case 0:
        message = "Exhausted";
        break;
      case 1:
        message = "Fatigue";
        break;
      case 2:
        message = "Flat";
        break;
      case 3:
        message = "Mediocre";
        break;
      case 4:
        message = "Reasonably Energetic";
        break;
      case 5:
        message = "Energetic";
        break;
    }

    return forExport == 0 ? enr != 0 ? Tooltip(
      message: message,
      child: Icon(Icons.circle, color: green, size: 10),
    ) : Text("") : enr != 0 ? Icon(Icons.circle, color: green, size: 10) : Text("");

  }



}