import 'package:flutter/material.dart';
import '../util/multi_select_list_type.dart';
import '../chip_display/multi_select_chip_display.dart';
import '../util/multi_select_item.dart';
import 'multi_select_bottom_sheet.dart';

/// A customizable InkWell widget that opens the MultiSelectBottomSheet
// ignore: must_be_immutable
class MultiSelectBottomSheetField<V> extends StatefulWidget {
  /// Style the Container that makes up the field.
  final BoxDecoration decoration;

  /// Set text that is displayed on the button.
  final Text buttonText;

  /// Specify the button icon.
  final Icon buttonIcon;

  /// List of items to select from.
  final List<MultiSelectItem<V>> items;

  /// The list of selected values before interaction.
  final List<V> initialValue;

  /// The text at the top of the dialog.
  final Text title;

  /// Fires when the an item is selected / unselected.
  final void Function(List<V>) onSelectionChanged;

  /// Fires when confirm is tapped.
  final void Function(List<V>) onConfirm;

  /// Toggles search functionality.
  final bool searchable;

  /// Text on the confirm button.
  final Text confirmText;

  /// Text on the cancel button.
  final Text cancelText;

  /// An enum that determines which type of list to render.
  final MultiSelectListType listType;

  /// Sets the color of the checkbox or chip when it's selected.
  final Color selectedColor;

  /// Set the placeholder text of the search field.
  final String searchPlaceholder;

  /// Set the initial height of the BottomSheet.
  final double initialChildSize;

  /// Set the minimum height threshold of the BottomSheet before it closes.
  final double minChildSize;

  /// Set the maximum height of the BottomSheet.
  final double maxChildSize;

  /// Apply a ShapeBorder to alter the edges of the BottomSheet.
  final ShapeBorder shape;

  /// Set the color of the space outside the BottomSheet.
  final Color barrierColor;

  /// Attach a MultiSelectChipDisplay to this field.
  final MultiSelectChipDisplay chipDisplay;

  /// A function that sets the color of selected items based on their value.
  /// It will either set the chip color, or the checkbox color depending on the list type.
  final Color Function(V) colorator;

  /// This FormFieldState is set when using a MultiSelectBottomSheetFormField.
  FormFieldState<List<V>> state;

  MultiSelectBottomSheetField({
    @required this.items,
    this.title,
    this.buttonText,
    this.buttonIcon,
    this.listType,
    this.decoration,
    this.onSelectionChanged,
    this.onConfirm,
    this.chipDisplay,
    this.initialValue,
    this.searchable,
    this.confirmText,
    this.cancelText,
    this.selectedColor,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.shape,
    this.barrierColor,
    this.searchPlaceholder,
    this.colorator,
  });

  /// This constructor allows a FormFieldState to be passed in. Called by MultiSelectBottomSheetFormField.
  MultiSelectBottomSheetField.withState(
      MultiSelectBottomSheetField field, FormFieldState<List<V>> state)
      : items = field.items,
        title = field.title,
        buttonText = field.buttonText,
        buttonIcon = field.buttonIcon,
        listType = field.listType,
        decoration = field.decoration,
        onSelectionChanged = field.onSelectionChanged,
        onConfirm = field.onConfirm,
        chipDisplay = field.chipDisplay,
        initialValue = field.initialValue,
        searchable = field.searchable,
        confirmText = field.confirmText,
        cancelText = field.cancelText,
        selectedColor = field.selectedColor,
        initialChildSize = field.initialChildSize,
        minChildSize = field.minChildSize,
        maxChildSize = field.maxChildSize,
        shape = field.shape,
        barrierColor = field.barrierColor,
        searchPlaceholder = field.searchPlaceholder,
        colorator = field.colorator,
        state = state;

  @override
  _MultiSelectBottomSheetFieldState createState() =>
      _MultiSelectBottomSheetFieldState<V>();
}

class _MultiSelectBottomSheetFieldState<V>
    extends State<MultiSelectBottomSheetField<V>> {
  List<V> _selectedItems = List<V>();

  /// Calls showModalBottomSheet() and renders a MultiSelectBottomSheet.
  _showBottomSheet(BuildContext ctx) async {
    await showModalBottomSheet(
        barrierColor: widget.barrierColor,
        shape: widget.shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return MultiSelectBottomSheet(
            colorator: widget.colorator,
            searchPlaceholder: widget.searchPlaceholder,
            selectedColor: widget.selectedColor,
            listType: widget.listType,
            items: widget.items,
            cancelText: widget.cancelText,
            confirmText: widget.confirmText,
            initialValue: widget.initialValue ?? _selectedItems,
            onConfirm: (selected) {
              if (widget.state != null) {
                widget.state.didChange(selected);
              }
              _selectedItems = selected;
              widget.onConfirm(selected);
            },
            onSelectionChanged: widget.onSelectionChanged,
            searchable: widget.searchable,
            title: widget.title,
            initialChildSize: widget.initialChildSize,
            minChildSize: widget.minChildSize,
            maxChildSize: widget.maxChildSize,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _showBottomSheet(context);
          },
          child: Container(
            decoration: widget.state != null
                ? widget.decoration ??
                    BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: widget.state != null && widget.state.hasError
                              ? Colors.red.shade800.withOpacity(0.6)
                              : _selectedItems.isNotEmpty
                                  ? widget.selectedColor ??
                                      Theme.of(context).primaryColor
                                  : Colors.black45,
                          width: _selectedItems.isNotEmpty
                              ? (widget.state != null && widget.state.hasError)
                                  ? 1.4
                                  : 1.8
                              : 1.2,
                        ),
                      ),
                    )
                : widget.decoration,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                widget.buttonText ?? Text("Select"),
                widget.buttonIcon ?? Icon(Icons.arrow_downward),
              ],
            ),
          ),
        ),
        widget.chipDisplay != null &&
                (widget.chipDisplay.items != null &&
                    widget.chipDisplay.items.length > 0)
            ? widget.chipDisplay
            : Container(),
        widget.state != null && widget.state.hasError
            ? SizedBox(height: 5)
            : Container(),
        widget.state != null && widget.state.hasError
            ? Row(
                children: <Widget>[
                  Text(
                    widget.state.errorText,
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 12.5,
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
