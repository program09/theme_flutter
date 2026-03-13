import '../schema/table_schema.dart';

abstract class Model {
  TableSchema get tableSchema;
  Map<String, dynamic> toMap();
}
