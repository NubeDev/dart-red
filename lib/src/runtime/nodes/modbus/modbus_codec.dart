import 'dart:typed_data';

/// Modbus frame encoding/decoding and register ↔ value conversion.
///
/// Supports both TCP (MBAP header) and RTU (CRC16) framing.
class ModbusCodec {
  ModbusCodec._();

  // ---------------------------------------------------------------------------
  // Function codes
  // ---------------------------------------------------------------------------

  static const fcReadCoils = 0x01;
  static const fcReadDiscreteInputs = 0x02;
  static const fcReadHoldingRegisters = 0x03;
  static const fcReadInputRegisters = 0x04;
  static const fcWriteSingleCoil = 0x05;
  static const fcWriteSingleRegister = 0x06;
  static const fcWriteMultipleRegisters = 0x10;

  /// Map register type name → read function code.
  static int functionCodeForRead(String registerType) {
    return switch (registerType) {
      'holding' => fcReadHoldingRegisters,
      'input' => fcReadInputRegisters,
      'coil' => fcReadCoils,
      'discrete' => fcReadDiscreteInputs,
      _ => fcReadHoldingRegisters,
    };
  }

  /// How many 16-bit registers a data type occupies.
  static int registerCount(String dataType) {
    return switch (dataType) {
      'uint16' || 'int16' || 'bool' => 1,
      'uint32' || 'int32' || 'float32' => 2,
      'float64' => 4,
      _ => 1,
    };
  }

  // ---------------------------------------------------------------------------
  // Read request
  // ---------------------------------------------------------------------------

  /// Build a Modbus TCP read request (MBAP header + PDU).
  static Uint8List buildReadRequest({
    required int transactionId,
    required int unitId,
    required int functionCode,
    required int startAddress,
    required int count,
  }) {
    final buf = ByteData(12);
    // MBAP header
    buf.setUint16(0, transactionId); // transaction ID
    buf.setUint16(2, 0); // protocol ID (always 0)
    buf.setUint16(4, 6); // length (unit ID + PDU = 6 bytes)
    buf.setUint8(6, unitId);
    // PDU
    buf.setUint8(7, functionCode);
    buf.setUint16(8, startAddress);
    buf.setUint16(10, count);
    return buf.buffer.asUint8List();
  }

  // ---------------------------------------------------------------------------
  // RTU read request
  // ---------------------------------------------------------------------------

  /// Build a Modbus RTU read request (unitId + PDU + CRC16).
  static Uint8List buildRtuReadRequest({
    required int unitId,
    required int functionCode,
    required int startAddress,
    required int count,
  }) {
    final buf = ByteData(6);
    buf.setUint8(0, unitId);
    buf.setUint8(1, functionCode);
    buf.setUint16(2, startAddress);
    buf.setUint16(4, count);
    return _appendCrc(buf.buffer.asUint8List());
  }

  // ---------------------------------------------------------------------------
  // Write request
  // ---------------------------------------------------------------------------

  /// Build a Modbus TCP write request.
  static Uint8List buildWriteRequest({
    required int transactionId,
    required int unitId,
    required String registerType,
    required int address,
    required String dataType,
    required String byteOrder,
    required dynamic value,
  }) {
    if (registerType == 'coil' || dataType == 'bool') {
      return _buildWriteSingleCoil(transactionId, unitId, address, value);
    }

    final regCount = registerCount(dataType);
    if (regCount == 1) {
      return _buildWriteSingleRegister(
          transactionId, unitId, address, _encodeUint16(value));
    }

    // Multi-register write (FC16)
    final registers = encodeValue(
      value: value,
      dataType: dataType,
      byteOrder: byteOrder,
    );
    return _buildWriteMultipleRegisters(
        transactionId, unitId, address, registers);
  }

  static Uint8List _buildWriteSingleCoil(
      int txId, int unitId, int address, dynamic value) {
    final buf = ByteData(12);
    buf.setUint16(0, txId);
    buf.setUint16(2, 0);
    buf.setUint16(4, 6);
    buf.setUint8(6, unitId);
    buf.setUint8(7, fcWriteSingleCoil);
    buf.setUint16(8, address);
    buf.setUint16(10, _toBool(value) ? 0xFF00 : 0x0000);
    return buf.buffer.asUint8List();
  }

  static Uint8List _buildWriteSingleRegister(
      int txId, int unitId, int address, int value) {
    final buf = ByteData(12);
    buf.setUint16(0, txId);
    buf.setUint16(2, 0);
    buf.setUint16(4, 6);
    buf.setUint8(6, unitId);
    buf.setUint8(7, fcWriteSingleRegister);
    buf.setUint16(8, address);
    buf.setUint16(10, value & 0xFFFF);
    return buf.buffer.asUint8List();
  }

  static Uint8List _buildWriteMultipleRegisters(
      int txId, int unitId, int address, Uint8List registerBytes) {
    final regCount = registerBytes.length ~/ 2;
    final pduLen = 7 + registerBytes.length; // FC + addr(2) + count(2) + byteCount(1) + data
    final totalLen = 7 + pduLen; // MBAP(7) + PDU
    final buf = ByteData(totalLen);
    buf.setUint16(0, txId);
    buf.setUint16(2, 0);
    buf.setUint16(4, pduLen + 1); // length includes unit ID
    buf.setUint8(6, unitId);
    buf.setUint8(7, fcWriteMultipleRegisters);
    buf.setUint16(8, address);
    buf.setUint16(10, regCount);
    buf.setUint8(12, registerBytes.length);
    final result = buf.buffer.asUint8List();
    result.setRange(13, 13 + registerBytes.length, registerBytes);
    return result;
  }

  // ---------------------------------------------------------------------------
  // RTU write request
  // ---------------------------------------------------------------------------

  /// Build a Modbus RTU write request (unitId + PDU + CRC16).
  static Uint8List buildRtuWriteRequest({
    required int unitId,
    required String registerType,
    required int address,
    required String dataType,
    required String byteOrder,
    required dynamic value,
  }) {
    if (registerType == 'coil' || dataType == 'bool') {
      final buf = ByteData(6);
      buf.setUint8(0, unitId);
      buf.setUint8(1, fcWriteSingleCoil);
      buf.setUint16(2, address);
      buf.setUint16(4, _toBool(value) ? 0xFF00 : 0x0000);
      return _appendCrc(buf.buffer.asUint8List());
    }

    final regCount = registerCount(dataType);
    if (regCount == 1) {
      final buf = ByteData(6);
      buf.setUint8(0, unitId);
      buf.setUint8(1, fcWriteSingleRegister);
      buf.setUint16(2, address);
      buf.setUint16(4, _encodeUint16(value));
      return _appendCrc(buf.buffer.asUint8List());
    }

    // Multi-register write (FC16)
    final registers = encodeValue(
      value: value,
      dataType: dataType,
      byteOrder: byteOrder,
    );
    final pduLen = 7 + registers.length; // unitId + FC + addr(2) + count(2) + byteCount + data
    final buf = ByteData(pduLen);
    buf.setUint8(0, unitId);
    buf.setUint8(1, fcWriteMultipleRegisters);
    buf.setUint16(2, address);
    buf.setUint16(4, registers.length ~/ 2);
    buf.setUint8(6, registers.length);
    final frame = buf.buffer.asUint8List();
    frame.setRange(7, 7 + registers.length, registers);
    return _appendCrc(frame);
  }

  // ---------------------------------------------------------------------------
  // RTU response parsing
  // ---------------------------------------------------------------------------

  /// Validate and strip CRC from an RTU response.
  /// Returns the payload (unitId + PDU) or null if CRC is invalid.
  static Uint8List? validateRtuResponse(Uint8List frame) {
    if (frame.length < 4) return null; // minimum: unitId + FC + exCode + CRC(2)
    final payload = frame.sublist(0, frame.length - 2);
    final received = (frame[frame.length - 1] << 8) | frame[frame.length - 2];
    if (crc16(payload) != received) return null;
    return payload;
  }

  // ---------------------------------------------------------------------------
  // CRC16 (Modbus)
  // ---------------------------------------------------------------------------

  /// Standard Modbus CRC16 (poly 0xA001, init 0xFFFF).
  static int crc16(Uint8List data) {
    int crc = 0xFFFF;
    for (final byte in data) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if (crc & 1 != 0) {
          crc = (crc >> 1) ^ 0xA001;
        } else {
          crc >>= 1;
        }
      }
    }
    return crc;
  }

  /// Append CRC16 (little-endian) to an RTU frame.
  static Uint8List _appendCrc(Uint8List frame) {
    final crc = crc16(frame);
    final result = Uint8List(frame.length + 2);
    result.setRange(0, frame.length, frame);
    result[frame.length] = crc & 0xFF; // CRC low
    result[frame.length + 1] = (crc >> 8) & 0xFF; // CRC high
    return result;
  }

  // ---------------------------------------------------------------------------
  // Value decoding (response bytes → Dart value)
  // ---------------------------------------------------------------------------

  /// Decode raw register bytes into a Dart value.
  static dynamic decodeValue({
    required Uint8List data,
    required String dataType,
    required String byteOrder,
    required String registerType,
  }) {
    // Coils / discrete inputs: single bit
    if (registerType == 'coil' || registerType == 'discrete') {
      return data.isNotEmpty && data[0] != 0;
    }

    if (dataType == 'bool') {
      return data.isNotEmpty && data[0] != 0;
    }

    final ordered = _reorder(data, byteOrder);
    final bd = ByteData.sublistView(ordered);

    return switch (dataType) {
      'uint16' => bd.getUint16(0),
      'int16' => bd.getInt16(0),
      'uint32' => bd.getUint32(0),
      'int32' => bd.getInt32(0),
      'float32' => bd.getFloat32(0),
      'float64' => bd.getFloat64(0),
      _ => bd.getUint16(0),
    };
  }

  // ---------------------------------------------------------------------------
  // Value encoding (Dart value → register bytes)
  // ---------------------------------------------------------------------------

  /// Encode a Dart value into register bytes for writing.
  static Uint8List encodeValue({
    required dynamic value,
    required String dataType,
    required String byteOrder,
  }) {
    final numVal = value is num ? value : num.tryParse(value.toString()) ?? 0;
    late final Uint8List raw;

    switch (dataType) {
      case 'uint16':
        raw = Uint8List(2);
        ByteData.sublistView(raw).setUint16(0, numVal.toInt() & 0xFFFF);
      case 'int16':
        raw = Uint8List(2);
        ByteData.sublistView(raw).setInt16(0, numVal.toInt());
      case 'uint32':
        raw = Uint8List(4);
        ByteData.sublistView(raw).setUint32(0, numVal.toInt());
      case 'int32':
        raw = Uint8List(4);
        ByteData.sublistView(raw).setInt32(0, numVal.toInt());
      case 'float32':
        raw = Uint8List(4);
        ByteData.sublistView(raw).setFloat32(0, numVal.toDouble());
      case 'float64':
        raw = Uint8List(8);
        ByteData.sublistView(raw).setFloat64(0, numVal.toDouble());
      default:
        raw = Uint8List(2);
        ByteData.sublistView(raw).setUint16(0, numVal.toInt() & 0xFFFF);
    }

    return _reorder(raw, byteOrder);
  }

  // ---------------------------------------------------------------------------
  // Byte ordering
  // ---------------------------------------------------------------------------

  /// Re-order bytes according to Modbus byte order convention.
  ///
  /// - `big`: standard big-endian (AB CD) — no change
  /// - `little`: little-endian (CD AB) — swap register pairs
  /// - `big-swap`: big-endian word swap (CD AB for 32-bit)
  /// - `little-swap`: little-endian word swap (BA DC for 32-bit)
  static Uint8List _reorder(Uint8List data, String byteOrder) {
    if (data.length <= 2 || byteOrder == 'big') return data;

    final result = Uint8List.fromList(data);
    switch (byteOrder) {
      case 'little':
        // Swap register pairs: [A,B,C,D] → [C,D,A,B]
        for (int i = 0; i < result.length - 2; i += 4) {
          final a = result[i], b = result[i + 1];
          result[i] = result[i + 2];
          result[i + 1] = result[i + 3];
          result[i + 2] = a;
          result[i + 3] = b;
        }
      case 'big-swap':
        // Word swap: [A,B,C,D] → [C,D,A,B]  (same as little for 32-bit)
        for (int i = 0; i < result.length - 2; i += 4) {
          final a = result[i], b = result[i + 1];
          result[i] = result[i + 2];
          result[i + 1] = result[i + 3];
          result[i + 2] = a;
          result[i + 3] = b;
        }
      case 'little-swap':
        // Byte swap within each register: [A,B,C,D] → [B,A,D,C]
        for (int i = 0; i < result.length - 1; i += 2) {
          final a = result[i];
          result[i] = result[i + 1];
          result[i + 1] = a;
        }
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static int _encodeUint16(dynamic value) {
    if (value is int) return value & 0xFFFF;
    if (value is double) return value.toInt() & 0xFFFF;
    final parsed = num.tryParse(value.toString());
    return (parsed?.toInt() ?? 0) & 0xFFFF;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }
}
