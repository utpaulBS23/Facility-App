import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../core/utiliity/validation/validation.dart';
import '../gen/assets.gen.dart';
import '../theme/theme.dart';

enum _FieldType { email, password, text, description, search }

/// General-purpose themed text field for the app.
///
/// Each named constructor maps to one of the four input patterns from the
/// design system. All visual state (border color, floating label, error text)
/// is handled internally — callers only configure content and validation.
///
/// | Constructor              | Icon    | Validators built-in          | Visual        |
/// |--------------------------|---------|------------------------------|---------------|
/// | [AppTextField.email]     | email   | Required + Email format      | 56 px input   |
/// | [AppTextField.password]  | lock    | Required + Password rules    | 56 px input   |
/// | [AppTextField.text]      | custom  | none (use extraValidations)  | 56 px input   |
/// | [AppTextField.description] | none  | none (use extraValidations)  | 96 px area    |
/// | [AppTextField.search]    | search  | none                         | 36 px pill    |
///
/// Adding a new [_FieldType] value forces every switch expression in this file
/// to be updated — the compiler will flag unhandled cases.
class AppTextField extends StatefulWidget {
  /// Email / user-ID input.
  /// Built-in: [RequiredValidation] → [EmailValidation].
  /// Default icon is the app email icon; pass [prefixIcon] to override.
  const AppTextField.email({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.extraValidations = const [],
    this.autovalidateMode,
  }) : _type = _FieldType.email,
       _minLength = 0,
       _requireNumber = false,
       _requireLowerCase = false,
       _requireUpperCase = false,
       _requireSpecialChar = false;

  /// Obscured password input with visibility toggle.
  /// Built-in: [RequiredValidation] → [PasswordValidation].
  /// Complexity rules default to length-only; opt in to stricter checks.
  const AppTextField.password({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.enabled = true,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.extraValidations = const [],
    this.autovalidateMode,
    int minLength = 6,
    bool requireNumber = false,
    bool requireLowerCase = false,
    bool requireUpperCase = false,
    bool requireSpecialChar = false,
  }) : _type = _FieldType.password,
       prefixIcon = null,
       _minLength = minLength,
       _requireNumber = requireNumber,
       _requireLowerCase = requireLowerCase,
       _requireUpperCase = requireUpperCase,
       _requireSpecialChar = requireSpecialChar;

  /// Plain single-line input (address, name, etc.).
  /// No built-in validators — add via [extraValidations].
  const AppTextField.text({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.extraValidations = const [],
    this.autovalidateMode,
  }) : _type = _FieldType.text,
       _minLength = 0,
       _requireNumber = false,
       _requireLowerCase = false,
       _requireUpperCase = false,
       _requireSpecialChar = false;

  /// Multiline text area (notes, remarks, description).
  /// No built-in validators — add via [extraValidations].
  const AppTextField.description({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.enabled = true,
    this.errorText,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.extraValidations = const [],
    this.autovalidateMode,
  }) : _type = _FieldType.description,
       prefixIcon = null,
       _minLength = 0,
       _requireNumber = false,
       _requireLowerCase = false,
       _requireUpperCase = false,
       _requireSpecialChar = false;

  /// Pill-style search bar. Not wired into [Form] validation.
  const AppTextField.search({
    super.key,
    required this.controller,
    this.hint,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
  }) : _type = _FieldType.search,
       prefixIcon = null,
       label = null,
       errorText = null,
       textInputAction = TextInputAction.search,
       extraValidations = const [],
       autovalidateMode = null,
       _minLength = 0,
       _requireNumber = false,
       _requireLowerCase = false,
       _requireUpperCase = false,
       _requireSpecialChar = false;

  final _FieldType _type;
  final TextEditingController controller;
  final String? label;
  final String? hint;

  /// Leading icon.
  /// - [AppTextField.email]: defaults to app email icon; pass to override.
  /// - [AppTextField.text]: optional; null = no icon.
  /// - [AppTextField.password] / [AppTextField.description] / [AppTextField.search]: ignored.
  final Widget? prefixIcon;
  final bool enabled;
  final String? errorText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  /// Additional validators appended after the built-in defaults.
  final List<Validation<String>> extraValidations;
  final AutovalidateMode? autovalidateMode;

  // Password-specific config — zero/false for all other types.
  final int _minLength;
  final bool _requireNumber;
  final bool _requireLowerCase;
  final bool _requireUpperCase;
  final bool _requireSpecialChar;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  String _currentText = '';
  String? _validationError;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _currentText = widget.controller.text;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  void _onFocusChange() => setState(() => _hasFocus = _focusNode.hasFocus);

  void _onTextChange() => setState(() => _currentText = widget.controller.text);

  void _toggleVisibility() => setState(() => _obscureText = !_obscureText);

  // WHY: Switch expression so the compiler enforces a case for every _FieldType.
  List<Validation<String>> get _defaultValidations => switch (widget._type) {
    _FieldType.email => [RequiredValidation(), EmailValidation()],
    _FieldType.password => [
      RequiredValidation(),
      PasswordValidation(
        minLength: widget._minLength,
        number: widget._requireNumber,
        lowerCase: widget._requireLowerCase,
        upperCase: widget._requireUpperCase,
        specialChar: widget._requireSpecialChar,
      ),
    ],
    _FieldType.text || _FieldType.description || _FieldType.search => const [],
  };

  bool get _hasValidators => switch (widget._type) {
    _FieldType.email || _FieldType.password => true,
    _FieldType.text ||
    _FieldType.description => widget.extraValidations.isNotEmpty,
    _FieldType.search => false,
  };

  // WHY: Validator runs inside the build/validate phase, so setState must be
  // deferred to the next frame via addPostFrameCallback.
  String? _onValidate(String? value) {
    String? error;
    for (final v in [..._defaultValidations, ...widget.extraValidations]) {
      error = v.validate(context, value);
      if (error != null) break;
    }
    if (_validationError != error) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _validationError = error);
      });
    }
    return error;
  }

  Color _borderColor(ColorExtension colors, {required bool hasError}) {
    if (!widget.enabled) return colors.inactive;
    if (hasError) return colors.error;
    if (_hasFocus) return colors.borderBrandFocus;
    return colors.border;
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  // WHY: Top-level switch routes each type to its own visual layout.
  // Adding a new _FieldType without a case here is a compile error.
  @override
  Widget build(BuildContext context) => switch (widget._type) {
    _FieldType.search => _buildSearch(context),
    _FieldType.description => _buildDescription(context),
    _FieldType.email ||
    _FieldType.password ||
    _FieldType.text => _buildInput(context),
  };

  // ─── Shared helpers ────────────────────────────────────────────────────────

  Widget? _prefixIcon(ColorExtension colors, Dimensions d) {
    // WHY: SizedBox pins the SVG to exactly s20×s20 so the InputDecoration's
    // default 48-px-min slot doesn't let it expand and appear oversized.
    Widget svgIcon(SvgGenImage asset) => SizedBox(
      width: d.spacing.s20,
      height: d.spacing.s20,
      child: asset.svg(
        colorFilter: ColorFilter.mode(colors.icon, BlendMode.srcIn),
        fit: BoxFit.contain,
      ),
    );

    return switch (widget._type) {
      _FieldType.email => widget.prefixIcon ?? svgIcon(Assets.icons.email),
      _FieldType.password => svgIcon(Assets.icons.password),
      _FieldType.text => widget.prefixIcon,
      _FieldType.description || _FieldType.search => null,
    };
  }

  Widget? _suffixIcon(Dimensions d) => switch (widget._type) {
    _FieldType.password => IconButton(
      iconSize: d.spacing.s20,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: widget.enabled ? _toggleVisibility : null,
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
      ),
    ),
    _FieldType.email ||
    _FieldType.text ||
    _FieldType.description ||
    _FieldType.search => null,
  };

  InputDecoration get _bareDecoration => InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    // WHY: Suppresses Material's built-in error slot; we render our own
    // error text below the container so it aligns with the custom border.
    errorStyle: const TextStyle(height: 0, fontSize: 0),
    isDense: true,
    contentPadding: EdgeInsets.zero,
    filled: false,
  );

  // ─── Input (email / password / text) ───────────────────────────────────────

  Widget _buildInput(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    final showLabel =
        (_currentText.isNotEmpty || _hasFocus) && widget.label != null;
    final effectiveError = _validationError ?? widget.errorText;
    final hasError = effectiveError != null;

    final leading = _prefixIcon(colors, dimensions);
    final trailing = _suffixIcon(dimensions);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: dimensions.spacing.s56,
          padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.s16),
          decoration: BoxDecoration(
            color: widget.enabled ? colors.onPrimary : colors.subtle,
            borderRadius: BorderRadius.circular(dimensions.radius.r12),
            border: Border.all(
              color: _borderColor(colors, hasError: hasError),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading,
                SizedBox(width: dimensions.spacing.s6),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLabel)
                      Text(
                        widget.label!,
                        style: textStyle.bodySmall.copyWith(
                          color: colors.text.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      obscureText:
                          widget._type == _FieldType.password && _obscureText,
                      keyboardType: switch (widget._type) {
                        _FieldType.email => TextInputType.emailAddress,
                        _FieldType.password ||
                        _FieldType.text => TextInputType.text,
                        _ => TextInputType.text,
                      },
                      textInputAction: widget.textInputAction,
                      onChanged: widget.onChanged,
                      onFieldSubmitted: widget.onSubmitted,
                      autofillHints: switch (widget._type) {
                        _FieldType.email => const [AutofillHints.email],
                        _FieldType.password => const [AutofillHints.password],
                        _FieldType.text => null,
                        _ => null,
                      },
                      autocorrect: false,
                      validator: _hasValidators ? _onValidate : null,
                      autovalidateMode: widget.autovalidateMode,
                      style: textStyle.labelLarge.copyWith(
                        color: widget.enabled
                            ? colors.text.primary
                            : colors.text.disabled,
                      ),
                      decoration: _bareDecoration.copyWith(
                        hintText: showLabel ? null : widget.hint,
                        hintStyle: textStyle.labelLarge.copyWith(
                          color: colors.text.muted,
                        ),
                      ),
                      cursorColor: colors.primary,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: dimensions.spacing.s6),
                trailing,
              ],
            ],
          ),
        ),
        if (effectiveError != null)
          Padding(
            padding: EdgeInsets.only(
              top: dimensions.spacing.s4,
              left: dimensions.spacing.s4,
            ),
            child: Text(
              effectiveError,
              style: textStyle.bodySmall.copyWith(color: colors.error),
            ),
          ),
      ],
    );
  }

  // ─── Description (multiline) ────────────────────────────────────────────────

  Widget _buildDescription(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    final effectiveError = _validationError ?? widget.errorText;
    final hasError = effectiveError != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          // WHY: Fixed 96px height from design spec — fits label + ~3 text lines.
          height: dimensions.spacing.s96,
          padding: EdgeInsets.all(dimensions.spacing.s16),
          decoration: BoxDecoration(
            color: widget.enabled ? colors.onPrimary : colors.subtle,
            borderRadius: BorderRadius.circular(dimensions.radius.r12),
            border: Border.all(
              color: _borderColor(colors, hasError: hasError),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // WHY: Label is always visible for description (not floating)
              // so users know what the area is for before they start typing.
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: textStyle.bodySmall.copyWith(
                    color: colors.text.secondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  autocorrect: false,
                  validator: _hasValidators ? _onValidate : null,
                  autovalidateMode: widget.autovalidateMode,
                  style: textStyle.labelLarge.copyWith(
                    color: widget.enabled
                        ? colors.text.primary
                        : colors.text.disabled,
                  ),
                  decoration: _bareDecoration.copyWith(
                    hintText: widget.hint,
                    hintStyle: textStyle.labelLarge.copyWith(
                      color: colors.text.muted,
                    ),
                  ),
                  cursorColor: colors.primary,
                ),
              ),
            ],
          ),
        ),
        if (effectiveError != null)
          Padding(
            padding: EdgeInsets.only(
              top: dimensions.spacing.s4,
              left: dimensions.spacing.s4,
            ),
            child: Text(
              effectiveError,
              style: textStyle.bodySmall.copyWith(color: colors.error),
            ),
          ),
      ],
    );
  }

  // ─── Search ────────────────────────────────────────────────────────────────

  Widget _buildSearch(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    return Container(
      height: dimensions.spacing.s36,
      padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.s8),
      decoration: BoxDecoration(
        color: colors.subtle,
        borderRadius: BorderRadius.circular(dimensions.radius.r10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: dimensions.spacing.s20,
            height: dimensions.spacing.s20,
            child: Assets.icons.search.svg(
              colorFilter: ColorFilter.mode(colors.icon, BlendMode.srcIn),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: dimensions.spacing.s8),
          Expanded(
            // WHY: Plain TextField (not TextFormField) — search is not part
            // of any Form and requires no validation.
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              keyboardType: TextInputType.text,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              autocorrect: false,
              style: textStyle.bodyLarge.copyWith(
                color: widget.enabled
                    ? colors.text.primary
                    : colors.text.disabled,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: textStyle.bodyLarge.copyWith(
                  color: colors.text.muted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: false,
              ),
              cursorColor: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
