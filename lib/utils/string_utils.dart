class StringUtils {
  static String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }

  static List<String> getTagValues(final stringContext, final String type) {
    if (type == "knowledgebase") {
      return <String>[
        stringContext.tagAll,
        stringContext.kbTagDiet,
        stringContext.kbTagEnergy,
        stringContext.kbTagExercise,
        stringContext.kbTagFertility,
        stringContext.kbTagHair,
        stringContext.kbTagInsulin,
        stringContext.kbTagSkin,
        stringContext.kbTagStress,
        stringContext.kbTagThyroid
      ];
    } else if (type == "recipes") {}
    return <String>[];
  }
}
