import 'package:hypester/data/datasource/report_firabase_datasource.dart';

class ReportRepository {
 final ReportFirebaseDatasource _reportFirebaseDatasource;

 ReportRepository(this._reportFirebaseDatasource);

 Future<void> saveReport(DateTime dateTime, String source, String url, String postId, String selectedOption) async {
   await _reportFirebaseDatasource.saveReport(dateTime, source, url, postId, selectedOption);
 }
}