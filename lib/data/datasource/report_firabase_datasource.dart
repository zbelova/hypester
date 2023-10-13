import 'package:cloud_firestore/cloud_firestore.dart';

class ReportFirebaseDatasource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> saveReport(DateTime dateTime, String source, String url, String postId) async {
    DocumentReference reportReference = firestore.collection('reports').doc();
    await reportReference.set({
      'id': reportReference.id,
      'dateTime': dateTime,
      'source': source,
      'url': url,
      'postId': postId,
    });
  }
}