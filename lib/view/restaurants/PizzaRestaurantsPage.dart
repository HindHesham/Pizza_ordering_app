import 'package:flutter/material.dart';
import 'package:pizza_ordering_app/data/response/Status.dart';
import 'package:pizza_ordering_app/models/restaurants/RestaurantModel.dart';
import 'package:pizza_ordering_app/view/order/OrdersPage.dart';
import 'package:pizza_ordering_app/view/restaurants/PizzaRestaurantsDetailspage.dart';
import 'package:pizza_ordering_app/view/widgets/GenericLoadingWidget.dart';
import 'package:pizza_ordering_app/view_model/RestaurantsVM.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class PizzaRestaurantsPage extends StatefulWidget {
  const PizzaRestaurantsPage({Key? key}) : super(key: key);

  @override
  _PizzaRestaurantsPageState createState() => _PizzaRestaurantsPageState();
}

class _PizzaRestaurantsPageState extends State<PizzaRestaurantsPage> {
  final RestaurantsVM restaurantsModel = RestaurantsVM();

  @override
  void initState() {
    // _removeSHaredPrefrencesData();
    restaurantsModel.fetchRestaurants();

    super.initState();
  }

  _removeSHaredPrefrencesData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('orderID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.playlist_add_check_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdersPage(),
                ),
              );
            },
          )
        ],
      ),
      body: ChangeNotifierProvider<RestaurantsVM>(
        create: (BuildContext context) => restaurantsModel,
        child: Consumer<RestaurantsVM>(builder: (context, restaurantsModel, _) {
          switch (restaurantsModel.restaurants.status) {
            case Status.LOADING:
              return GenericLoadingWidget();
            case Status.ERROR:
              return ErrorWidget(restaurantsModel.restaurants.message ?? "NA");
            case Status.COMPLETED:
              return _getRestaurantsListView(restaurantsModel.restaurants.data);
            default:
          }
          return Container();
        }),
      ),
    );
  }

  // List Widget
  Widget _getRestaurantsListView(List<Restaurant>? restaurantsList) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(restaurantsList!.length, (index) {
        return _getRestaurantsListViewItem(restaurantsList[index]);
      }),
    );
  }

  //item widget
  Widget _getRestaurantsListViewItem(Restaurant item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PizzaRestaurantDetailsPage(itemId: item.id!),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/pizza.png'))),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  item.name!,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.022),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  item.address1!,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.018),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.010,
                ),
                Text(
                  item.address2!,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.018),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
