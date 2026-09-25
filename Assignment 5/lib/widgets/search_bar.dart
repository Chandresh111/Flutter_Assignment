import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;

      if (_hasText != hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.10),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 19,
            color: colors.onSurfaceVariant,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  tooltip: 'Clear search',
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 17,
                    color: colors.onSurfaceVariant,
                  ),
                )
              : Icon(
                  Icons.tune_rounded,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 13,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}