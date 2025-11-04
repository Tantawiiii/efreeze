import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/order_cubit.dart';
import '../models/create_order_request_model.dart';
import '../models/order_card_model.dart';
import '../../cart/models/cart_item_model.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _promoCodeController = TextEditingController();
  String _paymentMethod = 'card';

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressLineController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  void _submitOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final cards = widget.cartItems.map((item) {
        return OrderCardModel(
          id: item.cardId,
          qty: item.quantity,
        );
      }).toList();

      final orderData = CreateOrderRequestModel(
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine: _addressLineController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        paymentMethod: _paymentMethod,
        promoCode: _promoCodeController.text.trim().isEmpty
            ? null
            : _promoCodeController.text.trim(),
        cards: cards,
      );

      context.read<OrderCubit>().createOrder(orderData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OrderCubit>(),
      child: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is OrderFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Checkout'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Information
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _phoneController,
                      hint: 'Phone',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Shipping Address
                    Text(
                      'Shipping Address',
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _addressLineController,
                      hint: 'Address Line',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _cityController,
                            hint: 'City',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: AppTextField(
                            controller: _stateController,
                            hint: 'State',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter state';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _zipCodeController,
                      hint: 'Zip Code',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter zip code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Payment Method
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _paymentMethod = 'card';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: _paymentMethod == 'card'
                                    ? AppColors.primaryColor.withOpacity(0.1)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: _paymentMethod == 'card'
                                      ? AppColors.primaryColor
                                      : AppColors.textFieldBorderColor,
                                  width: _paymentMethod == 'card' ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    color: _paymentMethod == 'card'
                                        ? AppColors.primaryColor
                                        : AppColors.greyTextColor,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Card',
                                    style: TextStyle(
                                      color: _paymentMethod == 'card'
                                          ? AppColors.primaryColor
                                          : AppColors.greyTextColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _paymentMethod = 'cash';
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: _paymentMethod == 'cash'
                                    ? AppColors.primaryColor.withOpacity(0.1)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: _paymentMethod == 'cash'
                                      ? AppColors.primaryColor
                                      : AppColors.textFieldBorderColor,
                                  width: _paymentMethod == 'cash' ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.money,
                                    color: _paymentMethod == 'cash'
                                        ? AppColors.primaryColor
                                        : AppColors.greyTextColor,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Cash',
                                    style: TextStyle(
                                      color: _paymentMethod == 'cash'
                                          ? AppColors.primaryColor
                                          : AppColors.greyTextColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Promo Code
                    Text(
                      'Promo Code (Optional)',
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _promoCodeController,
                      hint: 'Enter promo code',
                    ),
                    SizedBox(height: 32.h),

                    // Submit Button
                    BlocBuilder<OrderCubit, OrderState>(
                      builder: (context, state) {
                        final isLoading = state is OrderLoading;
                        return PrimaryButton(
                          title: isLoading ? 'Processing...' : 'Place Order',
                          onPressed: isLoading
                              ? null
                              : () => _submitOrder(context),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

