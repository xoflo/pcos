
import '../workout.dart';

class WorkoutResponse {
  List<Workout>? results;

  WorkoutResponse({this.results});

  factory WorkoutResponse.fromList(List<dynamic> json) {
    List<Workout> workouts = [];
    if (json.length > 0) {
      json.forEach((item) {
        workouts.add(Workout.fromJson(item));
      });
    }
    return WorkoutResponse(results: workouts);
  }
}

//Example
/*
{
  "status": "OK",
  "message": "",
  "info": "",
  "payload": [
    {
      "adminName": "",
      "adminNotes": "",
      "workoutID": 1,
      "title": "BeginnerMove1",
      "description": "Agreatplacetostartyourmovementjourney, usingourbodyweightforresistance!",
      "tags": "Bodyweight, Pregnancyfriendly",
      "minsToComplete": 45,
      "orderIndex": 10,
      "imageUrl": "https: //asset.cloudinary.com/dbee2ldxn/ea5cf91d579ea5be6d217892caac4255",
      "isFavorite": false,
      "isComplete": false,
      "exercises": [
        {
          "exerciseID": 1,
          "title": "Tricepdips",
          "description": "<p>Legsbentforlessweightorstraight/evenraisedforahardervariation.</p>\r\n<p>Keeparmsapproxhipwidth.</p>\r\n<p>Engagetriceps.</p>\r\n<p>Focusonkeepingelbowsinastraightlineratherthansplayingout.</p>",
          "imageUrl": "",
          "mediaUrl": "https: //1693712952.rsc.cdn77.org/122448/63e4536d6e5a3605108634playlist-1080.m3u8",
          "equipmentRequired": "",
          "tags": "",
          "setsMinimum": 3,
          "setsMaximum": 3,
          "repsMinimum": 10,
          "repsMaximum": 10,
          "secsBetweenSets": 0,
          "isFavorite": false,
          "lastUpdatedUTC": "2023-02-09T03: 24: 53.573",
          "dateCreatedUTC": "2023-02-09T03: 24: 53.573"
        },
        {
          "exerciseID": 2,
          "title": "Wallpushups",
          "description": "lorenipsum",
          "imageUrl": "",
          "mediaUrl": "https: //1693712952.rsc.cdn77.org/122448/63e468cb85fb9846744788playlist-1080.m3u8",
          "equipmentRequired": "",
          "tags": "",
          "setsMinimum": 3,
          "setsMaximum": 3,
          "repsMinimum": 10,
          "repsMaximum": 10,
          "secsBetweenSets": 0,
          "isFavorite": false,
          "lastUpdatedUTC": "2023-02-09T03: 25: 29.51",
          "dateCreatedUTC": "2023-02-09T03: 25: 29.51"
        },
        {
          "exerciseID": 3,
          "title": "Pullaparts-BANDED",
          "description": "lorenipsum",
          "imageUrl": "",
          "mediaUrl": "https: //s3.amazonaws.com/spotlightr-output/122448/63e4654fa4872440483248playlist-1080.m3u8",
          "equipmentRequired": "",
          "tags": "",
          "setsMinimum": 3,
          "setsMaximum": 3,
          "repsMinimum": 10,
          "repsMaximum": 10,
          "secsBetweenSets": 0,
          "isFavorite": false,
          "lastUpdatedUTC": "2023-02-09T03: 26: 07.697",
          "dateCreatedUTC": "2023-02-09T03: 26: 07.697"
        },
        {
          "exerciseID": 4,
          "title": "Stepups, bodyweight",
          "description": "<p>Makesureyourworkinglegisdoingallofthework.</p>\r\n<p>Ifyou’resteppingupwithyourleftleg, don’tpushoffthegroundwithyourrightone.</p>\r\n<p>Whenyouloweryourleftfootbacktotheground, doitundercontrol.</p>",
          "imageUrl": "",
          "mediaUrl": "https: //1693712952.rsc.cdn77.org/122448/63e4537f078c8002243608playlist-1080.m3u8",
          "equipmentRequired": "",
          "tags": "",
          "setsMinimum": 3,
          "setsMaximum": 3,
          "repsMinimum": 12,
          "repsMaximum": 12,
          "secsBetweenSets": 0,
          "isFavorite": false,
          "lastUpdatedUTC": "2023-02-09T03: 27: 28.183",
          "dateCreatedUTC": "2023-02-09T03: 27: 28.183"
        },
        {
          "exerciseID": 5,
          "title": "Romaniandeadlift, banded",
          "description": "lorenipsum",
          "imageUrl": "",
          "mediaUrl": "https: //1693712952.rsc.cdn77.org/122448/63e4655f0e459227628035playlist-1080.m3u8",
          "equipmentRequired": "",
          "tags": "",
          "setsMinimum": 3,
          "setsMaximum": 3,
          "repsMinimum": 10,
          "repsMaximum": 10,
          "secsBetweenSets": 0,
          "isFavorite": false,
          "lastUpdatedUTC": "2023-02-09T03: 27: 50.42",
          "dateCreatedUTC": "2023-02-09T03: 27: 50.42"
        },
        {
          "exerciseID": 6,
          "title": "Squat, normalstance",
          "description": "<p>Standwithyourfeethip-widthapartandyourtoespointingforward.</p>\r\n<p>Loweryourbodyasifyouweresittingbackintoachair, keepingyourbackstraightandyourchestlifted.</p>\r\n<p>Godownasfarasyoucanwhilekeepingyourheelsflatontheground.</p>\r\n<p>Pushbackupthroughyourheelstoreturntothestartingposition.</p>\r\n<p>Repeatforthedesirednumberofrepetitions.</p>\r\n<p>Makesuretokeepyourkneesoveryouranklesandnotextendpastyourtoesasyousquat.</p>\r\n<p>Keepyourweightinyourheels, andengageyourcoretomaintainbalanceandstability.</p>",
          "imageUrl": "",
          "mediaUrl": "https: //1693712952.rsc.cdn77.org/122448/63e4536b95c64782467747playlist-1080.m3u8",
          "equipmentRequired": "",
          "tags": "",
          "setsMinimum": 3,
          "setsMaximum": 3,
          "repsMinimum": 10,
          "repsMaximum": 10,
          "secsBetweenSets": 0,
          "isFavorite": false,
          "lastUpdatedUTC": "2023-02-09T03: 30: 20.1",
          "dateCreatedUTC": "2023-02-09T03: 30: 20.1"
        }
      ],
      "lastUpdatedUTC": "1900-01-01T00: 00: 00",
      "dateCreatedUTC": "2023-02-09T03: 21: 49.023"
    }
  ]
}
*/