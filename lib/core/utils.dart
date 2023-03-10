import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/appwrite_constants.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile = await picker.pickImage(source: ImageSource.gallery);
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}



extension EncryptionExtension on String {
  String encrypt() {
    var modulusBytes = base64.decode(AppConstants.publicKeyString);

    final key =
    CryptoUtils.rsaPublicKeyFromDERBytes(Uint8List.fromList(modulusBytes));
    final pem = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(key);
    final publicKey = RSAKeyParser().parse(pem) as RSAPublicKey;

    final encrypter = Encrypter(
      RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1),
    );

    final encrypted = encrypter.encrypt(this);

    return encrypted.base64;
  }
}

