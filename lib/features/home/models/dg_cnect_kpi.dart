/// Modello dati che rappresenta una metrica/indicatore DG-CNECT (WP3 - Synch and Async Courses).
class DgCnectKpiItem {
  final int row;
  final String code;
  final String indicator;
  final String category;
  final dynamic value;
  final String format; // 'int', 'percent', 'string'
  final String description;

  const DgCnectKpiItem({
    required this.row,
    required this.code,
    required this.indicator,
    required this.category,
    required this.value,
    this.format = 'int',
    this.description = '',
  });

  String get cellReference => 'F$row';

  String get displayValue {
    if (value is double) {
      if (format == 'percent') {
        return '${(value * 100).toStringAsFixed(1)}%';
      }
      return value.toStringAsFixed(1);
    }
    if (value is int) {
      return value.toString();
    }
    return value?.toString() ?? '-';
  }
}
