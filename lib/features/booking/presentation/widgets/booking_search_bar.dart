import 'package:flutter/material.dart';

class BookingSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  const BookingSearchBar({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<BookingSearchBar> createState() => _BookingSearchBarState();
}

class _BookingSearchBarState extends State<BookingSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.onSearchChanged(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'ค้นหาลานจอดรถ',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
