import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'workout_filter_sheet.dart';
import '../../../constants/shared_preferences_keys.dart'
    as SharedPreferencesKeys;
import '../../../constants/analytics.dart' as Analytics;
import '../../../providers/workouts_provider.dart';
import '../../../controllers/preferences_controller.dart';
import '../../../styles/colors.dart';
import '../../../utils/dialog_utils.dart';
import '../../../widgets/shared/image_view_item.dart';
import '../../../widgets/shared/loader_overlay_with_change_notifier.dart';
import '../../../generated/l10n.dart';
import '../../../services/firebase_analytics.dart';
import '../../../widgets/shared/search_component.dart';

class WorkoutsLayout extends StatefulWidget {
  @override
  _WorkoutsLayoutState createState() => _WorkoutsLayoutState();
}

class _WorkoutsLayoutState extends State<WorkoutsLayout> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  bool isInitialized = false;

  bool _isSearching = false;
  String _difficultyTag = "All";
  List<String> _workoutTypeTags = [];

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
  }

  void _initializeFilterTags(WorkoutsProvider workoutsProvider) async {
    if (await PreferencesController()
        .getBool(SharedPreferencesKeys.WORKOUT_DEFAULT_FILTER)) {
      final difficultyLevels = await PreferencesController()
          .getString(SharedPreferencesKeys.WORKOUT_DIFFICULTY_FILTER);
      final workoutTypes = await PreferencesController()
          .getStringList(SharedPreferencesKeys.WORKOUT_TYPE_FILTER);

      _difficultyTag = difficultyLevels;
      _workoutTypeTags = workoutTypes;
    } else {
      _difficultyTag = "All";
      _workoutTypeTags = [];
    }

    _onSearchClicked(workoutsProvider);
  }

  void _onFocusChanged() {
    setState(() => _isSearching = _focusNode.hasFocus);
  }

  void _onSearchClicked(WorkoutsProvider workoutsProvider) async {
    analytics.logEvent(
      name: Analytics.ANALYTICS_EVENT_SEARCH,
      parameters: {
        Analytics.ANALYTICS_PARAMETER_SEARCH_TYPE:
            Analytics.ANALYTICS_SEARCH_WORKOUT
      },
    );

    workoutsProvider.filterAndSearch(
        _searchController.text.trim(), _difficultyTag, _workoutTypeTags);
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final workoutsProvider = Provider.of<WorkoutsProvider>(context);
    if (!isInitialized) {
      isInitialized = true;
      _initializeFilterTags(workoutsProvider);
    }

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Column(
        children: [
          SearchComponent(
            searchController: _searchController,
            focusNode: _focusNode,
            searchBackgroundColor: primaryColor,
            onSearchPressed: () => _onSearchClicked(workoutsProvider),
          ),
          if (_isSearching && _searchController.text.trim().isEmpty)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                alignment: Alignment.center,
                child: Text(
                  "Search workout exercises.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else ...[
            GestureDetector(
              onTap: () => openBottomSheet(
                context,
                WorkoutFilterSheet(
                  currentPrimaryCriteria: _difficultyTag,
                  currentSecondaryCriteria: _workoutTypeTags,
                  onSearchPressed: (meal, diet) {
                    setState(() {
                      _difficultyTag = meal;
                      _workoutTypeTags = diet ?? [];
                    });

                    _onSearchClicked(workoutsProvider);
                  },
                ),
                Analytics.ANALYTICS_WORKOUT_FILTER,
                null,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: backgroundColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Filters",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: backgroundColor),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: LoaderOverlay(
                height: double.maxFinite,
                indicatorPosition: Alignment.topCenter,
                loadingStatusNotifier: workoutsProvider,
                emptyMessage: S.current.noResultsRecipes,
                overlayBackgroundColor: Colors.transparent,
                child: GridView.count(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(15),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: workoutsProvider.items
                      .map(
                        (workout) => ImageViewItem(
                          thumbnail: workout.thumbnail,
                          onViewPressed: () {
                            
                          },
                          title: workout.title,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
