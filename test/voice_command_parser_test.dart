import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/parsers/voice_command_parser.dart';

void main() {
  group('VoiceCommandParser Tests', () {
    final fixedRefDate = DateTime(2026, 10, 11);

    test('parses delete all history commands correctly', () {
      final inputs = [
        'hapus semua  history saya',
        'hapus semua riwayat',
        'hapus seluruh histori',
        'bersihkan semua history',
        'reset semua transaksi',
        'hapus semua transaksi saya',
      ];

      for (final text in inputs) {
        final res = VoiceCommandParser.parse(text);
        expect(res.isCommand, isTrue, reason: 'Failed for "$text"');
        expect(res.type, VoiceCommandType.deleteAllHistory, reason: 'Type mismatch for "$text"');
      }
    });

    test('parses relative date commands (hari ini & kemarin)', () {
      final resToday = VoiceCommandParser.parse('hapus histori hari ini', fixedRefDate);
      expect(resToday.isCommand, isTrue);
      expect(resToday.type, VoiceCommandType.deleteHistoryByDate);
      expect(resToday.targetDate?.day, 11);
      expect(resToday.targetDate?.month, 10);
      expect(resToday.targetDate?.year, 2026);

      final resYesterday = VoiceCommandParser.parse('hapus riwayat kemarin', fixedRefDate);
      expect(resYesterday.isCommand, isTrue);
      expect(resYesterday.type, VoiceCommandType.deleteHistoryByDate);
      expect(resYesterday.targetDate?.day, 10);
      expect(resYesterday.targetDate?.month, 10);
      expect(resYesterday.targetDate?.year, 2026);
    });

    test('parses explicit date commands with Indonesian months', () {
      final res1 = VoiceCommandParser.parse('hapus histori tanggal 10 oktober', fixedRefDate);
      expect(res1.isCommand, isTrue);
      expect(res1.type, VoiceCommandType.deleteHistoryByDate);
      expect(res1.targetDate?.day, 10);
      expect(res1.targetDate?.month, 10);

      final res2 = VoiceCommandParser.parse('hapus riwayat tgl 25 desember 2026', fixedRefDate);
      expect(res2.isCommand, isTrue);
      expect(res2.type, VoiceCommandType.deleteHistoryByDate);
      expect(res2.targetDate?.day, 25);
      expect(res2.targetDate?.month, 12);
      expect(res2.targetDate?.year, 2026);

      final res3 = VoiceCommandParser.parse('hapus transaksi tanggal 5', fixedRefDate);
      expect(res3.isCommand, isTrue);
      expect(res3.type, VoiceCommandType.deleteHistoryByDate);
      expect(res3.targetDate?.day, 5);
      expect(res3.targetDate?.month, 10);
    });

    test('does not misidentify transactions as commands', () {
      final nonCommands = [
        'matcha 28k',
        'maca 28k dan esteh 3k',
        'dapet duit 30k',
        'dikasi duit 8k',
        'tambahin ke saldo 100k',
        'beli makan siang 25k',
      ];

      for (final text in nonCommands) {
        final res = VoiceCommandParser.parse(text);
        expect(res.isCommand, isFalse, reason: 'Should not be command: "$text"');
      }
    });
  });
}
