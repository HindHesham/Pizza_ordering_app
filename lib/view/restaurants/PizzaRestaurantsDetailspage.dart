import 'package:flutter/material.dart';
import 'package:pizza_ordering_app/data/response/Status.dart';
import 'package:pizza_ordering_app/models/restaurants/RestaurantModel.dart';
import 'package:pizza_ordering_app/view/menu/RestaurantMenuPage.dart';
import 'package:pizza_ordering_app/view/widgets/GenericLoadingWidget.dart';
import 'package:pizza_ordering_app/view/widgets/GenericErrorWidget.dart';
import 'package:pizza_ordering_app/view/widgets/GenericTextView.dart';
import 'package:pizza_ordering_app/view_model/RestaurantsVM.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class PizzaRestaurantDetailsPage extends StatefulWidget {
  const PizzaRestaurantDetailsPage({Key? key, required this.itemId})
      : super(key: key);

  final int itemId;

  @override
  _PizzaRestaurantDetailsPageState createState() =>
      _PizzaRestaurantDetailsPageState();
}

class _PizzaRestaurantDetailsPageState
    extends State<PizzaRestaurantDetailsPage> {
  final RestaurantsVM restaurantsModel = RestaurantsVM();

  bool checkedValue = false;

  @override
  void initState() {
    restaurantsModel.fetchRestaurantDetails(widget.itemId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.title),
      ),
      body: ChangeNotifierProvider<RestaurantsVM>(
        create: (BuildContext context) => restaurantsModel,
        child: Consumer<RestaurantsVM>(builder: (context, restaurantsModel, _) {
          switch (restaurantsModel.restaurantDetails.status) {
            case Status.LOADING:
              return GenericLoadingWidget();
            case Status.ERROR:
              return GenericErrorWidget(
                  restaurantsModel.restaurantDetails.message ?? "NA");
            case Status.COMPLETED:
              return _restaurantDetails(
                  restaurantsModel.restaurantDetails.data!);

            default:
          }
          return Container();
        }),
      ),
    );
  }

  //view restaurant details widget
  Widget _restaurantDetails(Restaurant item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05),
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.contain, image: AssetImage('assets/pizza.png'))),
        ),
        GenericTextView("${item.name}", Colors.black,
            MediaQuery.of(context).size.height * 0.03),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        GenericTextView("${item.address1}", Colors.black,
            MediaQuery.of(context).size.height * 0.02),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        GenericTextView("${item.address2}", Colors.black,
            MediaQuery.of(context).size.height * 0.02),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RestaurantMenuPage(restaurantId: item.id!),
              ),
            );
          },
          child: const Text('Show Menu'),
        )
      ],
    );
  }
}
