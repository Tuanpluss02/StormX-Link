import 'dart:ui';

// ignore: library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_shortener_flutter/components/item_widget.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:url_shortener_flutter/utils/toast_widget.dart';

Widget recentlyWidget(Size size, Rx<List<Urls>> recentlyUrls) {
  return Container(
      margin: EdgeInsets.only(
        left: size.width * 0.2,
        right: size.width * 0.2,
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
              Container(
                  margin: const EdgeInsets.all(20),
                  child: ListView.builder(
                      itemCount: recentlyUrls.value.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (recentlyUrls.value.isNotEmpty) {
                          final item = recentlyUrls.value[index];
                          return Column(
                            children: [
                              ItemWidget(
                                title: item.shortUrl!,
                                description: item.longUrl!,
                                onCopy: () {
                                  Clipboard.setData(
                                      ClipboardData(text: item.shortUrl));
                                  showNotifier(context, 'Copied to clipboard');
                                },
                                onQrGen: () {
                                  showAnimatedDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext dialogContext) {
                                      return Dialog(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                              height: size.height * 0.7,
                                              width: size.width * 0.3,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 8, sigmaY: 8),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const Text(
                                                            'Scan this QR code to go to the link',
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontFamily:
                                                                    'Atomed'),
                                                          ),
                                                          QrImage(
                                                            data:
                                                                item.shortUrl!,
                                                            version:
                                                                QrVersions.auto,
                                                            size: 400.0,
                                                          ),
                                                          ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black54,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  dialogContext);
                                                            },
                                                            child: const Text(
                                                              'Close',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ))));
                                    },
                                    animationType: DialogTransitionType.size,
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                                onEdit: () {
                                  // handle edit button press
                                },
                                onDelete: () {
                                  showAnimatedDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext dialogContext) {
                                      return Dialog(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                              height: size.height * 0.4,
                                              width: size.width * 0.2,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 8, sigmaY: 8),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const Text(
                                                            'Are you sure you want to delete this link?',
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontFamily:
                                                                    'Atomed'),
                                                          ),
                                                          Row(
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black54,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      dialogContext);
                                                                  Auth().deleteUrl(
                                                                      item
                                                                          .shortname!,
                                                                      recentlyUrls,
                                                                      () {
                                                                    showNotifier(
                                                                        context,
                                                                        'Successfully deleted');
                                                                  }, () {
                                                                    showNotifier(
                                                                        context,
                                                                        'Error: Something went wrong');
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black54,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      dialogContext);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ))));
                                    },
                                    animationType: DialogTransitionType.size,
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                              ),
                              const Divider()
                            ],
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
            ],
          ),
        ),
      ));
}
