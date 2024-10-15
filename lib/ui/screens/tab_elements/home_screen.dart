import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pg_finding/utils/index.dart';

class HomeScreen extends StatelessWidget {
  final String currentAddress;
  const HomeScreen({super.key, required this.currentAddress});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 16,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            SizedBox(
              height: context.height * 0.02,
            ),
            const Banner(),
            SizedBox(
              height: context.height * 0.025,
            ),
            SearchField(
              currentAddress: currentAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  letterSpacing: 1.5,
                  fontSize: 16, //22
                ),
              ),
              const Text(
                'Manikandan',
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 1.5,
                  fontSize: 23, //30
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: context.width * 0.2,
              child: Image.asset(
                profileAvator,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(
            8,
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's Explore the",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      letterSpacing: 1.5,
                      fontSize: 22,
                    ),
                  ),
                  const Text(
                    'Perfect PG',
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.5,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: -6,
              child: SizedBox(
                width: context.width * 0.38,
                child: Image.asset(
                  explorePG,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final String currentAddress;
  const SearchField({super.key, required this.currentAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  cursorColor: Colors.black54,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      searchFieldRegex,
                    ),
                  ],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      LineIcons.search,
                    ),
                    hintText: 'Search PG',
                    filled: true,
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
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
              Container(
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
            ],
          ),
          if (currentAddress.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    LineIcons.mapMarker,
                    size: 18,
                  ),
                  Text(
                    'Current Location: ',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    currentAddress,
                    style: const TextStyle(
                      fontSize: 14,
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
