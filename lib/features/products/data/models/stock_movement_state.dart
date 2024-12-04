import 'package:three_dot/features/products/data/models/stock_movement_model.dart';

class StockMovementState {
  final bool isLoading;
  final bool isListLoading;
  final StockMovementModel? stockMovement;
  final String? error;
  final List<StockMovementModel> stockMovementsList;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;

  const StockMovementState({
    this.isLoading = false,
    this.isListLoading = false,
    this.error,
    this.stockMovement,
    this.stockMovementsList = const <StockMovementModel>[],
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
  });

  StockMovementState copyWith({
    bool? isLoading,
    bool? isListLoading,
    StockMovementModel? stockMovement,
    String? error,
    List<StockMovementModel>? stockMovementsList,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
  }) {
    return StockMovementState(
      isLoading: isLoading ?? this.isLoading,
      isListLoading: isListLoading ?? this.isListLoading,
      error: error ?? this.error,
      stockMovement: stockMovement ?? this.stockMovement,
      stockMovementsList: stockMovementsList ?? this.stockMovementsList,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}
