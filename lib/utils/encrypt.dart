import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:letzpay/utils/strings.dart';

class Encrypt {
  encryptString(String plainText) async {
    var modulusBytes = base64.decode(publicKeyString);

    final key =
        CryptoUtils.rsaPublicKeyFromDERBytes(Uint8List.fromList(modulusBytes));
    final pem = CryptoUtils.encodeRSAPublicKeyToPemPkcs1(key);
    final publicKey = RSAKeyParser().parse(pem) as RSAPublicKey;

    final encrypter = Encrypter(
      RSA(publicKey: publicKey, encoding: RSAEncoding.PKCS1),
    );

    final encrypted = encrypter.encrypt(plainText);

    return encrypted.base64;
  }

//Not worked on decryption
  // decryptString(var encrypted) async {
  //   final privatePem =
  //       await rootBundle.loadString('assets/file/private_key.pem');
  //   final privateKey = RSAKeyParser().parse(privatePem) as RSAPrivateKey;

  //   final encrypter = Encrypter(RSA(privateKey: privateKey));

  //   final decrypted = encrypter.decrypt(encrypted);

  //   // print(decrypted);
  //   return decrypted;
  // }
}
