import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_apartments_finder/models/store/category.dart';


class CategoryItem extends StatelessWidget {
  Category category;
  CategoryItem(this.category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    double deviceWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () => {},
            child: Image.network(category.image, fit: BoxFit.cover)),
        footer: Container(
          height: deviceHeight * 0.045,
          child: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.75),
            title: Text(category.name, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
    ;
  }
}
