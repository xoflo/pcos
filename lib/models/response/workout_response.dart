
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

// TODO: change to the actual workout response from API
//Example
/*
{
  "status": "OK",
  "message": "",
  "info": "",
  "payload":
   [
      {
        "recipeId": 22,
        "title": "2 Minute Mayo",
        "description": "",
        "slug": "two-minute-mayo",
        "thumbnail": "images/2_Minute_Mayo.jpg",
        "ingredients": "<ul>\r\n\t<li>2 eggs</li>\r\n\t<li>3 tbsp lemon juice</li>\r\n\t<li>1 tsp Dijon mustard</li>\r\n\t<li>&frac12; tsp salt</li>\r\n\t<li>White pepper</li>\r\n\t<li>300ml avocado oil or olive oil&nbsp;</li>\r\n</ul>",
        "method": "<ol>\r\n\t<li style=\"list-style-type:decimal\">Place all ingredients in a narrow bowl or jug, then blitz with a hand blender until you get a thick and creamy mayo. If you&rsquo;d like a thicker consistency then use an extra 60ml oil or use an extra 60ml hot water for a lighter consistency.&nbsp;</li>\r\n\t<li style=\"list-style-type:decimal\">Store for up to 2 weeks in the refrigerator.</li>\r\n</ol>",
        "tips": "<p>Makes one jar.</p>",
        "difficulty": 0,
        "servings": 1,
        "duration": 120000000,
        "isFavorite":false,
        "lastUpdatedUTC": "2020-11-17T04:14:36.3",
        "dateCreatedUTC": "2020-09-30T21:26:16.477"
      }
  ]
}
*/