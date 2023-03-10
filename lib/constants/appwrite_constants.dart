class AppConstants {
  static const String databaseId = '63ca9fd892b6a9f5e135';
  static const String projectId = '63ca9d4f81ce9074804f';
  static const String endPoint = 'http://YOUR_IP/v1';

  static const String usersCollection = '63cb8ae73960973b0635';
  static const String tweetsCollection = '63cbd6781a8ce89dcb95';
  static const String notificationsCollection = '63cd5ff88b08e40a11bc';

  static const String imagesBucket = '63cbdab48cdbccb6b34e';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';



  static const String publicKeyString =
      "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAm/u8ijcJz+s5mKw+UUY4pUFCRC+WNW44quHkcLqyk+PxIg0X/+oZsF1Q2POG+F/74q5HiS2AQHgoYIIpSMdVbr8X67hRXXZr42MF+ehZewvic1r4ulR2/Zgf/G9oIq0Fs3MqbjBTeiP52tNHDmxsxKverJ4ceqq3g9HTxfr2LxjajzciiuxNiprYSqanKHz04jOIazpmX/f8ztb+OsWQxj3A/D9OnXdJAGHSbAeWQF/ravDN+D0NY3lZk7Vjyz+4oOCr+JxWpjmsMf5BGf7kFzKpwsNg0/qZcVrSI+QcZTeur7U8/m+2e7fcqFZfIVXSn4cFbkM7DtyiE1TjBOSCM7qcmaUoXg3llaqw4w5IcmszWqyXX6QNhXp2EMmfXotZN+eDQSyxRnYuul+WN58fa6PiGQraEgxc6JbKZoPaOnb4x1j+ad7c48mF5TXklWTB05LwBnk2fQhZ/Sejz7x2deUBOQK0mvAKoaNiTR8UMKwrq3QSMqO2XGtrM7z5McGJlZCE91EIhfonehUtjOpCjb/Y3fRWgyc76Oem+eSD093C2KHtgObQjgBdNkHxY8m4T7KRrYKB+Q5eN1KRDZwwIDWobltaGVJFruHPMQlRqABE2zl7TDYcumfD6WOBM70LA286kHSKUSTPBcedmRJzqore66a4kmOvEZwq4sgvlHUCAwEAAQ==";

}
