import 'dart:convert';
import 'package:flutter/src/foundation/print.dart' as p;
import 'package:flutter/material.dart';
import 'package:dart_payway/dart_payway.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FlutterPaywayPage extends StatefulWidget {
  const FlutterPaywayPage({super.key});

  @override
  State<FlutterPaywayPage> createState() => _FlutterPaywayPageState();
}

class _FlutterPaywayPageState extends State<FlutterPaywayPage> {
  late List<PaywayTransactionItem> items = <PaywayTransactionItem>[
    PaywayTransactionItem(name: "item 1", quantity: 1, price: 1),
    PaywayTransactionItem(name: "item 2", quantity: 2, price: 2),
    PaywayTransactionItem(name: "item 3", quantity: 3, price: 3),
  ];

  double get total => items.fold(0, (pre, e) => pre += e.quantity * e.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter payway"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return ListTile(
            title: Text(item.name),
            subtitle: Text("(${item.price} x ${item.quantity})"),
            trailing: Text("${item.price * item.quantity}"),
          );
        },
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: _onCheckout, child: Text("checkout out ($total)")),
      ),
    );
  }

  _onCheckout() async {
    final env = dotenv;
    final _merchant = ABAMerchant(
      merchantID: env.get('ABA_PAYWAY_MERCHANT_ID'),
      merchantApiName: env.get('ABA_PAYWAY_MERCHANT_NAME'),
      merchantApiKey: env.get('ABA_PAYWAY_API_KEY'),
      baseApiUrl: env.get('ABA_PAYWAY_API_URL'),
      refererDomain:
          env.get('ABA_PAYWAY_API_URL', fallback: "http://mylekha.app"),
    );
    PaywayTransactionService.ensureInitialized(_merchant);
    final service = PaywayTransactionService.instance;
    final tranID = service!.uniqueTranID();

    /// transaction
    final returnUrl = Uri.tryParse("https://mylekha.app/payment/complete");
    p.debugPrint("returnUrl $returnUrl");
    var _transaction = PaywayCreateTransaction(
      amount: total,
      items: items,
      reqTime: service.uniqueReqTime(),
      tranId: tranID,
      email: 'support@mylekha.app',
      firstname: "chan",
      lastname: 'dara',
      phone: '85510010010',
      option: ABAPaymentOption.abapay,
      shipping: 0.0,
      currency: ABATransactionCurrency.USD,
      returnUrl: returnUrl,
      returnParams: {
        "store_id": 1,
        "company_id": 2,
        "ticket_id": 3,
      },
    );
    final transactionResponse = await service.createTransaction(
        transaction: _transaction, enabledLogger: true);
    if (transactionResponse.qrImage != null &&
        transactionResponse.qrImage?.isNotEmpty == true) {
      showDialog(
          context: context,
          builder: (_) => Dialog(
                  child: QRImageDialog(
                qrImage: transactionResponse.qrImage!,
              )));
    }
  }
}

class QRImageDialog extends StatelessWidget {
  final String qrImage;
  const QRImageDialog({super.key, required this.qrImage});

  @override
  Widget build(BuildContext context) {
    final QR_IMAGE =
        base64Decode((qrImage.replaceAll("data:image/png;base64,", "")));

    return Container(
      width: 400,
      height: 400,
      child: Center(
        child: SizedBox(
          width: 196,
          height: 196,
          child: Image.memory(QR_IMAGE),
        ),
      ),
    );
  }
}
