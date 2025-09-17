import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class MonthYearPickerFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(DateTime)? onDateSelected;

  const MonthYearPickerFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.onDateSelected,
  });

  @override
  State<MonthYearPickerFormField> createState() =>
      _MonthYearPickerFormFieldState();
}

class _MonthYearPickerFormFieldState extends State<MonthYearPickerFormField> {
  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime initialDate = DateTime.now();

    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione o Mês e o Ano'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: dp.MonthPicker.single(
              selectedDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onChanged: (DateTime newDate) {
                Navigator.pop(context, newDate);
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Formata a data para "MM/yyyy"
        widget.controller.text = DateFormat('MM/yyyy').format(picked);

        // Chama o callback com a data selecionada
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.calendar_month),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selectMonthYear(context),
    );
  }
}
