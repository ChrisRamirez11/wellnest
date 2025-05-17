// ignore_for_file: public_member_api_docs, sort_constructors_first
class PeriodDataState {
  final bool loading;
  final String? summary;
  final String? error;

  PeriodDataState({this.loading = false, this.summary, this.error});

  PeriodDataState copyWith({
    bool? loading,
    String? summary,
    String? error,
  }) {
    return PeriodDataState(
      loading: loading ?? this.loading,
      summary: summary ?? this.summary,
      error: error ?? this.error,
    );
  }
}
