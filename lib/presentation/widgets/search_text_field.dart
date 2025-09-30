import 'dart:async';
import 'package:digitopia_app/constants/app_constants.dart';
import 'package:digitopia_app/utils/debouncer.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    required this.onChanged,
    this.controller,
    this.hintText = 'ابحث عن وجبات قريبة منك...',
    this.debounceTime = const Duration(milliseconds: 300),
  });

  final Function(String) onChanged;
  final TextEditingController? controller;
  final String hintText;
  final Duration debounceTime;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late Debouncer _debouncer;
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _debouncer = Debouncer(milliseconds: widget.debounceTime.inMilliseconds);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });

    _debouncer.run(() {
      widget.onChanged(value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isSearching = false;
    });
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: const BorderSide(color: AppConstants.primaryColor),
          ),
        ),
      ),
    );
  }
}