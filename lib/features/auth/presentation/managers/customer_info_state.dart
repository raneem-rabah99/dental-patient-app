class CustomerInfoState {
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const CustomerInfoState({
    required this.isLoading,
    this.successMessage,
    this.errorMessage,
  });

  factory CustomerInfoState.initial() =>
      const CustomerInfoState(isLoading: false);

  CustomerInfoState copyWith({
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return CustomerInfoState(
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
