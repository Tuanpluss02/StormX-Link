import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_shortener_flutter/components/item_widget.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:url_shortener_flutter/utils/toast_widget.dart';

class RecentlyWidget extends StatefulWidget {
  final Size size;
  final Rx<List<Urls>> recentlyUrls;
  final TextEditingController longUrlController;
  final TextEditingController shortNameController;
  final FocusNode formFocus;
  const RecentlyWidget(
      {super.key,
      required this.size,
      required this.recentlyUrls,
      required this.longUrlController,
      required this.shortNameController,
      required this.formFocus});

  @override
  State<RecentlyWidget> createState() => _RecentlyWidgetState();
}

class _RecentlyWidgetState extends State<RecentlyWidget> {
  void removeItem(int index) {
    widget.recentlyUrls.value.removeAt(index);
    widget.recentlyUrls.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          left: widget.size.width * 0.2,
          right: widget.size.width * 0.2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    'Recently',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Atomed',
                        color: Color.fromARGB(255, 41, 41, 41)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Container(
                      margin: const EdgeInsets.all(20),
                      child: widget.recentlyUrls.value.isEmpty
                          ? const SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                'You have no links yet',
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: 'Atomed'),
                              )))
                          : ListView.builder(
                              itemCount: widget.recentlyUrls.value.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (widget.recentlyUrls.value.isNotEmpty) {
                                  final item = widget.recentlyUrls.value[index];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    onDismissed: (direction) =>
                                        removeItem(index),
                                    onUpdate: (details) => {},
                                    child: Column(
                                      children: [
                                        ItemWidget(
                                          title: item.shortUrl!,
                                          description: item.longUrl!,
                                          onCopy: () {
                                            Clipboard.setData(ClipboardData(
                                                text: item.shortUrl));
                                            showNotifier(
                                                context, 'Copied to clipboard');
                                          },
                                          onQrGen: () {
                                            showAnimatedDialog(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                              context: context,
                                              barrierDismissible: true,
                                              builder:
                                                  (BuildContext dialogContext) {
                                                return Dialog(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Container(
                                                        height:
                                                            widget.size.height *
                                                                0.7,
                                                        width:
                                                            widget.size.width *
                                                                0.3,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                BackdropFilter(
                                                              filter: ImageFilter
                                                                  .blur(
                                                                      sigmaX: 8,
                                                                      sigmaY:
                                                                          8),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    const Text(
                                                                      'Scan this QR code to go to the link',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20.0,
                                                                          fontFamily:
                                                                              'Atomed'),
                                                                    ),
                                                                    QrImage(
                                                                      data: item
                                                                          .shortUrl!,
                                                                      version:
                                                                          QrVersions
                                                                              .auto,
                                                                      size:
                                                                          400.0,
                                                                    ),
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.black54,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            dialogContext);
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Close',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ))));
                                              },
                                              animationType:
                                                  DialogTransitionType.size,
                                              curve: Curves.fastOutSlowIn,
                                              duration:
                                                  const Duration(seconds: 1),
                                            );
                                          },
                                          onEdit: () {
                                            widget.longUrlController.text =
                                                item.longUrl!;
                                            widget.shortNameController.text =
                                                item.shortUrl!;
                                            widget.formFocus.requestFocus();
                                          },
                                          onDelete: () {
                                            showAnimatedDialog(
                                              barrierColor:
                                                  Colors.black.withOpacity(0.5),
                                              context: context,
                                              barrierDismissible: true,
                                              builder:
                                                  (BuildContext dialogContext) {
                                                return Dialog(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Container(
                                                        height:
                                                            widget.size.height *
                                                                0.4,
                                                        width:
                                                            widget.size.width *
                                                                0.2,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                BackdropFilter(
                                                              filter: ImageFilter
                                                                  .blur(
                                                                      sigmaX: 8,
                                                                      sigmaY:
                                                                          8),
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(20),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  // crossAxisAlignment:
                                                                  //     CrossAxisAlignment
                                                                  //         .end,
                                                                  children: [
                                                                    const Center(
                                                                      child:
                                                                          Text(
                                                                        'Are you sure you want to delete this link?',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20.0,
                                                                            fontFamily:
                                                                                'Atomed'),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                136,
                                                                                255,
                                                                                24,
                                                                                24),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(dialogContext);
                                                                            Auth().deleteUrl(
                                                                              item.shortname!,
                                                                              removeItem(index),
                                                                              () {
                                                                                // showNotifier(context, 'Successfully deleted');
                                                                              },
                                                                              () {
                                                                                // showNotifier(context, 'Error: Something went wrong');
                                                                              },
                                                                            );
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Delete',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor: const Color.fromARGB(
                                                                                135,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(dialogContext);
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ))));
                                              },
                                              animationType:
                                                  DialogTransitionType.size,
                                              curve: Curves.fastOutSlowIn,
                                              duration:
                                                  const Duration(seconds: 1),
                                            );
                                          },
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                        child: Text(
                                      'You have no links yet',
                                      style: TextStyle(
                                          fontSize: 20.0, fontFamily: 'Atomed'),
                                    )));
                              })),
                ),
              ],
            ),
          ),
        ));
  }
}
