import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../models/index.dart';
import '../../utils/index.dart';
import '../widgets/index.dart';

class PgSearchScreen extends StatefulWidget {
  final Function({FilterPgModel? pgDetails})? onTapSave;
  const PgSearchScreen({
    super.key,
    this.onTapSave,
  });

  @override
  State<PgSearchScreen> createState() => _PgSearchScreenState();
}

class _PgSearchScreenState extends State<PgSearchScreen> {
  var selectedPgType = '';
  var selectedRoomType = '';

  TextEditingController textEditingController = TextEditingController();

  FocusNode focusNode = FocusNode();

  List<SuggestionModel?>? suggestionList;

  List<FilterPgModel?>? searchedPGList;

  bool isShowSuggestionList = true;

  SuggestionModel? cachedSuggestion;

  void onApplyFilter({
    required String pgType,
    required String roomType,
  }) async {
    setState(() {
      selectedPgType = pgType;
      selectedRoomType = roomType;
    });

    // setState(() {
    //   searchedPGList?.clear();
    // });

    var tempSearchedPgList = await AppServices().fetchFilterPG(
          city: (cachedSuggestion?.city ?? '').trim(),
          pgName: (cachedSuggestion?.pg_name ?? '').trim(),
          pgCategory: pgType == 'Boys'
              ? 'Boy'
              : pgType == 'Girls'
                  ? 'Girl'
                  : pgType,
          pgType: roomType == 'Double Sharing'
              ? 'Double'
              : roomType == 'Triple Sharing'
                  ? 'Triple'
                  : roomType == 'Quad Sharing'
                      ? 'Quad'
                      : roomType,
        ) ??
        [];

    setState(() {
      searchedPGList = tempSearchedPgList;
    });

    Navigator.of(context).pop();
  }

  void onResetFilter({
    required String pgType,
    required String roomType,
  }) {
    setState(() {
      selectedPgType = '';
      selectedRoomType = '';
    });
  }

  void onSearchPG(String value) async {
    var query = value.trim();
    if (query.length > 1) {
      var tempSuggestionList =
          await AppServices().fetchSuggestion(param: query.toLowerCase());
      setState(() {
        suggestionList = tempSuggestionList;
      });
    }
  }

  void onTapSuggestion({SuggestionModel? suggestion}) async {
    setState(() {
      isShowSuggestionList = false;
      searchedPGList?.clear();
      cachedSuggestion = suggestion;
    });

    var tempSearchedPgList = await AppServices().fetchFilterPG(
          city: (suggestion?.city ?? '').trim(),
          pgName: (suggestion?.pg_name ?? '').trim(),
        ) ??
        [];

    setState(() {
      searchedPGList = tempSearchedPgList;
    });
    textEditingController.text = suggestion != null
        ? '${suggestion.pg_name != null && suggestion.pg_name!.isNotEmpty ? '${suggestion.pg_name}, ' : ''}${suggestion.city ?? ''}, ${suggestion.area ?? ''}'
            .trim()
        : '';
  }

  void onTapSave({FilterPgModel? pgDetails}) {
    if (pgDetails == null) return;
    var tempSearchedPgList =
        List<FilterPgModel>.from(searchedPGList != null ? searchedPGList! : []);
    setState(() {
      searchedPGList = tempSearchedPgList.map((pg) {
        if (pg.pgId == pgDetails.pgId) {
          postSave(
            pgDetails: pgDetails,
          );
          return pg.copyWith(
            isSaved: pgDetails.isSaved != null ? !pgDetails.isSaved! : false,
          );
        }
        return pg;
      }).toList();
    });
    if (widget.onTapSave != null) {
      widget.onTapSave!(
        pgDetails: pgDetails,
      );
    }
  }

  void postSave({FilterPgModel? pgDetails}) async {
    await AppServices().postSave(
      pgId: pgDetails?.pgId,
      isSaved: pgDetails != null && pgDetails.isSaved != null
          ? !pgDetails.isSaved!
          : false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: focusNode,
                        onTapOutside: (event) {
                          focusNode.unfocus();
                        },
                        controller: textEditingController,
                        onChanged: onSearchPG,
                        onTap: () {
                          setState(() {
                            isShowSuggestionList = true;
                          });
                        },
                        cursorColor: Colors.black54,
                        inputFormatters: const [
                          // FilteringTextInputFormatter.allow(
                          //   searchFieldRegex,
                          // ),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              textEditingController.clear();
                              setState(() {
                                isShowSuggestionList = true;
                              });
                              focusNode.requestFocus();
                            },
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                          hintText: 'Search PG',
                          filled: true,
                          fillColor: Colors.black12,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            right: 25,
                          ),
                          // focusedBorder: InputBorder.none,
                          // enabledBorder: InputBorder.none,
                          // errorBorder: InputBorder.none,
                          // disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.width * 0.025,
                    ),
                    GestureDetector(
                      onTap: () {
                        showFilters();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                          8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.15,
                              ),
                              spreadRadius: 0,
                              blurRadius: 2,
                              offset: const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          filter,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.height * 0.01,
                ),
                Expanded(
                  child: isShowSuggestionList
                      ? Expanded(
                          child: SuggestionList(
                            suggestionList: suggestionList,
                            onTapSuggestion: onTapSuggestion,
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Find your perfect PG",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black45,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Row(
                                    children: [
                                      Icon(
                                        LineIcons.mapMarker,
                                        size: 16,
                                      ),
                                      Text(
                                        'Map View',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: context.width * 0.04,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                itemCount: searchedPGList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return PgCard(
                                    height: context.height * 0.25,
                                    pgDetails: searchedPGList != null
                                        ? searchedPGList![index]
                                        : null,
                                    onTapSave: onTapSave,
                                    isSaved: searchedPGList != null &&
                                            searchedPGList![index] != null
                                        ? searchedPGList![index]!.isSaved
                                        : false,
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          pgDetailsRoute,
                                          arguments: {
                                            'pgDetails': searchedPGList != null
                                                ? searchedPGList![index]
                                                : null,
                                            'onTapSave': onTapSave,
                                          });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showFilters() {
    if (isShowSuggestionList) return;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Filters(
          selectedPgType: selectedPgType,
          selectedRoomCategory: selectedRoomType,
          onApplyFilter: onApplyFilter,
          onResetFilter: onResetFilter,
        );
      },
    );
  }
}

class SuggestionList extends StatelessWidget {
  final List<SuggestionModel?>? suggestionList;
  final Function({SuggestionModel? suggestion})? onTapSuggestion;
  const SuggestionList({
    super.key,
    this.suggestionList,
    this.onTapSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestionList == null ||
        (suggestionList != null && suggestionList!.isEmpty)) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Search PG by name, Area, City',
          ),
        ],
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: context.height * 0.015,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      itemCount: suggestionList?.length ?? 0,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            if (onTapSuggestion != null) {
              onTapSuggestion!(
                suggestion: suggestionList![index],
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  suggestionList != null && suggestionList![index] != null
                      ? '${suggestionList![index]?.pg_name != null && suggestionList![index]!.pg_name!.isNotEmpty ? '${suggestionList![index]?.pg_name}, ' : ''}${suggestionList![index]?.city ?? ''}, ${suggestionList![index]?.area ?? ''}'
                          .trim()
                      : '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Icon(
                Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Filters extends StatefulWidget {
  final String selectedPgType;
  final String selectedRoomCategory;
  final Function({required String pgType, required String roomType})
      onApplyFilter;
  final Function({required String pgType, required String roomType})
      onResetFilter;
  const Filters({
    super.key,
    required this.selectedPgType,
    required this.onApplyFilter,
    required this.selectedRoomCategory,
    required this.onResetFilter,
  });

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  var _selectedPGCategory = '';
  var _selectedRoomCategory = '';

  final List<Map<String, dynamic>> _pgTypes = [
    {
      'label': 'Boys',
    },
    {
      'label': 'Girls',
    },
    {
      'label': 'Co-Living',
    },
  ];

  final List<Map<String, dynamic>> _roomsCategories = [
    {
      'label': 'Single',
    },
    {
      'label': 'Double Sharing',
    },
    {
      'label': 'Triple Sharing',
    },
    {
      'label': 'Quad Sharing',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedPGCategory = widget.selectedPgType;
    _selectedRoomCategory = widget.selectedRoomCategory;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: context.height * 0.01,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PG Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(
                          height: context.height * 0.01,
                        ),
                        Wrap(
                          spacing: 10,
                          children: _pgTypes.map((pgType) {
                            return ChoiceChip(
                              label: Text(pgType['label']),
                              selected: _selectedPGCategory == pgType['label'],
                              selectedColor: Colors.blue[100],
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedPGCategory =
                                      selected ? pgType['label'] : '';
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: context.height * 0.02,
                        ),
                        const Text(
                          'Rooms Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(
                          height: context.height * 0.01,
                        ),
                        Wrap(
                          spacing: 10,
                          children: _roomsCategories.map(
                            (roomType) {
                              return ChoiceChip(
                                label: Text(roomType['label']),
                                avatar:
                                    _selectedRoomCategory == roomType['label']
                                        ? null
                                        : Text(
                                            '${_roomsCategories.indexOf(roomType) + 1}',
                                          ),
                                selected:
                                    _selectedRoomCategory == roomType['label'],
                                selectedColor: Colors.blue[100],
                                onSelected: (bool selected) {
                                  setState(() {
                                    _selectedRoomCategory =
                                        selected ? roomType['label'] : '';
                                  });
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      overlayColor: Colors.black,
                      surfaceTintColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      _selectedPGCategory = '';
                      _selectedRoomCategory = '';
                      setState(() {});
                      widget.onResetFilter(
                        pgType: _selectedPGCategory,
                        roomType: _selectedRoomCategory,
                      );
                    },
                    child: const Text(
                      'RESET',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      overlayColor: Colors.black,
                      surfaceTintColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      widget.onApplyFilter(
                        pgType: _selectedPGCategory,
                        roomType: _selectedRoomCategory,
                      );
                    },
                    child: const Text(
                      'APPLY',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
