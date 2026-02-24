import 'package:flutter/material.dart';

class BookingSearchBar extends StatefulWidget {
  const BookingSearchBar({super.key});

  @override
  State<BookingSearchBar> createState() => _BookingSearchBarState();
}

class _BookingSearchBarState extends State<BookingSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'ค้นหาลานจอดรถ',
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
