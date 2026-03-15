class ForeignKey {
  final String column;
  final String referenceTable;
  final String referenceColumn;
  final String onDelete;
  final String onUpdate;

  const ForeignKey({
    required this.column,
    required this.referenceTable,
    required this.referenceColumn,
    this.onDelete = 'NO ACTION',
    this.onUpdate = 'NO ACTION',
  });

  String toSql() {
    return 'FOREIGN KEY ($column) REFERENCES $referenceTable ($referenceColumn) ON DELETE $onDelete ON UPDATE $onUpdate';
  }
}
