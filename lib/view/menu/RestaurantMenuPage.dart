import 'package:flutter/material.dart';
import 'package:pizza_ordering_app/data/response/Status.dart';
import 'package:pizza_ordering_app/models/menu/MenuModel.dart';
import 'package:pizza_ordering_app/view/order/CartPage.dart';
import 'package:pizza_ordering_app/view/widgets/GenericLoadingWidget.dart';
import 'package:pizza_ordering_app/view/widgets/GenericErrorWidget.dart';
import 'package:pizza_ordering_app/view/widgets/GenericTextView.dart';
import 'package:pizza_ordering_app/view/widgets/CustomeShadowContainer.dart';
import 'package:pizza_ordering_app/view_model/MenuVM.dart';
import 'package:provider/provider.dart';

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({Key? key, required this.restaurantId})
      : super(key: key);

  final int restaurantId;
  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  final MenuVM restaurantMenuModel = MenuVM();

  @override
  void initState() {
    restaurantMenuModel.fetchRestaurantMenu(widget.restaurantId);
    super.initState();
  }

  _createOrderList() {
    List<Menu> listOfOrderedItems = [];
    List<Menu> menu = restaurantMenuModel.restaurantMenu.data!;
    for (var i = 0; i < menu.length; i++) {
      if (menu[i].itemCounter! > 0) {
        listOfOrderedItems.add(menu[i]);
      }
    }
    _goToCartPage(listOfOrderedItems);
  }

  _goToCartPage(List<Menu> menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
            restaurantId: widget.restaurantId, listOfOrderedItems: menu),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            _createOrderList();
          },
          child: const SizedBox(
            height: kToolbarHeight,
            width: double.infinity,
            child: Center(
              child: Text(
                'Place Order',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider<MenuVM>(
        create: (BuildContext context) => restaurantMenuModel,
        child: Consumer<MenuVM>(builder: (context, restaurantMenuModel, _) {
          switch (restaurantMenuModel.restaurantMenu.status) {
            case Status.LOADING:
              return GenericLoadingWidget();
            case Status.ERROR:
              return GenericErrorWidget(
                  restaurantMenuModel.restaurantMenu.message ?? "NA");
            case Status.COMPLETED:
              return _restaurantMenuList(
                  restaurantMenuModel.restaurantMenu.data!);

            default:
          }
          return Container();
        }),
      ),
    );
  }

  Widget _restaurantMenuList(List<Menu> menu) {
    return ListView.builder(
      itemBuilder: (context, position) {
        return _restaurantMenu(menu[position]);
      },
      itemCount: menu.length,
    );
  }

  //rating card
  Widget _drawRatingCard(String rate) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.025,
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.025,
          right: MediaQuery.of(context).size.width * 0.025),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green[700],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(rate,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.025,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(width: MediaQuery.of(context).size.width * 0.020),
          const Icon(Icons.star, color: Colors.white)
        ],
      ),
    );
  }

  // menu item name, category and topping
  Widget _menuItemNameCategoryTopping(
      String itemName, String itemCategory, String topping) {
    return ListTile(
      title: Text(
        "$itemName  $itemCategory",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(topping),
    );
  }

  //counter card
  Widget _itemCounter(Menu item) {
    int _n = item.itemCounter!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ClipOval(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                _n++;
                item.itemCounter = _n;
                setState(() {});
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.04,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
        Text(
          '  ${item.itemCounter}  ',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              fontWeight: FontWeight.bold),
        ),
        ClipOval(
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                if (item.itemCounter != 0) {
                  _n--;
                  item.itemCounter = _n;
                }
                setState(() {});
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.04,
                child: const Icon(Icons.remove),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // item details
  Widget _menuItemDetails(Menu menu, String topping) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            // name and category
            Expanded(
                flex: 2,
                child: _menuItemNameCategoryTopping(
                    "${menu.name}", "${menu.category}", topping)),
            //price
            Expanded(
              flex: 1,
              child: GenericTextView(
                "${menu.price} SEK",
                Colors.black,
                MediaQuery.of(context).size.height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
            //rateing
            Expanded(flex: 1, child: _drawRatingCard('${menu.rank}')),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        // counter
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_itemCounter(menu)],
        )
      ],
    );
  }

  // item details counter
  Widget _restaurantMenu(Menu menu) {
    String topping = menu.topping!.join(", ");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GenericShadowContainer(
          0.95,
          _menuItemDetails(menu, topping),
          height: 0.2,
        )
      ],
    );
  }
}
