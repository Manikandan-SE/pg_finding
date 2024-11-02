import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/index.dart';
import '../widgets/index.dart';

class PgSearchScreen extends StatefulWidget {
  const PgSearchScreen({super.key});

  @override
  State<PgSearchScreen> createState() => _PgSearchScreenState();
}

class _PgSearchScreenState extends State<PgSearchScreen> {
  var selectedPgType = '';
  var selectedRoomType = '';

  void onApplyFilter({
    required String pgType,
    required String roomType,
  }) {
    setState(() {
      selectedPgType = pgType;
      selectedRoomType = roomType;
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
                        onChanged: (value) {},
                        cursorColor: Colors.black54,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            searchFieldRegex,
                          ),
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
                          suffixIcon: const Icon(
                            Icons.close,
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
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    children: [
                      PgCard(
                        height: context.height * 0.25,
                      ),
                      SizedBox(
                        height: context.width * 0.04,
                      ),
                      PgCard(
                        height: context.height * 0.25,
                      ),
                      SizedBox(
                        height: context.width * 0.04,
                      ),
                      PgCard(
                        height: context.height * 0.25,
                      ),
                      SizedBox(
                        height: context.width * 0.04,
                      ),
                      PgCard(
                        height: context.height * 0.25,
                      ),
                      SizedBox(
                        height: context.width * 0.04,
                      ),
                      PgCard(
                        height: context.height * 0.25,
                      ),
                      SizedBox(
                        height: context.width * 0.04,
                      ),
                      PgCard(
                        height: context.height * 0.25,
                      ),
                    ],
                  ),
                ),

                // const Expanded(
                //   child: SuggestionList(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showFilters() {
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
  const SuggestionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      children: [
        Container(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Velachery,Chennai'),
              Icon(
                Icons.arrow_forward,
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.height * 0.015,
        ),
        Container(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vimala PG,Velachery,Chennai'),
              Icon(
                Icons.arrow_forward,
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.height * 0.015,
        ),
        Container(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bubu PG,Velachery,Chennai'),
              Icon(
                Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ],
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
