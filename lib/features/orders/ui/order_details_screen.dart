import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/localization/language_cubit.dart';
import '../cubit/order_details_cubit.dart';
import '../models/order_card_item_model.dart';
import '../models/order_details_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderNumber;

  const OrderDetailsScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OrderDetailsCubit>()..getOrderDetails(orderNumber),
      child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          context.watch<LanguageCubit>();

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: Text('${AppTexts.order} #$orderNumber'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Builder(
              builder: (context) {
                if (state is OrderDetailsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is OrderDetailsFailure) {
                  return _buildErrorState(context, state.message);
                }

                if (state is OrderDetailsSuccess) {
                  final order = state.order;
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderInfoCard(order),
                        SizedBox(height: 20.h),
                        _buildAddressCard(order),
                        SizedBox(height: 20.h),
                        _buildPaymentCard(order),
                        SizedBox(height: 20.h),
                        _buildOrderItemsSection(order.cards),
                        SizedBox(height: 24.h),
                        _buildActionsSection(
                          context: context,
                          order: order,
                          isProcessing: state.isActionInProgress,
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(fontSize: 16.sp, color: AppColors.greyTextColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<OrderDetailsCubit>().getOrderDetails(orderNumber);
            },
            child: Text(AppTexts.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard(OrderDetailsModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.orderInformation,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackTextColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(AppTexts.orderNumberLabel, order.orderNumber),
          SizedBox(height: 12.h),
          _buildInfoRow(AppTexts.orderDate, _formatDate(order.createdAt)),
          SizedBox(height: 12.h),
          _buildInfoRow(AppTexts.customer, order.name),
          SizedBox(height: 12.h),
          _buildInfoRow(AppTexts.email, order.email),
          SizedBox(height: 12.h),
          _buildInfoRow(AppTexts.phone, order.phone),
        ],
      ),
    );
  }

  Widget _buildAddressCard(OrderDetailsModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.shippingAddress,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            order.addressLine,
            style: TextStyle(fontSize: 14.sp, color: AppColors.blackTextColor),
          ),
          SizedBox(height: 8.h),
          Text(
            '${order.city}, ${order.state} ${order.zipCode}',
            style: TextStyle(fontSize: 14.sp, color: AppColors.greyTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(OrderDetailsModel order) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTexts.paymentInformation,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(
            AppTexts.paymentMethod,
            order.paymentMethod.toUpperCase(),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            AppTexts.paymentStatus,
            _localizedPaymentStatus(order.paymentStatus),
          ),
          if (order.promoCode != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(AppTexts.promoCode, order.promoCode ?? ''),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(List<OrderCardItemModel> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.orderItems,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackTextColor,
          ),
        ),
        SizedBox(height: 16.h),
        ...cards.map(_buildOrderItemCard),
      ],
    );
  }

  Widget _buildOrderItemCard(OrderCardItemModel cardItem) {
    final itemName = cardItem.card.name;
    final itemPrice = cardItem.card.price;
    final currency = cardItem.card.currency;
    final quantity = cardItem.qty;
    final itemImage = cardItem.card.image;

    final totalPrice = (double.tryParse(itemPrice) ?? 0) * quantity;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.overlayColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: itemImage != null && itemImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      itemImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image_not_supported,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                  )
                : Icon(
                    Icons.image_not_supported,
                    color: AppColors.greyTextColor,
                    size: 32.sp,
                  ),
          ),
          SizedBox(width: 16.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      '${AppTexts.quantity}: $quantity',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '$itemPrice $currency',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  '${AppTexts.total}: ${totalPrice.toStringAsFixed(2)} $currency',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection({
    required BuildContext context,
    required OrderDetailsModel order,
    required bool isProcessing,
  }) {
    final isCancelable = _isOrderCancelable(order.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isCancelable)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isProcessing ? null : () => _confirmCancel(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                AppTexts.cancelOrder,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (isCancelable) SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isProcessing ? null : () => _confirmDelete(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              side: const BorderSide(color: Colors.red),
              foregroundColor: Colors.red,
            ),
            child: Text(
              AppTexts.deleteOrder,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (isProcessing) ...[
          SizedBox(height: 16.h),
          Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.greyTextColor),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return Colors.green;
      case 'pending':
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }

  String _formatDate(String dateString) {
    try {
      if (dateString.length > 20) {
        return dateString.substring(0, 20);
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppTexts.confirmCancelOrder),
        content: Text(AppTexts.cancelOrderConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppTexts.close),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppTexts.cancelOrder),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (confirmed == true) {
      final cubit = context.read<OrderDetailsCubit>();
      final messenger = ScaffoldMessenger.of(context);

      final result = await cubit.cancelOrder();
      if (!messenger.mounted) return;

      if (result == null) {
        _showResultSnackBar(
          messenger,
          AppTexts.orderCancelledSuccess,
          Colors.green,
        );
      } else {
        _showResultSnackBar(
          messenger,
          _resolveErrorMessage(result),
          Colors.red,
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppTexts.confirmDeleteOrder),
        content: Text(AppTexts.deleteOrderConfirmationMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppTexts.close),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              AppTexts.deleteOrder,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    if (confirmed == true) {
      final cubit = context.read<OrderDetailsCubit>();
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      final result = await cubit.deleteOrder();
      if (!messenger.mounted || !navigator.mounted) return;

      if (result == null) {
        _showResultSnackBar(
          messenger,
          AppTexts.orderDeletedSuccess,
          Colors.green,
        );
        navigator.pop(true);
      } else {
        _showResultSnackBar(
          messenger,
          _resolveErrorMessage(result),
          Colors.red,
        );
      }
    }
  }

  void _showResultSnackBar(
    ScaffoldMessengerState messenger,
    String message,
    Color color,
  ) {
    messenger.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  String _resolveErrorMessage(String message) {
    if (message == OrderDetailsCubit.orderNotLoadedKey) {
      return AppTexts.orderNotLoaded;
    }
    return message;
  }

  bool _isOrderCancelable(String status) {
    final normalized = status.toLowerCase();
    return !{
      'cancel',
      'cancelled',
      'canceled',
      'completed',
      'delivered',
    }.contains(normalized);
  }

  String _localizedPaymentStatus(String status) {
    final normalized = status.toLowerCase();
    if (normalized == '1' || normalized == 'paid') {
      return AppTexts.paid;
    }
    if (normalized == '0' ||
        normalized == 'pending' ||
        normalized == 'unpaid' ||
        normalized == 'awaiting') {
      return AppTexts.pending;
    }
    return status;
  }
}
