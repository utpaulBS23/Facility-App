import 'package:dio/dio.dart';

import '../../domain/entities/additional_income/additional_income_entity.dart';
import '../../domain/entities/additional_income/additional_income_payloads.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../models/additional_income/additional_income_model.dart';
import 'multipart_photo.dart';

extension AdditionalIncomeModelMapper on AdditionalIncomeModel {
  AdditionalIncomeEntity toEntity() {
    return AdditionalIncomeEntity(
      id: id,
      facilityName: facility?.name ?? '',
      facilityNameBn: facility?.nameBn ?? '',
      incomeTypeName: incomeType ?? '',
      amount: amount ?? 0,
      description: description,
      evidencePhotoUrl: evidencePhotoUrl,
      isSelfApproved: isSelfApproved ?? false,
      submittedByName: submittedBy?.name ?? '',
      submittedByNameBn: submittedBy?.nameBn ?? '',
      createdAt: DateTime.tryParse(createdAt ?? '') ?? DateTime.now(),
    );
  }
}

extension AdditionalIncomeSummaryModelMapper on AdditionalIncomeSummaryModel {
  AdditionalIncomeSummaryEntity toEntity() {
    return AdditionalIncomeSummaryEntity(
      approvedTotal: approvedTotal ?? 0,
      pendingCount: pendingCount ?? 0,
      totalSubmissions: totalSubmissions ?? 0,
    );
  }
}

extension AdditionalIncomeListResponseModelToEntity
    on AdditionalIncomeListResponseModel {
  AdditionalIncomeListResultEntity toEntity() {
    final items = (data ?? const []).map((model) => model.toEntity()).toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? items.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return AdditionalIncomeListResultEntity(
      list: PaginatedListEntity<AdditionalIncomeEntity>(
        items: items,
        currentPage: curPage,
        pageSize: size,
        totalRecords: total,
        hasMore: hasMore,
      ),
      summary: (summary ?? const AdditionalIncomeSummaryModel()).toEntity(),
    );
  }
}

extension CreateAdditionalIncomeRequestEntityMapper
    on CreateAdditionalIncomeRequestEntity {
  /// Multipart body: the server takes the evidence photo as a file, under the
  /// (misleadingly named) `evidence_photo_url` field.
  Future<FormData> toFormData() async {
    final formData = FormData()
      ..fields.addAll([
        MapEntry('facility_id', '$facilityId'),
        MapEntry('income_type', incomeType),
        MapEntry('amount', '$amount'),
      ]);
    final text = description;
    if (text != null && text.isNotEmpty) {
      formData.fields.add(MapEntry('description', text));
    }
    final photo = evidencePhotoPath;
    if (photo != null && photo.isNotEmpty) {
      formData.files.add(
        MapEntry('evidence_photo_url', await photoPart(photo)),
      );
    }

    return formData;
  }
}
