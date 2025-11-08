import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../cubit/order_details_cubit.dart';
import '../models/order_details_model.dart';
import '../models/order_card_item_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderNumber;

  const OrderDetailsScreen({
    super.key,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OrderDetailsCubit>()..getOrderDetails(orderNumber),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text('Order #$orderNumber'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OrderDetailsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.greyTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderDetailsCubit>().getOrderDetails(orderNumber);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is OrderDetailsSuccess) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Info Card
                    _buildOrderInfoCard(state.order),
                    SizedBox(height: 20.h),
                    // Shipping Address Card
                    _buildAddressCard(state.order),
                    SizedBox(height: 20.h),
                    // Payment Info Card
                    _buildPaymentCard(state.order),
                    SizedBox(height: 20.h),
                    // Order Items
                    _buildOrderItemsSection(state.order.cards),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
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
                'Order Information',
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
          _buildInfoRow('Order Number', order.orderNumber),
          SizedBox(height: 12.h),
          _buildInfoRow('Date', _formatDate(order.createdAt)),
          SizedBox(height: 12.h),
          _buildInfoRow('Customer', order.name),
          SizedBox(height: 12.h),
          _buildInfoRow('Email', order.email),
          SizedBox(height: 12.h),
          _buildInfoRow('Phone', order.phone),
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
            'Shipping Address',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            order.addressLine,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${order.city}, ${order.state} ${order.zipCode}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyTextColor,
            ),
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
            'Payment Information',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow('Payment Method', order.paymentMethod.toUpperCase()),
          SizedBox(height: 12.h),
          _buildInfoRow(
            'Payment Status',
            order.paymentStatus == '1' || order.paymentStatus.toLowerCase() == 'paid'
                ? 'Paid'
                : 'Pending',
          ),
          if (order.promoCode != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow('Promo Code', order.promoCode ?? ''),
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
          'Order Items',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackTextColor,
          ),
        ),
        SizedBox(height: 16.h),
        ...cards.map((cardItem) => _buildOrderItemCard(cardItem)).toList(),
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
                      'Qty: $quantity',
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
                  'Total: ${totalPrice.toStringAsFixed(2)} $currency',
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyTextColor,
            ),
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
}

