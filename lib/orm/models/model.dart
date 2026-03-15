import '../schema/table_schema.dart';

abstract class Model {
  TableSchema get instanceTableSchema;
  Map<String, dynamic> toMap();
}
