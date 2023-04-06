import 'package:dart_payway/dart_payway.dart';
import 'package:dart_payway/src/models/aba_merchant.dart';

void main() async {
  PaywayTransactionService.ensureInitialized(ABAMerchant.fromMap({
    "ABA_PAYWAY_MERCHANT_ID": "",
    "ABA_PAYWAY_MERCHANT_NAME": "",
    "ABA_PAYWAY_API_KEY": "",
    "ABA_PAYWAY_API_URL": "",
  }));

  final service = PaywayTransactionService.instance!;
  final tranID = service.uniqueTranID();

  var _transaction = PaywayCreateTransaction(
      amount: 6.00,
      items: [
        PaywayTransactionItem(name: "ទំនិញ 1", price: 1, quantity: 1),
        PaywayTransactionItem(name: "ទំនិញ 2", price: 2, quantity: 1),
        PaywayTransactionItem(name: "ទំនិញ 3", price: 3, quantity: 1),
      ],
      reqTime: service.uniqueReqTime(),
      tranId: tranID,
      email: 'support@mylekha.app',
      firstname: 'Miss',
      lastname: 'My Lekha',
      phone: '010464144',
      option: ABAPaymentOption.abapay_deeplink,
      shipping: 0.0,
      returnUrl: Uri.tryParse("https://stage.mylekha.app"));

  /// create transaction
  var createResponse =
      await service.createTransaction(transaction: _transaction);

  ///gernate checkout payway uri
  String checkoutApiUrl =
      "http://localhost/api/v1/integrate/payway/checkout_page";
  var webURI = await service.generateTransactionCheckoutURI(
      transaction: _transaction, checkoutApiUrl: checkoutApiUrl);
}
