import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/karyawan.dart';
import 'gaji_api.dart';


String pesanGalat(Object error) =>
    error.toString().replaceFirst('Exception: ', '');

final gajiApiProvider = Provider<GajiApi>((ref) => GajiApi());

final daftarGajiProvider = FutureProvider<List<Karyawan>>(
  (ref) => ref.watch(gajiApiProvider).fetchDaftarGaji(),
);

final gajiDetailProvider = FutureProvider.family<Karyawan, String>(
  (ref, nik) => ref.watch(gajiApiProvider).fetchDetail(nik),
);

class PenggajianState {
  final List<String> diproses; 
  final bool isProcessing;

  const PenggajianState({this.diproses = const [], this.isProcessing = false});

  int get totalDiproses => diproses.length;

  PenggajianState copyWith({List<String>? diproses, bool? isProcessing}) {
    return PenggajianState(
      diproses: diproses ?? this.diproses,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}
class PenggajianNotifier extends Notifier<PenggajianState> {
  @override
  PenggajianState build() => const PenggajianState(); 

  Future<void> prosesSemua(List<Karyawan> daftar) async {
    state = state.copyWith(isProcessing: true);
    await Future.delayed(const Duration(seconds: 1)); 
    if (!ref.mounted) return; 
    state = PenggajianState(
      diproses: [for (final k in daftar) k.nik],
      isProcessing: false,
    );
  }

  void reset() => state = const PenggajianState();
}

final penggajianProvider =
    NotifierProvider<PenggajianNotifier, PenggajianState>(
      PenggajianNotifier.new,
    );
