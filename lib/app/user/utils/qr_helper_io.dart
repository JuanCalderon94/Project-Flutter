import 'dart:typed_data';

Future<void> downloadQr(Uint8List bytes, String filename) async {
  // Descarga/guardar no implementado para plataformas no-web en este helper.
  // Puedes implementar guardado en archivos temporales y compartir usando
  // share_plus en móviles/desktop.
  throw UnimplementedError('downloadQr no implementado para esta plataforma');
}
