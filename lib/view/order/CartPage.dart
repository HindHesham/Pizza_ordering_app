import 'package:flutter/material.dart';
import 'package:pizza_ordering_app/data/response/Status.dart';
import 'package:pizza_ordering_app/models/menu/MenuModel.dart';
import 'package:pizza_ordering_app/models/order/CartModel.dart';
import 'package:pizza_ordering_app/models/order/OrderObjModel.dart';
import 'package:pizza_ordering_app/models/order/OrderStatusModel.dart';
import 'package:pizza_ordering_app/view/widgets/GenericSnackBar.dart';

import 'package:pizza_ordering_app/view/widgets/CustomeShadowContainer.dart';
import 'package:pizza_ordering_app/view_model/OrderVM.dart';
import 'package:provider/provider.dart';

import 'OrdersPage.dart';

class CartPage extends StatefulWidget {
  const CartPage(
      {Key? key, required this.restaurantId, required this.listOfOrderedItems})
      : super(key: key);

  final int restaurantId;
  final List<Menu> listOfOrderedItems;

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Order orderModel = Order();

  final OrderVM orderStatusVM = OrderVM();
  OrderStatus orderStatusModel = OrderStatus();
  int totalPrice = 0;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
  }

  _addCartOrderData() async {
    orderModel.cartItemList = [];
    for (int i = 0; i < widget.listOfOrderedItems.length; i++) {
      Cart cartListObj = Cart();
      cartListObj.menuItemId = widget.listOfOrderedItems[i].id;
      cartListObj.quantity = widget.listOfOrderedItems[i].itemCounter;
      orderModel.cartItemList?.add(cartListObj);
    }
    orderModel.restaurantId = widget.restaurantId;
    await orderStatusVM.checkOut(orderModel);
  }

  Future<void> _checkOutOrder() async {
    isloading = true;
    orderStatusVM.disableButton();
    try {
      await _addCartOrderData();
      if (orderStatusVM.createOrder.status == Status.COMPLETED) {
        isloading = false;
        _gotoOrderStatusPage(orderStatusVM.createOrder.data!.orderId!);
      }

      if (orderStatusVM.createOrder.status == Status.ERROR) {
        isloading = false;
        orderStatusVM.enableButton();
        GenericSnackBar.buildErrorSnackbar(
            context, 'please try checkout again');
      }
    } finally {}
  }

  Future _gotoOrderStatusPage(int orderID) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersPage(
          orderID: orderID,
        ),
      ),
    );
  }

  Widget _cartDetails(Menu orderedItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [Text(orderedItem.name!)],
        ),
        Column(
          children: [
            Text(
              orderedItem.itemCounter.toString(),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: ChangeNotifierProvider<OrderVM>(
          create: (BuildContext context) => orderStatusVM,
          child: Consumer<OrderVM>(
              builder: (context, orderStatusVM, child) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GenericShadowContainer(
                            0.9,
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.height *
                                          0.03,
                                      top: MediaQuery.of(context).size.height *
                                          0.03,
                                      right:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: const [
                                          Text(
                                            "item",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: const [
                                          Text(
                                            "count",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(
                                      MediaQuery.of(context).size.height *
                                          0.03),
                                  child: widget.listOfOrderedItems.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.listOfOrderedItems.length,
                                          itemBuilder: (_, index) {
                                            return _cartDetails(widget
                                                .listOfOrderedItems[index]);
                                          },
                                        )
                                      : const Text('No items'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      (widget.listOfOrderedItems.isNotEmpty)
                          ? ElevatedButton(
                              onPressed: (orderStatusVM.isEnabled)
                                  ? () => _checkOutOrder()
                                  : null,
                              child: (isloading)
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1.5,
                                      ))
                                  : const Text('Checkout'),
                            )
                          : Container(),
                    ],
                  )),
        ));
  }
}
