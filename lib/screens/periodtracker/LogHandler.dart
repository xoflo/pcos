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
        child: Icon(Icons.circle, color: green, size: 10,)) : si == 0 ? Text("") : Icon(Icons.circle, color: green, size: 10);
  }

  handlePeriod(int forExport, int prd) {

  }


  handleProgesterone(int forExport, int pgrs) {

  }



  handleMood(int forExport, List<int> moods) {

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


    if (forExport == 0) {
      return Tooltip(
        message: message,
        child: Icon(Icons.circle, color: green, size: 10,),
      );

    } else {
      return Icon(Icons.circle, color: green, size: 10);
    }
  }


  handleSymptoms(int forExport, List<int> symptoms) {

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


    if (forExport == 0) {
      return Tooltip(
        message: message,
        child: Icon(Icons.circle, color: green, size: 10,),
      );

    } else {
      return Icon(Icons.circle, color: green, size: 10);
    }
  }

  handleEnr(int forExport, int enr) {

  }



}