import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_dot/features/products/data/models/stock_movement_model.dart';
import 'package:three_dot/features/products/data/models/stock_movement_state.dart';
import 'package:three_dot/features/products/data/providers/product_provider.dart';
import 'package:three_dot/features/products/data/repositories/product_repository.dart';

final stockMovementNotifierProvider =
    StateNotifierProvider<StockMovementNotifier, StockMovementState>((ref) {
  return StockMovementNotifier(ref.watch(productRepositoryProvider));
});

class StockMovementNotifier extends StateNotifier<StockMovementState> {
  final ProductRepository _repository;

  StockMovementNotifier(this._repository) : super(const StockMovementState());

  Future<void> getAllStockMovements(int productId) async {
    try {
      state = state.copyWith(isListLoading: true);
      final stockMovements = await _repository.getProductMovements(productId);
      state = state.copyWith(
        stockMovementsList: stockMovements,
        isListLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isListLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> getAStockMovement(int movementId) async {
    try {
      state = state.copyWith(isLoading: true);
      final stockMovement = await _repository.getAProductMovements(movementId);
      state = state.copyWith(
        stockMovement: stockMovement,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> createStockMovement({
    required int productId,
    required String movementType,
    required double quantity,
    required double unitPrice,
    required String reference,
    required String remarks,
  }) async {
    try {
      print("provider called");
      state = state.copyWith(isCreating: true);
      StockMovementModel? movement = await _repository.createProductMovement(
          productId: productId,
          movementType: movementType,
          quantity: quantity,
          unitPrice: unitPrice,
          reference: reference,
          remarks: remarks);
      // Optionally refetch list after creation or add it directly
      getAllStockMovements(productId);
      state = state.copyWith(
        isCreating: false,
      );
      if (movement != null) {
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateStockMovement({
    required int movementId,
    required int productId,
    required double quantity,
    required double unitPrice,
    required String reference,
    required String remarks,
  }) async {
    try {
      state = state.copyWith(isUpdating: true);
      StockMovementModel? movement = await _repository.updateProductMovement(
          movementId: movementId,
          quantity: quantity,
          unitPrice: unitPrice,
          reference: reference,
          remarks: remarks);
      // Optionally refetch list or update the list directly
      getAllStockMovements(productId);
      state = state.copyWith(
        isUpdating: false,
      );
      if (movement != null) {
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> deleteStockMovement(int movementId, int productId) async {
    try {
      state = state.copyWith(isDeleting: true);
      await _repository.deleteProductMovement(movementId);
      // Remove the deleted item from the list
      getAllStockMovements(productId);
      state = state.copyWith(
        isDeleting: false,
      );
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: e.toString(),
      );
    }
  }
}
