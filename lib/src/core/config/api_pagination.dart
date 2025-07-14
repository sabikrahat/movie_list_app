import 'package:flutter/material.dart';

class ApiPagination {
  String? query;
  int? page;
  int? perPage;
  DateTimeRange? dateRange;
  dynamic param;

  ApiPagination({this.query, this.page, this.perPage, this.dateRange, this.param});

  @override
  String toString() =>
      'ApiPagination(query: $query, page: $page, perPage: $perPage,dateRange: $dateRange, param: $param)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiPagination &&
        other.query == query &&
        other.page == page &&
        other.perPage == perPage &&
        other.dateRange == dateRange &&
        other.param == param;
  }

  @override
  int get hashCode =>
      query.hashCode ^ page.hashCode ^ perPage.hashCode ^ param.hashCode ^ dateRange.hashCode;
}
