import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wellnest/core/errors/excpetions.dart';
import 'package:wellnest/feature/data_backup_restore/data/models/data_model.dart';
import 'package:wellnest/main.dart';

abstract class DataRemoteDatasource {
  Future<DataModel> getData();
  Future<void> updateData(DataModel dataModel);
}

class DataRemoteDatasourceImpl implements DataRemoteDatasource {
  @override
  Future<DataModel> getData() async {
    final userId = supabase.auth.currentUser!.id;
    try {
      final result =
          await supabase.from('data').select().eq('user_id', userId).single();
      return DataModel.fromMap(result);
    } on PostgrestException catch (e) {
      log('getData PExc $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('getData $e');
      throw ServerException(message: 'Server Error $e');
    }
  }

  @override
  Future<void> updateData(DataModel dataModel) async {
    final userId = supabase.auth.currentUser!.id;
    try {
      await supabase
          .from('data')
          .update(dataModel.toMap())
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      log('updateData PExc $e');
      throw ServerException(message: e.message);
    } catch (e) {
      log('updateData $e');
      throw ServerException(message: 'Server Error $e');
    }
  }
}
