import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../auth/models/user_model.dart';
import '../cubit/user_info_cubit.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<UserInfoCubit>()..checkAuth(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('My Account'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<UserInfoCubit, UserInfoState>(
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserInfoFailure) {
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
                        context.read<UserInfoCubit>().checkAuth();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is UserInfoSuccess) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Section
                    _buildUserInfoSection(state.user),
                    SizedBox(height: 32.h),
                    // Orders Section
                    _buildOrdersSection(context, state.orders),
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

  Widget _buildUserInfoSection(UserModel user) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 50.r,
            backgroundColor: AppColors.textFieldBorderColor,
            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                ? NetworkImage(user.avatar!)
                : null,
            child: user.avatar == null || user.avatar!.isEmpty
                ? Icon(
                    Icons.person,
                    color: AppColors.greyTextColor,
                    size: 40.sp,
                  )
                : null,
          ),
          SizedBox(height: 16.h),
          // Name
          Text(
            user.name,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 16.sp,
                color: AppColors.greyTextColor,
              ),
              SizedBox(width: 8.w),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.greyTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Phone
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_outlined,
                size: 16.sp,
                color: AppColors.greyTextColor,
              ),
              SizedBox(width: 8.w),
              Text(
                user.phone,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.greyTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, List<dynamic> orders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackTextColor,
          ),
        ),
        SizedBox(height: 16.h),
        if (orders.isEmpty)
          Container(
            padding: EdgeInsets.all(40.w),
            decoration: BoxDecoration(
              color: AppColors.overlayColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64.sp,
                  color: AppColors.greyTextColor,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No orders yet',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.greyTextColor,
                  ),
                ),
              ],
            ),
          )
        else
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            return _buildOrderCard(context, order, index);
          }).toList(),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, dynamic order, int index) {
    // Handle different order data structures
    String orderId = '';
    String orderNumber = '';
    String orderStatus = '';
    String orderDate = '';
    String? orderTotal;

    if (order is Map) {
      orderId = order['id']?.toString() ?? order['orderId']?.toString() ?? 'N/A';
      orderNumber = order['order_number']?.toString() ?? 
                   order['orderNumber']?.toString() ?? 
                   orderId;
      orderStatus = order['status']?.toString() ?? order['orderStatus']?.toString() ?? 'Unknown';
      orderDate = order['createdAt']?.toString() ?? 
                  order['date']?.toString() ?? 
                  order['created_at']?.toString() ?? '';
      orderTotal = order['total']?.toString() ?? 
                   order['amount']?.toString() ?? 
                   order['price']?.toString();
    } else {
      orderId = order.toString();
      orderNumber = orderId;
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.orderDetails,
          arguments: {'orderNumber': orderNumber},
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
                'Order #$orderId',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackTextColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(orderStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  orderStatus,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _getStatusColor(orderStatus),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (orderDate.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14.sp,
                  color: AppColors.greyTextColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  orderDate.length > 20 ? orderDate.substring(0, 20) : orderDate,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.greyTextColor,
                  ),
                ),
              ],
            ),
          ],
          if (orderTotal != null) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.greyTextColor,
                  ),
                ),
                Text(
                  orderTotal,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      ),
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
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return AppColors.primaryColor;
    }
  }
}

