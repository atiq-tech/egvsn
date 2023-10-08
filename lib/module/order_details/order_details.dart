// Design by - Link-Up Technology Ltd.
// Developed by - Link-Up Technology Ltd.
// Location - Mirpur-10, Dhaka, Bangladesh.
// Website - https://www.linktechbd.com/
// Phone - +8801911978897

import 'package:egovisionapp/core/remote_name.dart';
import 'package:egovisionapp/module/authentication/login/controller/login_bloc.dart';
import 'package:egovisionapp/module/authentication/login/model/user_login_response_model.dart';
import 'package:egovisionapp/module/order/model/order_model.dart';
import 'package:egovisionapp/module/order_details/component/order_update.dart';
import 'package:egovisionapp/module/order_details/controller/order_details_controller_cubit.dart';
import 'package:egovisionapp/utils/constant.dart';
import 'package:egovisionapp/utils/hive/hive_adapter.dart';
import 'package:egovisionapp/utils/hive/update_product_adapter.dart';
import 'package:egovisionapp/utils/save_pdf_file.dart';
import 'package:egovisionapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:number_to_character/number_to_character.dart';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:device_info_plus/device_info_plus.dart';


class OrderDetailsScreenArguments {
  final String id;
  final OrderModel orderModel;
  final UserLoginResponseModel? userLoginResponseModel;
  int index;

  OrderDetailsScreenArguments(this.id, this.orderModel, this.index, this.userLoginResponseModel);
}

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.id, required this.index, required this.orderModel, required this.userLoginResponseModel});

  final String id;
  final OrderModel orderModel;
  final UserLoginResponseModel? userLoginResponseModel;
  final int index;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<OrderDetailsCubit>().getOrderDetails(widget.id,));
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF78359E),
        scrolledUnderElevation: 0,
        title: const SizedBox(
            child: Text(
          "Order Details",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsControllerState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is OrderDetailsControllerLoading) {
              print("Loading0");
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderDetailsControllerError) {
              print("Loading1");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              );
            }
            if (state is OrderDetailsControllerLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Visibility(
                            visible: widget.orderModel.status != 'p',
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                          Visibility(
                            visible: widget.orderModel.status == 'p',
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () async{
                                  print('update start');
                                  final productUpdateBox = Hive.box<UpdateProduct>('product_update');
                                          final productsUpdate = List.generate(state.orderDetailsModel.length, (index){
                                            return UpdateProduct(
                                              id: state.orderDetailsModel[index].productId,
                                              orderId: state.orderDetailsModel[index].orderId,
                                              name: state.orderDetailsModel[index].productName,
                                              img: state.orderDetailsModel[index].productImage,
                                              qtn: double.parse(state.orderDetailsModel[index].quantity),
                                              purchasePrice: state.orderDetailsModel[index].purchaseRate,
                                              status: 'a',
                                              sellingPrice: double.parse(state.orderDetailsModel[index].saleRate),
                                              totalPrice: double.parse(state.orderDetailsModel[index].total),
                                            );
                                          });
                                  productUpdateBox.addAll(productsUpdate);
                                  print('update end');
                                  Navigator.pushNamed(context, RouteNames.orderUpdate,arguments: widget.id).then((value){
                                    Hive.box<UpdateProduct>('product_update').clear();
                                    Hive.box<UpdateProduct>('product_update').clear();
                                  });
                                },
                                label: const Text('Update Order'),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                            ),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text("Customer Id: ${loginBloc?.userInfo?.user?.code}",style: TextStyle(fontSize: 12),),
                                    Text("Customer Id: ${loginBloc.userInfo?.user?.code}",style: const TextStyle(fontSize: 12),),
                                    Text("Customer Name: ${loginBloc.userInfo?.user?.name}",style: const TextStyle(fontSize: 12),),
                                    Text("Area: ${loginBloc.userInfo?.user?.area}",style: const TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Invoice No: ${widget.orderModel.invoice}",style: const TextStyle(fontSize: 12),),
                                    Text("Order Date: ${Utils.formatDate(widget.orderModel.createAt)}",style: const TextStyle(fontSize: 12),),
                                    Text("Order Time: ${Utils.formatDatewithTime(widget.orderModel.createAt)}",style: const TextStyle(fontSize: 12),),
                                    Row(
                                      children: [
                                        const Text("Status:",style: TextStyle(fontSize: 12),),
                                        const SizedBox(width: 10,),
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: widget.orderModel.status == 'p'
                                                ? Colors.orange.shade700
                                                : widget.orderModel.status == 'o'
                                                ? const Color(0xFF1B6AAA)
                                                : widget.orderModel.status == 'h'
                                                ? const Color(0xFf157347)
                                                : widget.orderModel.status == 'd'
                                                ? Colors.red.shade700
                                                : null,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            widget.orderModel.status == 'p'
                                                ? "Pending"
                                                : widget.orderModel.status == 'o'
                                                ? "Ongoing"
                                                : widget.orderModel.status == 'h'
                                                ? "Received"
                                                : widget.orderModel.status == 'd'
                                                ? "Canceled"
                                                : '',
                                            style: const TextStyle(color: Colors.white, fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ///order details filed name
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: redColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      child: Text(
                                        "SL.",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontSize: 11),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: redColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      child: Text(
                                        "Description",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontSize: 11),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: redColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      child: Text(
                                        "Quantity",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontSize: 11),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: redColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      child: Text(
                                        "Unit",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontSize: 11),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: redColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      child: Text(
                                        "Price",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontSize: 11),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: const BoxDecoration(
                                    color: redColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: const SizedBox(
                                      child: Text(
                                        "Total",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white,fontSize: 11),
                                      )),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10,),
                          ...List.generate(state.orderDetailsModel.length, (index){
                            return Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                child: SizedBox(
                                    child: Text(
                                      "${index+1}",
                                      maxLines: 2,
                                      // style: TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10),
                                    ))
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                      child: Text(
                                        state.orderDetailsModel[index].productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                      child: Text(
                                        double.parse(state.orderDetailsModel[index].quantity)
                                            .toStringAsFixed(0),
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                      child: Text(
                                        state.orderDetailsModel[index].unitName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),

                                      )),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                      child: Text(
                                        state.orderDetailsModel[index].saleRate,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),

                                      )),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                      child: Text(
                                        state.orderDetailsModel[index].total,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      )),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(height: 20,),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("Subtotal: ${state.result}",style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          const SizedBox(height: 30,),
                          Text("In Word: ${converter.convertDouble(state.result).toUpperCase()}",style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10,),
                          Text("Note: ${widget.orderModel.note}",style: const TextStyle(fontWeight: FontWeight.bold)),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () async {
                                final iconImage = (await rootBundle.load('assets/images/app_logo.png')).buffer.asUint8List();
                                // _createPDF(
                                //     filename: '${widget.orderModel.invoice}',
                                //     context: context, index: widget.index,
                                //     dataLength: state.orderDetailsModel.length,
                                //     data: state.orderDetailsModel,
                                // );
                                DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                                final androidInfo = await deviceInfoPlugin.androidInfo;
                                apiLevel = androidInfo.version.sdkInt;
                                PermissionStatus storagePermission;
                                print("apiLevel $apiLevel");

                                if (apiLevel >= 31) {
                                  storagePermission = await Permission.manageExternalStorage.request();
                                } else {
                                  storagePermission = await Permission.storage.request();
                                }

                                if (storagePermission == PermissionStatus.granted) {
                                  try {
                                    pdf.addPage(
                                      pw.MultiPage(
                                        pageFormat: PdfPageFormat.a4,
                                        header: (context) {
                                          return pw.Column(
                                            children: [
                                              pw.Row(
                                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                children: [
                                                  pw.Image(
                                                    pw.MemoryImage(iconImage),
                                                    height: 300,
                                                    width: 150,
                                                  ),
                                                  pw.SizedBox(width: 5 * PdfPageFormat.mm),
                                                  pw.Column(
                                                    mainAxisSize: pw.MainAxisSize.min,
                                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                    children: [
                                                      pw.Text(
                                                        'Ego Vision HQ',
                                                        style: pw.TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight: pw.FontWeight.bold,
                                                        ),
                                                      ),
                                                      pw.Text(
                                                        'Fashion Tower, 98/6-A, \nBara Moghbazar, Dhaka-1217',
                                                        style: const pw.TextStyle(
                                                          fontSize: 14.0,
                                                          color: PdfColors.grey700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              pw.SizedBox(height: 5 * PdfPageFormat.mm),
                                              pw.Padding(
                                                padding: pw.EdgeInsets.zero,
                                                child: pw.Divider()
                                              ),
                                              pw.Padding(
                                                padding: pw.EdgeInsets.zero,
                                                child: pw.Divider()
                                              ),
                                              pw.SizedBox(height: 5 * PdfPageFormat.mm),
                                            ]
                                          );
                                        },
                                        build: (context) {
                                          return [

                                            pw.Align(
                                                child: pw.Text("Order Invoice",style: pw.TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: pw.FontWeight.bold
                                                )),
                                                alignment: pw.Alignment.center
                                            ),

                                            pw.SizedBox(height: 10 * PdfPageFormat.mm),

                                            pw.Row(
                                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.SizedBox(width: 1 * PdfPageFormat.mm),
                                                pw.Column(
                                                  mainAxisSize: pw.MainAxisSize.min,
                                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                  children: [
                                                    pw.Text(
                                                      'Customer Id: ${widget.userLoginResponseModel?.user?.code}',
                                                      style: pw.TextStyle(
                                                          color: PdfColors.black,
                                                          fontWeight: pw.FontWeight.bold),
                                                    ),
                                                    pw.SizedBox(height: 5),
                                                    pw.Text(
                                                      'Customer Name: ${widget.userLoginResponseModel?.user?.name}',
                                                      style: pw.TextStyle(
                                                          color: PdfColors.black,
                                                          fontWeight: pw.FontWeight.bold),
                                                    ),
                                                    pw.SizedBox(height: 5),
                                                    pw.SizedBox(
                                                      width: 250,
                                                      child: pw.Text(
                                                        'Area : ${widget.userLoginResponseModel?.user?.area}',
                                                        style: pw.TextStyle(
                                                            color: PdfColors.black,
                                                            fontWeight: pw.FontWeight.bold),
                                                        maxLines: 3,
                                                        overflow: pw.TextOverflow.span,
                                                      ),
                                                    ),
                                                    pw.SizedBox(height: 10),
                                                  ],
                                                ),
                                                pw.Spacer(),
                                                pw.Column(
                                                  mainAxisSize: pw.MainAxisSize.min,
                                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                                  children: [
                                                    pw.Text('Invoice No.: ${widget.orderModel.invoice}',
                                                      style: pw.TextStyle(
                                                        fontWeight: pw.FontWeight.bold,
                                                      ),),
                                                    // pw.SizedBox(height: 5),
                                                    // pw.Text(
                                                    //   'Sales Person: ${widget.orderModel.}',
                                                    //   style: pw.TextStyle(
                                                    //     fontWeight: pw.FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    // pw.SizedBox(height: 5),
                                                    // pw.Text(
                                                    //   '${widget.orderModel.customer?.phone}',
                                                    //   style: pw.TextStyle(
                                                    //     fontWeight: pw.FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    // pw.SizedBox(height: 5),
                                                    // pw.Text(
                                                    //   '${widget.orderModel.customer?.address}',
                                                    //   style: pw.TextStyle(
                                                    //     fontWeight: pw.FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    pw.SizedBox(height: 5),
                                                    pw.Text(
                                                      'INVOICE DATE : ${DateFormat('d MMM yyyy').format(DateTime.parse(widget.orderModel.createAt))}',
                                                      style: pw.TextStyle(
                                                        fontWeight: pw.FontWeight.bold,
                                                      ),
                                                    ),
                                                    pw.SizedBox(height: 5),
                                                    pw.Text(
                                                      'Invoice Time : ${DateFormat.jm().format(DateTime.parse(widget.orderModel.createAt))}',
                                                      style: pw.TextStyle(
                                                        fontWeight: pw.FontWeight.bold,
                                                      ),
                                                    ),
                                                    pw.SizedBox(height: 5),
                                                    pw.Row(
                                                      children: [
                                                        pw.Text("Status:",
                                                          style: pw.TextStyle(
                                                            fontWeight: pw.FontWeight.bold,
                                                          ),
                                                        ),
                                                        pw.SizedBox(width: 10,),
                                                        pw.Container(
                                                          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                          decoration: pw.BoxDecoration(
                                                              borderRadius: pw.BorderRadius.circular(5),
                                                              color: widget.orderModel.status == 'p'
                                                                  ? const PdfColor.fromInt(0xFFF57C00)
                                                                  : widget.orderModel.status == 'o'
                                                                  ? const PdfColor.fromInt(0xFF1B6AAA)
                                                                  : widget.orderModel.status == 'h'
                                                                  ? const PdfColor.fromInt(0xFf157347)
                                                                  : widget.orderModel.status == 'd'
                                                                  ? const PdfColor.fromInt(0xFFD32F2F)
                                                                  : PdfColors.brown
                                                          ),
                                                          child: pw.Text(
                                                            widget.orderModel.status == 'p'
                                                                ? "Pending"
                                                                : widget.orderModel.status == 'o'
                                                                ? "Ongoing"
                                                                : widget.orderModel.status == 'h'
                                                                ? "Received"
                                                                : widget.orderModel.status == 'd'
                                                                ? "Canceled"
                                                                : '',
                                                            style: pw.TextStyle(color: PdfColors.white, fontSize: 12,
                                                                fontWeight: pw.FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            ),
                                            pw.SizedBox(height: 5 * PdfPageFormat.mm),

                                            pw.Divider(),

                                            pw.SizedBox(height: 5 * PdfPageFormat.mm),

                                            pw.Row(
                                              children: [
                                                pw.Expanded(
                                                  flex: 1,
                                                  child: pw.Container(
                                                    padding: const pw.EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 3),
                                                    decoration: const pw.BoxDecoration(
                                                      color: PdfColor.fromInt(0xFF78359E),
                                                    ),
                                                    alignment: pw.Alignment.center,
                                                    child: pw.SizedBox(
                                                        child: pw.Text(
                                                          "SL.",
                                                          maxLines: 1,
                                                          // overflow: pw.TextOverflow.,
                                                          style: const pw.TextStyle(color: PdfColors.white,fontSize: 11),
                                                        )),
                                                  ),
                                                ),
                                                pw.SizedBox(
                                                  width: 3,
                                                ),
                                                pw.Expanded(
                                                  flex: 2,
                                                  child: pw.Container(
                                                    padding: const pw.EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 3),
                                                    decoration: const pw.BoxDecoration(
                                                      color: PdfColor.fromInt(0xFF78359E),
                                                    ),
                                                    alignment: pw.Alignment.center,
                                                    child: pw.SizedBox(
                                                        child: pw.Text(
                                                          "Description",
                                                          maxLines: 1,
                                                          // overflow: pw.TextOverflow.ellipsis,
                                                          style: const pw.TextStyle(color: PdfColors.white,fontSize: 11),
                                                        )),
                                                  ),
                                                ),
                                                pw.SizedBox(
                                                  width: 3,
                                                ),
                                                pw.Expanded(
                                                  flex: 1,
                                                  child: pw.Container(
                                                    padding: const pw.EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 3),
                                                    decoration: const pw.BoxDecoration(
                                                      color: PdfColor.fromInt(0xFF78359E),
                                                    ),
                                                    alignment: pw.Alignment.center,
                                                    child: pw.SizedBox(
                                                        child: pw.Text(
                                                          "Quantity",
                                                          maxLines: 1,
                                                          // overflow: pw.TextOverflow.ellipsis,
                                                          style: const pw.TextStyle(color: PdfColors.white,fontSize: 11),
                                                        )),
                                                  ),
                                                ),
                                                pw.SizedBox(
                                                  width: 3,
                                                ),
                                                pw.Expanded(
                                                  flex: 1,
                                                  child: pw.Container(
                                                    padding: const pw.EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 3),
                                                    decoration: const pw.BoxDecoration(
                                                      color: PdfColor.fromInt(0xFF78359E),
                                                    ),
                                                    alignment: pw.Alignment.center,
                                                    child: pw.SizedBox(
                                                        child: pw.Text(
                                                          "Unit",
                                                          maxLines: 1,
                                                          // overflow: pw.TextOverflow.ellipsis,
                                                          style: const pw.TextStyle(color: PdfColors.white,fontSize: 11),
                                                        )),
                                                  ),
                                                ),
                                                pw.SizedBox(
                                                  width: 3,
                                                ),
                                                pw.Expanded(
                                                  flex: 1,
                                                  child: pw.Container(
                                                    padding: const pw.EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 3),
                                                    decoration: const pw.BoxDecoration(
                                                      color: PdfColor.fromInt(0xFF78359E),
                                                    ),
                                                    alignment: pw.Alignment.center,
                                                    child: pw.SizedBox(
                                                        child: pw.Text(
                                                          "Price",
                                                          maxLines: 1,
                                                          // overflow: pw.TextOverflow.ellipsis,
                                                          style: const pw.TextStyle(color: PdfColors.white,fontSize: 11),
                                                        )),
                                                  ),
                                                ),
                                                pw.SizedBox(
                                                  width: 3,
                                                ),
                                                pw.Expanded(
                                                  flex: 1,
                                                  child: pw.Container(
                                                    padding: const pw.EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 3),
                                                    decoration: const pw.BoxDecoration(
                                                      color: PdfColor.fromInt(0xFF78359E),
                                                    ),
                                                    alignment: pw.Alignment.center,
                                                    child: pw.SizedBox(
                                                        child: pw.Text(
                                                          "Total",
                                                          maxLines: 1,
                                                          // overflow: pw.TextOverflow.ellipsis,
                                                          style: const pw.TextStyle(color: PdfColors.white,fontSize: 11),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            pw.SizedBox(height: 10),

                                            ...List.generate(state.orderDetailsModel.length, (index){
                                              return pw.Container(
                                                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                                                child: pw.Row(
                                                  children: [
                                                    pw.Expanded(
                                                        flex: 1,
                                                        child: pw.SizedBox(
                                                            child: pw.Text(
                                                              "${index+1}",
                                                              maxLines: 2,
                                                              // style: TextStyle(fontSize: 12),
                                                              // overflow: pw.TextOverflow.ellipsis,
                                                              textAlign: pw.TextAlign.center,
                                                              // style:  pw.TextStyle(fontSize: 10),
                                                            ))
                                                    ),
                                                    pw.SizedBox(
                                                      width: 3,
                                                    ),
                                                    pw.Expanded(
                                                      flex: 2,
                                                      child: pw.SizedBox(
                                                          child: pw.Text(
                                                            state.orderDetailsModel[index].productName,
                                                            maxLines: 1,
                                                            // overflow: pw.TextOverflow.ellipsis,
                                                            // style: pw.TextStyle(fontSize: 10),
                                                            textAlign: pw.TextAlign.center,
                                                          )),
                                                    ),
                                                    pw.SizedBox(
                                                      width: 3,
                                                    ),
                                                    pw.Expanded(
                                                      flex: 1,
                                                      child:  pw.SizedBox(
                                                          child:  pw.Text(
                                                            double.parse(state.orderDetailsModel[index].quantity)
                                                                .toStringAsFixed(0),
                                                            maxLines: 1,
                                                            // style: pw.TextStyle(fontSize: 10),
                                                            // overflow: TextOverflow.ellipsis,
                                                            textAlign: pw.TextAlign.center,
                                                          )),
                                                    ),
                                                    pw.SizedBox(
                                                      width: 3,
                                                    ),
                                                    pw.Expanded(
                                                      flex: 1,
                                                      child: pw.SizedBox(
                                                          child: pw.Text(
                                                            state.orderDetailsModel[index].unitName,
                                                            maxLines: 1,
                                                            // overflow: TextOverflow.ellipsis,
                                                            textAlign: pw.TextAlign.center,
                                                            // style: const TextStyle(fontSize: 10),

                                                          )),
                                                    ),
                                                    pw.SizedBox(
                                                      width: 3,
                                                    ),
                                                    pw.Expanded(
                                                      flex: 1,
                                                      child: pw.SizedBox(
                                                          child: pw.Text(
                                                            state.orderDetailsModel[index].saleRate,
                                                            maxLines: 1,
                                                            // overflow: TextOverflow.ellipsis,
                                                            textAlign: pw.TextAlign.center,
                                                            // style: const TextStyle(fontSize: 10),

                                                          )),
                                                    ),
                                                    pw.SizedBox(
                                                      width: 3,
                                                    ),
                                                    pw.Expanded(
                                                      flex: 1,
                                                      child: pw.SizedBox(
                                                          child: pw.Text(
                                                            state.orderDetailsModel[index].total,
                                                            maxLines: 1,
                                                            // overflow: TextOverflow.ellipsis,
                                                            textAlign: pw.TextAlign.center,
                                                            style: const pw.TextStyle(fontSize: 10),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),

                                            pw.SizedBox(height: 10 * PdfPageFormat.mm),

                                            pw.Text("Subtotal: ${state.result}",
                                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),

                                            pw.SizedBox(height: 20),

                                            pw.Text("Note: ${widget.orderModel.note}",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),

                                            pw.SizedBox(height: 30),

                                            pw.Row(
                                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                children: [
                                                  pw.Text(
                                                      "Received by"
                                                  ),
                                                  pw.Text(
                                                      "Authorized by"
                                                  ),
                                                ]
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Text("** THANK YOU FOR YOUR BUSINESS **",style: pw.TextStyle(fontWeight: pw.FontWeight.bold),),
                                            pw.Divider(),

                                          ];
                                        },
                                        footer: (context) {
                                          return pw.Row(
                                              mainAxisAlignment: pw.MainAxisAlignment.end,
                                              children: [
                                                pw.Text(
                                                    "Developed by: : Link-Up Technologoy"
                                                        "\nContact no: 01911978897"
                                                ),
                                              ]
                                          );
                                        },
                                      ),
                                    );

                                    final bytes = await pdf.save();

                                    SaveFile.saveAndLaunchFile(bytes, '${widget.orderModel.invoice}.pdf', apiLevel, context);

                                  } catch (e) {
                                    print("Error $e ");

                                    apiLevel >= 33 ? ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Already saved in your device"),
                                      ),
                                    ): ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Already saved in your device"),
                                        action: SnackBarAction(
                                          label: "Open",
                                          onPressed: () {
                                            OpenFile.open('/storage/emulated/0/Download/${widget.orderModel.invoice}.pdf');
                                          },
                                        ),
                                      ),
                                    );
                                    //   print("Saved already");
                                  }
                                }
                                else if (storagePermission.isDenied) {
                                  Utils.toastMsg("Required Storage Permission");
                                  openAppSettings();
                                } else if (storagePermission.isPermanentlyDenied) {
                                  await openAppSettings();
                                  // _createPDF();
                                }
                              },
                              label: const Text('Save as PDF'), icon: const Icon(Icons.download),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: redColor,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 5),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          }),
    );
  }
  var converter = NumberToCharacterConverter('en');

  final pdf = pw.Document();
  int apiLevel = 0;

  // Future<void> _createPDF({filename, context, index, dataLength, data}) async {
  //
  //   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   final androidInfo = await deviceInfoPlugin.androidInfo;
  //   apiLevel = androidInfo.version.sdkInt;
  //   PermissionStatus storagePermission;
  //   print("apiLevel $apiLevel");
  //
  //   if (apiLevel >= 33) {
  //     storagePermission = await Permission.manageExternalStorage.request();
  //   } else {
  //     storagePermission = await Permission.storage.request();
  //   }
  //
  //   if (storagePermission == PermissionStatus.granted) {
  //     try {
  //       pdf.addPage(
  //         pw.MultiPage(
  //           pageFormat: PdfPageFormat.a4,
  //           build: (context) {
  //             return [
  //               pw.Container(
  //                 width: double.infinity,
  //                 padding: pw.EdgeInsets.all(10),
  //                 decoration: pw.BoxDecoration(
  //                   color: PdfColors.grey300,
  //                 ),
  //                 child: pw.Text("Customer Invoice",
  //                     style: pw.TextStyle(
  //                         fontWeight: pw.FontWeight.bold,
  //                         fontSize: 18)),
  //               ),
  //
  //               pw.SizedBox(height: 10 * PdfPageFormat.mm),
  //
  //               pw.Row(
  //                 crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                 children: [
  //                   pw.SizedBox(width: 1 * PdfPageFormat.mm),
  //                   pw.Column(
  //                     mainAxisSize: pw.MainAxisSize.min,
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text(
  //                         'Customer Name: ${widget.userLoginResponseModel?.user?.name}',
  //                         style: pw.TextStyle(
  //                             color: PdfColors.black,
  //                             fontWeight: pw.FontWeight.bold),
  //                       ),
  //                       pw.SizedBox(height: 5),
  //                       pw.SizedBox(
  //                         width: 250,
  //                         child: pw.Text(
  //                           'Customer Mobile: ${widget.userLoginResponseModel?.user?.phone}',
  //                           style: pw.TextStyle(
  //                               color: PdfColors.black,
  //                               fontWeight: pw.FontWeight.bold),
  //                           maxLines: 3,
  //                           overflow: pw.TextOverflow.span,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 5),
  //                       pw.SizedBox(
  //                         width: 250,
  //                         child: pw.Text(
  //                           'Customer Email: ${widget.userLoginResponseModel?.user?.customerEmail}',
  //                           style: pw.TextStyle(
  //                               color: PdfColors.black,
  //                               fontWeight: pw.FontWeight.bold),
  //                           maxLines: 3,
  //                           overflow: pw.TextOverflow.span,
  //                         ),
  //                       ),
  //                       pw.SizedBox(
  //                         width: 250,
  //                         child: pw.Text(
  //                           'Area : ${widget.userLoginResponseModel?.user?.area}',
  //                           style: pw.TextStyle(
  //                               color: PdfColors.black,
  //                               fontWeight: pw.FontWeight.bold),
  //                           maxLines: 3,
  //                           overflow: pw.TextOverflow.span,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 5),
  //                       pw.SizedBox(
  //                         width: 250,
  //                         child: pw.Text(
  //                           'Customer Address: : ${widget.userLoginResponseModel?.user?.address}',
  //                           style: pw.TextStyle(
  //                               color: PdfColors.black,
  //                               fontWeight: pw.FontWeight.bold),
  //                           maxLines: 3,
  //                           overflow: pw.TextOverflow.span,
  //                         ),
  //                       ),
  //                       pw.SizedBox(height: 10),
  //                     ],
  //                   ),
  //                   pw.Spacer(),
  //                   pw.Column(
  //                     mainAxisSize: pw.MainAxisSize.min,
  //                     crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                     children: [
  //                       pw.Text('Invoice No.: ${widget.orderModel.invoice}',
  //                         style: pw.TextStyle(
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),),
  //                       // pw.SizedBox(height: 5),
  //                       // pw.Text(
  //                       //   'Sales Person: ${widget.orderModel.}',
  //                       //   style: pw.TextStyle(
  //                       //     fontWeight: pw.FontWeight.bold,
  //                       //   ),
  //                       // ),
  //                       // pw.SizedBox(height: 5),
  //                       // pw.Text(
  //                       //   '${widget.orderModel.customer?.phone}',
  //                       //   style: pw.TextStyle(
  //                       //     fontWeight: pw.FontWeight.bold,
  //                       //   ),
  //                       // ),
  //                       // pw.SizedBox(height: 5),
  //                       // pw.Text(
  //                       //   '${widget.orderModel.customer?.address}',
  //                       //   style: pw.TextStyle(
  //                       //     fontWeight: pw.FontWeight.bold,
  //                       //   ),
  //                       // ),
  //                       pw.SizedBox(height: 5),
  //                       pw.Text(
  //                         'INVOICE DATE : ${DateFormat('d MMM yyyy').format(DateTime.parse(widget.orderModel.createAt))}',
  //                         style: pw.TextStyle(
  //                           fontWeight: pw.FontWeight.bold,
  //                         ),
  //                       ),
  //
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               pw.SizedBox(height: 5 * PdfPageFormat.mm),
  //
  //               pw.Divider(),
  //
  //               pw.SizedBox(height: 10 * PdfPageFormat.mm),
  //
  //               pw.Row(
  //                 children: [
  //                   pw.Expanded(
  //                     flex: 1,
  //                     child: pw.Container(
  //                       padding: const pw.EdgeInsets.symmetric(
  //                           horizontal: 5, vertical: 3),
  //                       decoration: const pw.BoxDecoration(
  //                         color: PdfColor.fromInt(0xFF78359E),
  //                       ),
  //                       alignment: pw.Alignment.center,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             "SL.",
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.,
  //                             style: pw.TextStyle(color: PdfColors.white,fontSize: 11),
  //                           )),
  //                     ),
  //                   ),
  //                   pw.SizedBox(
  //                     width: 3,
  //                   ),
  //                   pw.Expanded(
  //                     flex: 2,
  //                     child: pw.Container(
  //                       padding: pw.EdgeInsets.symmetric(
  //                           horizontal: 5, vertical: 3),
  //                       decoration: pw.BoxDecoration(
  //                         color: PdfColor.fromInt(0xFF78359E),
  //                       ),
  //                       alignment: pw.Alignment.center,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             "Description",
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.ellipsis,
  //                             style: pw.TextStyle(color: PdfColors.white,fontSize: 11),
  //                           )),
  //                     ),
  //                   ),
  //                   pw.SizedBox(
  //                     width: 3,
  //                   ),
  //                   pw.Expanded(
  //                     flex: 1,
  //                     child: pw.Container(
  //                       padding: pw.EdgeInsets.symmetric(
  //                           horizontal: 5, vertical: 3),
  //                       decoration: pw.BoxDecoration(
  //                         color: PdfColor.fromInt(0xFF78359E),
  //                       ),
  //                       alignment: pw.Alignment.center,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             "Quantity",
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.ellipsis,
  //                             style: pw.TextStyle(color: PdfColors.white,fontSize: 11),
  //                           )),
  //                     ),
  //                   ),
  //                   pw.SizedBox(
  //                     width: 3,
  //                   ),
  //                   pw.Expanded(
  //                     flex: 1,
  //                     child: pw.Container(
  //                       padding: pw.EdgeInsets.symmetric(
  //                           horizontal: 5, vertical: 3),
  //                       decoration: pw.BoxDecoration(
  //                         color: PdfColor.fromInt(0xFF78359E),
  //                       ),
  //                       alignment: pw.Alignment.center,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             "Unit",
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.ellipsis,
  //                             style: pw.TextStyle(color: PdfColors.white,fontSize: 11),
  //                           )),
  //                     ),
  //                   ),
  //                   pw.SizedBox(
  //                     width: 3,
  //                   ),
  //                   pw.Expanded(
  //                     flex: 1,
  //                     child: pw.Container(
  //                       padding: pw.EdgeInsets.symmetric(
  //                           horizontal: 5, vertical: 3),
  //                       decoration: pw.BoxDecoration(
  //                         color: PdfColor.fromInt(0xFF78359E),
  //                       ),
  //                       alignment: pw.Alignment.center,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             "Price",
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.ellipsis,
  //                             style: pw.TextStyle(color: PdfColors.white,fontSize: 11),
  //                           )),
  //                     ),
  //                   ),
  //                   pw.SizedBox(
  //                     width: 3,
  //                   ),
  //                   pw.Expanded(
  //                     flex: 1,
  //                     child: pw.Container(
  //                       padding: pw.EdgeInsets.symmetric(
  //                           horizontal: 5, vertical: 3),
  //                       decoration: pw.BoxDecoration(
  //                         color: PdfColor.fromInt(0xFF78359E),
  //                       ),
  //                       alignment: pw.Alignment.center,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             "Total",
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.ellipsis,
  //                             style: pw.TextStyle(color: PdfColors.white,fontSize: 11),
  //                           )),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               pw.SizedBox(height: 10),
  //
  //               ...List.generate(dataLength, (index){
  //                 return pw.Row(
  //                   children: [
  //                     pw.Expanded(
  //                         flex: 1,
  //                         child: pw.SizedBox(
  //                             child: pw.Text(
  //                               "${index+1}",
  //                               maxLines: 2,
  //                               // style: TextStyle(fontSize: 12),
  //                               // overflow: pw.TextOverflow.ellipsis,
  //                               textAlign: pw.TextAlign.center,
  //                               // style:  pw.TextStyle(fontSize: 10),
  //                             ))
  //                     ),
  //                      pw.SizedBox(
  //                       width: 3,
  //                     ),
  //                     pw.Expanded(
  //                       flex: 2,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             data[index].productName,
  //                             maxLines: 1,
  //                             // overflow: pw.TextOverflow.ellipsis,
  //                             // style: pw.TextStyle(fontSize: 10),
  //                             textAlign: pw.TextAlign.center,
  //                           )),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 3,
  //                     ),
  //                     pw.Expanded(
  //                       flex: 1,
  //                       child:  pw.SizedBox(
  //                           child:  pw.Text(
  //                             double.parse(data[index].quantity)
  //                                 .toStringAsFixed(0),
  //                             maxLines: 1,
  //                             // style: pw.TextStyle(fontSize: 10),
  //                             // overflow: TextOverflow.ellipsis,
  //                             textAlign: pw.TextAlign.center,
  //                           )),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 3,
  //                     ),
  //                     pw.Expanded(
  //                       flex: 1,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             data[index].unitName,
  //                             maxLines: 1,
  //                             // overflow: TextOverflow.ellipsis,
  //                             textAlign: pw.TextAlign.center,
  //                             // style: const TextStyle(fontSize: 10),
  //
  //                           )),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 3,
  //                     ),
  //                     pw.Expanded(
  //                       flex: 1,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             data[index].saleRate,
  //                             maxLines: 1,
  //                             // overflow: TextOverflow.ellipsis,
  //                             textAlign: pw.TextAlign.center,
  //                             // style: const TextStyle(fontSize: 10),
  //
  //                           )),
  //                     ),
  //                     pw.SizedBox(
  //                       width: 3,
  //                     ),
  //                     pw.Expanded(
  //                       flex: 1,
  //                       child: pw.SizedBox(
  //                           child: pw.Text(
  //                             data[index].total,
  //                             maxLines: 1,
  //                             // overflow: TextOverflow.ellipsis,
  //                             textAlign: pw.TextAlign.center,
  //                             style: pw.TextStyle(fontSize: 10),
  //                           )),
  //                     ),
  //                   ],
  //                 );
  //               }),
  //
  //
  //               //ROW 1
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.grey200,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Customer Name",style: pw.TextStyle(
  //               //                 fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //                 "${widget.orderModel.customer?.name}")),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 2
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.white,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Ad Title",
  //               //                 style: pw.TextStyle(
  //               //                     fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //               "${widget.orderModel.adModel?.title}",
  //               //             )),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 3
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.grey200,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Category",style: pw.TextStyle(
  //               //                 fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //                 "${widget.orderModel.adModel?.category?.name}")),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 4
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.white,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child:
  //               //             pw.Text("Promotion Name",style: pw.TextStyle(
  //               //                 fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text("${widget.orderModel.promotion?.title}")),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 5
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.grey200,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Order ID",style: pw.TextStyle(
  //               //                 fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //                 "${widget.orderModel.orderId}")),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 6
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.white,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Transaction ID",style: pw.TextStyle(
  //               //                 fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //                 "${widget.orderModel.transactionId}")),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 7
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.grey200,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Amount",style: pw.TextStyle(
  //               //                 fontWeight: pw.FontWeight.bold)
  //               //             )),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //               "${widget.orderModel.amount}",
  //               //             )),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 8
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.white,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Payment Method",
  //               //                 style: pw.TextStyle(
  //               //                     fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //               "${widget.orderModel.paymentProvider}",
  //               //             )),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 9
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.grey200,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Area",
  //               //                 style: pw.TextStyle(
  //               //                     fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //               "${widget.orderModel.customer?.address}",
  //               //             )),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 10
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.white,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Payment Status",
  //               //                 style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //               "${widget.orderModel.paymentStatus}",
  //               //             )),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //               //
  //               // //ROW 11
  //               // pw.Container(
  //               //   padding: const pw.EdgeInsets.all(5),
  //               //   decoration: const pw.BoxDecoration(
  //               //     border: pw.Border(
  //               //       bottom: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       left: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //       right: pw.BorderSide(width: 1, color: PdfColors.grey300),
  //               //     ),
  //               //     color: PdfColors.grey200,
  //               //   ),
  //               //   child: pw.Row(children: [
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerLeft,
  //               //             child: pw.Text("Transaction Date",
  //               //                 style: pw.TextStyle(
  //               //                     fontWeight: pw.FontWeight.bold))),
  //               //         flex: 3),
  //               //     pw.Expanded(
  //               //         child: pw.Container(
  //               //             alignment: pw.Alignment.centerRight,
  //               //             child: pw.Text(
  //               //               "${DateFormat('d MMM yyyy').format(DateTime.parse(widget.orderModel.createdAt))}",
  //               //             )),
  //               //         flex: 3),
  //               //   ]),
  //               // ),
  //             ];
  //           },
  //         ),
  //       );
  //
  //       final bytes = await pdf.save();
  //
  //       SaveFile.saveAndLaunchFile(bytes, '${widget.orderModel.invoice}.pdf', apiLevel, context);
  //
  //     } catch (e) {
  //       print("Error $e ");
  //
  //       apiLevel >= 33 ? ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Already saved in your device"),
  //         ),
  //       ):ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text("Already saved in your device"),
  //           action: SnackBarAction(
  //             label: "Open",
  //             onPressed: () {
  //               OpenFile.open('/storage/emulated/0/Download/${widget.orderModel.invoice}.pdf');
  //             },
  //           ),
  //         ),
  //       );
  //       //   print("Saved already");
  //     }
  //   }
  //   else if (storagePermission.isDenied) {
  //     Utils.toastMsg("Required Storage Permission");
  //     openAppSettings();
  //   } else if (storagePermission.isPermanentlyDenied) {
  //     await openAppSettings();
  //     // _createPDF();
  //   }
  //   // else {
  //   //   print("xxxxxxxxxxxxxxxxxxxxx general xxxxxxxxxxxxxxxxxxxxxxxxxx");
  //   //   Map<Permission, PermissionStatus> statuses = await [
  //   //     Permission.storage,
  //   //   ].request();
  //   //   Future.delayed(const Duration(seconds: 1)).then((value) => _createPDF());
  //   // }
  // }

}
