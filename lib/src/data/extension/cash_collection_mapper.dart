import 'package:dio/dio.dart';

import '../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../domain/entities/cash_collection/cash_collection_payloads.dart';
import '../../domain/entities/common/paginated_list_entity.dart';
import '../models/cash_collection/cash_collection_model.dart';
import 'multipart_photo.dart';

extension CashCollectionItemModelToEntity on CashCollectionItemModel {
  CashCollectionItemEntity toEntity() {
    return CashCollectionItemEntity(
      id: id ?? 0,
      serviceName: facilityService?.serviceName ?? '',
      section: facilityService?.section,
      gender: gender ?? '',
      quantity: quantity ?? 0,
      unitPrice: unitPrice ?? 0,
      amount: amount ?? 0,
    );
  }
}

extension CashCollectionModelToEntity on CashCollectionModel {
  CashCollectionEntity toEntity() {
    return CashCollectionEntity(
      id: id,
      facilityName: facility?.name ?? '',
      facilityNameBn: facility?.nameBn ?? '',
      collectionDate: DateTime.tryParse(collectionDate ?? '') ?? DateTime.now(),
      productSellingAmount: productSellingAmount ?? 0,
      rentingOthersAmount: rentingOthersAmount ?? 0,
      lineItemsTotal: lineItemsTotal ?? 0,
      totalCashAmount: totalCashAmount ?? 0,
      items: (items ?? const []).map((item) => item.toEntity()).toList(),
      photoUrl: photoUrl,
      note: note,
      submittedByName: submittedBy?.name ?? '',
      submittedByNameBn: submittedBy?.nameBn ?? '',
    );
  }
}

extension CashCollectionListResponseModelToEntity
    on CashCollectionListResponseModel {
  CashCollectionListResultEntity toEntity() {
    final entities = (data ?? const [])
        .map((model) => model.toEntity())
        .toList();
    final curPage = meta?.currentPage ?? 1;
    final size = meta?.perPage ?? 20;
    final total = meta?.total ?? entities.length;
    final hasMore = meta?.lastPage != null
        ? curPage < meta!.lastPage!
        : (curPage * size) < total;

    return CashCollectionListResultEntity(
      list: PaginatedListEntity<CashCollectionEntity>(
        items: entities,
        currentPage: curPage,
        pageSize: size,
        totalRecords: total,
        hasMore: hasMore,
      ),
      summary: CashCollectionSummaryEntity(
        entriesCount: summary?.entriesCount ?? entities.length,
        manualTotal: summary?.manualTotal ?? 0,
      ),
    );
  }
}

extension FacilityServiceModelToEntity on FacilityServiceModel {
  FacilityServiceEntity toEntity() {
    return FacilityServiceEntity(
      id: id,
      serviceName: service?.titleEn ?? '',
      serviceNameBn: service?.titleBn ?? '',
      gender: gender ?? '',
      price: price ?? 0,
    );
  }
}

extension CreateCashCollectionRequestEntityMapper
    on CreateCashCollectionRequestEntity {
  /// Multipart body: the evidence photo is a real file sent under the
  /// (misleadingly named) `photo_url` field, and `items` use bracket
  /// notation. `unit_price` is never sent: the server resolves it.
  Future<FormData> toFormData() async {
    final date = collectionDate;
    final formData = FormData()
      ..fields.addAll([
        MapEntry('facility_id', '$facilityId'),
        MapEntry(
          'collection_date',
          '${date.year}-${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}',
        ),
        MapEntry('product_selling_amount', '$productSellingAmount'),
        MapEntry('renting_others_amount', '$rentingOthersAmount'),
      ]);
    final text = note?.trim();
    if (text != null && text.isNotEmpty) {
      formData.fields.add(MapEntry('note', text));
    }
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      formData.fields
        ..add(
          MapEntry('items[$i][facility_service_id]', '${line.facilityServiceId}'),
        )
        ..add(MapEntry('items[$i][gender]', line.gender))
        ..add(MapEntry('items[$i][quantity]', '${line.quantity}'));
    }
    formData.files.add(MapEntry('photo_url', await photoPart(photoPath)));

    return formData;
  }
}
