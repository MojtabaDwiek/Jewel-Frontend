import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';
import 'package:pn_fl_jewellery_empire/theme/theme.dart';
import 'package:pn_fl_jewellery_empire/widget/column_builder.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:pn_fl_jewellery_empire/cart_provider.dart'; // Import CartProvider

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context); // Access CartProvider

    return Scaffold(
      body: Column(
        children: [
          header(),
          Expanded(
            child: cartProvider.cartItems.isEmpty
                ? emptyListContent()
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(fixPadding * 2.0,
                        fixPadding, fixPadding * 2.0, fixPadding * 2.0),
                    children: [
                      cartItemListContent(cartProvider),
                      heightSpace,
                      heightSpace,
                      weightInfo(cartProvider), // Display total weight
                      heightSpace,
                      heightSpace,
                      proceedToCheckout(),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  emptyListContent() {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(fixPadding * 2.0),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: const [
          Iconify(
            Ph.handbag,
            size: 26.0,
            color: greyColor,
          ),
          heightSpace,
          Text(
            "Cart is Empty",
            style: medium18Grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  proceedToCheckout() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/selectAddress');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.5),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Proceed to Checkout",
          style: medium19White,
        ),
      ),
    );
  }

  weightInfo(CartProvider cartProvider) {
    // Calculate total weight
    double totalWeight = cartProvider.cartItems.fold(
      0,
      (sum, item) => sum + (item.weight * item.quantity),
    );

    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(fixPadding),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                "Total Weight",
                style: semibold16Black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            widthSpace,
            Text(
              "${totalWeight.toStringAsFixed(2)} kg", // Display total weight
              style: semibold16Black,
            )
          ],
        ),
      ),
    );
  }

  cartItemListContent(CartProvider cartProvider) {
    return ColumnBuilder(
      itemBuilder: (context, index) {
        final item = cartProvider.cartItems[index];

        // Debugging: Check the imageUrl
        print('Image URL for ${item.name}: ${item.imageUrl}');

        return Container(
          padding: const EdgeInsets.all(fixPadding),
          margin: const EdgeInsets.symmetric(vertical: fixPadding),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(fixPadding),
                clipBehavior: Clip.hardEdge,
                height: 80.0,
                width: 85.0,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      blurRadius: 20.0,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl, // Use the full URL directly
                        fit: BoxFit.cover,
                        height: 60.0,
                        width: 60.0,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if image cannot be loaded
                          return const Icon(
                            Icons.error, // Error icon
                            size: 40.0,
                            color: greyColor,
                          );
                        },
                      )
                    : const Icon(
                        Icons.shopping_bag, // Fallback icon if no image
                        size: 40.0,
                        color: greyColor,
                      ),
              ),
              widthSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name, // Use the name from CartItem
                                style: regular16Black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              heightBox(3.0),
                              Text(
                                "Size: ${item.selectedSize}", // Use the size from CartItem
                                style: regular14Grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                              heightBox(3.0),
                              Text(
                                "Weight: ${item.weight.toStringAsFixed(2)} kg", // Use the weight from CartItem
                                style: regular14Grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    heightSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              addRemoveButton(Icons.remove, () {
                                if (item.quantity > 1) {
                                  cartProvider.updateQuantity(item, item.quantity - 1);
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: fixPadding * 1.5),
                                child: Text(
                                  item.quantity.toString(), // Use the quantity from CartItem
                                  style: bold14Black,
                                ),
                              ),
                              addRemoveButton(Icons.add, () {
                                cartProvider.updateQuantity(item, item.quantity + 1);
                              }),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            cartProvider.removeFromCart(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: blackColor,
                                duration: Duration(milliseconds: 1500),
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  "Removed from shopping cart",
                                  style: medium16White,
                                ),
                              ),
                            );
                          },
                          child: const Iconify(
                            Uil.trash_alt,
                            size: 22.0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
      itemCount: cartProvider.cartItems.length,
    );
  }

  addRemoveButton(IconData icon, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26.0,
        width: 26.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: borderColor)),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: blackColor,
          size: 18.0,
        ),
      ),
    );
  }

  header() {
    return Container(
      padding: const EdgeInsets.only(top: fixPadding),
      decoration: headerBoxDecoration,
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: fixPadding * 2.0,
        elevation: 0.0,
        title: const Text(
          "Shopping Cart",
          style: semibold20Black,
        ),
      ),
    );
  }
}
