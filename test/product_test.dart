import 'package:eight_barrels/model/product/product_model.dart';
import 'package:eight_barrels/provider/product/product_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('finds a specific instance', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Text('Hello'),
      ),
    ));
    expect(find.text('Hello'), findsOneWidget);
  });
  // test("Product List", () {
  //   // Arrange
  //   ProductListModel model = new ProductListModel();
  //   ProductListProvider provider = new ProductListProvider();
  //   // Act
  //   double result = pro.circle(1);
  //   // Assert
  //   expect(result, 3.141592);
  // });
}