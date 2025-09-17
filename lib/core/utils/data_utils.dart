import 'package:intl/intl.dart';

class DataUtils {
  static DateTime formatarData(String dataFormatadaBr) {
    // Define o formato da data de entrada (dd/MM/yyyy)
    final format = DateFormat('dd/MM/yyyy');

    // Analisa a string para um objeto DateTime
    final dataParse = format.parse(dataFormatadaBr);

    return DateTime(dataParse.year, dataParse.month, dataParse.day);
  }
}
