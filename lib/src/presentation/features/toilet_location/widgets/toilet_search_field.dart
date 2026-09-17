part of '../view/toilet_location_page.dart';

/// Client-side name filter — the API doesn't expose a search query param,
/// so this only narrows whatever page is already loaded.
class _ToiletSearchField extends StatelessWidget {
  const _ToiletSearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField.search(
      controller: controller,
      hint: context.locale.findToiletLocationHint,
      onChanged: onChanged,
    );
  }
}
