import 'package:flutter/material.dart';
import 'package:pizza_ordering_app/data/response/Status.dart';
import 'package:pizza_ordering_app/models/order/OrderStatusModel.dart';
import 'package:pizza_ordering_app/view/widgets/CustomeShadowContainer.dart';
import 'package:pizza_ordering_app/view/widgets/GenericErrorWidget.dart';
import 'package:pizza_ordering_app/view/widgets/GenericLoadingWidget.dart';
import 'package:pizza_ordering_app/view_model/OrderVM.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key, this.orderID}) : super(key: key);

  int? orderID;
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrderVM orderStatusVM = OrderVM();
  int? orderID;

  @override
  void initState() {
    if (widget.orderID != null) {
      orderStatusVM.orderStatus(widget.orderID!);
    } else {
      _getOrderIdFromSharedPrefAndGetOrderstatusData();
    }
    super.initState();
  }

  _getOrderIdFromSharedPrefAndGetOrderstatusData() async {
    final prefs = await SharedPreferences.getInstance();
    widget.orderID = prefs.getInt('orderID');
    if (widget.orderID == null) {
      return;
    } else {
      await orderStatusVM.orderStatus(widget.orderID!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Order Status'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.of(context).popUntil(ModalRoute.withName('/')),
            ),
          ),
          body: ChangeNotifierProvider<OrderVM>(
            create: (BuildContext context) => orderStatusVM,
            child: Consumer<OrderVM>(builder: (context, orderStatusVM, _) {
              if (widget.orderID == null) {
                return const Center(child: Text("No orders yet"));
              }
              switch (orderStatusVM.createOrder.status) {
                case Status.LOADING:
                  return GenericLoadingWidget();
                case Status.ERROR:
                  return GenericErrorWidget(
                      orderStatusVM.createOrder.message ?? "NA");
                case Status.COMPLETED:
                  return _orderDetailsCard(orderStatusVM.createOrder.data!);

                default:
              }
              return Container();
            }),
          )),
    );
  }

  Widget _orderDetailsCard(OrderStatus order) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GenericShadowContainer(
            0.95,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Order id: ${order.orderId.toString()}'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text('price: ${order.totalPrice.toString()}'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text('Status: ${order.status}'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
