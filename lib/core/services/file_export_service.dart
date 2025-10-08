import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import '../constants/app_enums.dart';
import '../../features/budget/data/models/budget_model.dart';
import '../../features/expense/data/models/expense_model.dart';
import '../../features/task/data/models/task_model.dart';
import '../utils/snackbar_helper.dart';

class FileExportService extends GetxController {
  static FileExportService get instance => Get.find<FileExportService>();

  final RxBool isExporting = false.obs;
  final RxString currentStatus = ''.obs;
  final RxDouble progress = 0.0.obs;

  String _toAsciiSafe(String text) {
    // Enhanced Vietnamese to ASCII conversion for better PDF compatibility
    // TODO: Replace with Unicode font support in future versions
    final quickReplacements = {
      'BÁO CÁO NGÂN SÁCH': 'BAO CAO NGAN SACH',
      'BÁO CÁO CHI TIÊU': 'BAO CAO CHI TIEU',
      'BÁO CÁO CÔNG VIỆC': 'BAO CAO CONG VIEC',
      'BÁO CÁO TỔNG HỢP': 'BAO CAO TONG HOP',
      'TIẾN ĐỘ SỬ DỤNG NGÂN SÁCH': 'TIEN DO SU DUNG NGAN SACH',
      'TỔNG QUAN TÀI CHÍNH': 'TONG QUAN TAI CHINH',
      'TỔNG QUAN CÔNG VIỆC': 'TONG QUAN CONG VIEC',
      'TỔNG QUAN CHUNG': 'TONG QUAN CHUNG',
      'CHI TIẾT CÁC KHOẢN CHI TIÊU': 'CHI TIET CAC KHOAN CHI TIEU',
      'CHI TIẾT CÁC CÔNG VIỆC': 'CHI TIET CAC CONG VIEC',
      'Được tạo bởi Task & Expense Manager':
          'Duoc tao boi Task & Expense Manager',
      'Tên ngân sách:': 'Ten ngan sach:',
      'Danh mục:': 'Danh muc:',
      'Tổng ngân sách:': 'Tong ngan sach:',
      'Đã chi tiêu:': 'Da chi tieu:',
      'Còn lại:': 'Con lai:',
      'Tiến độ:': 'Tien do:',
      'Trạng thái:': 'Trang thai:',
      'Ngày bắt đầu:': 'Ngay bat dau:',
      'Ngày kết thúc:': 'Ngay ket thuc:',
      'Đang hoạt động': 'Dang hoat dong',
      'Không hoạt động': 'Khong hoat dong',
      'Tổng thu nhập:': 'Tong thu nhap:',
      'Tổng chi tiêu:': 'Tong chi tieu:',
      'Số dư:': 'So du:',
      'Tiêu đề': 'Tieu de',
      'Hoàn thành': 'Hoan thanh',
      'Chưa hoàn thành': 'Chua hoan thanh',
      'đã sử dụng': 'da su dung',
      'Báo cáo được tạo': 'Bao cao duoc tao',
      'Số tiền dự kiến': 'So tien du kien',
      'Khoảng thời gian': 'Khoang thoi gian',
      'Tỷ lệ sử dụng': 'Ty le su dung',
      'Ngày tạo': 'Ngay tao',
      'Thu nhập': 'Thu nhap',
      'Chi tiêu': 'Chi tieu',
      'Số giao dịch': 'So giao dich',
      'Tài chính ổn định': 'Tai chinh on dinh',
      'Cần tiết kiệm': 'Can tiet kiem',
    };

    String result = text;
    quickReplacements.forEach((vietnamese, ascii) {
      result = result.replaceAll(vietnamese, ascii);
    });

    // Comprehensive Vietnamese diacritic removal
    return result
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ả', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ạ', 'a')
        .replaceAll('ă', 'a')
        .replaceAll('ắ', 'a')
        .replaceAll('ằ', 'a')
        .replaceAll('ẳ', 'a')
        .replaceAll('ẵ', 'a')
        .replaceAll('ặ', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ấ', 'a')
        .replaceAll('ầ', 'a')
        .replaceAll('ẩ', 'a')
        .replaceAll('ẫ', 'a')
        .replaceAll('ậ', 'a')
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ẻ', 'e')
        .replaceAll('ẽ', 'e')
        .replaceAll('ẹ', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ế', 'e')
        .replaceAll('ề', 'e')
        .replaceAll('ể', 'e')
        .replaceAll('ễ', 'e')
        .replaceAll('ệ', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ì', 'i')
        .replaceAll('ỉ', 'i')
        .replaceAll('ĩ', 'i')
        .replaceAll('ị', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('ỏ', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ọ', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ố', 'o')
        .replaceAll('ồ', 'o')
        .replaceAll('ổ', 'o')
        .replaceAll('ỗ', 'o')
        .replaceAll('ộ', 'o')
        .replaceAll('ơ', 'o')
        .replaceAll('ớ', 'o')
        .replaceAll('ờ', 'o')
        .replaceAll('ở', 'o')
        .replaceAll('ỡ', 'o')
        .replaceAll('ợ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('ủ', 'u')
        .replaceAll('ũ', 'u')
        .replaceAll('ụ', 'u')
        .replaceAll('ư', 'u')
        .replaceAll('ứ', 'u')
        .replaceAll('ừ', 'u')
        .replaceAll('ử', 'u')
        .replaceAll('ữ', 'u')
        .replaceAll('ự', 'u')
        .replaceAll('ý', 'y')
        .replaceAll('ỳ', 'y')
        .replaceAll('ỷ', 'y')
        .replaceAll('ỹ', 'y')
        .replaceAll('ỵ', 'y')
        .replaceAll('đ', 'd')
        .replaceAll('Á', 'A')
        .replaceAll('À', 'A')
        .replaceAll('Ả', 'A')
        .replaceAll('Ã', 'A')
        .replaceAll('Ạ', 'A')
        .replaceAll('Ă', 'A')
        .replaceAll('Ắ', 'A')
        .replaceAll('Ằ', 'A')
        .replaceAll('Ẳ', 'A')
        .replaceAll('Ẵ', 'A')
        .replaceAll('Ặ', 'A')
        .replaceAll('Â', 'A')
        .replaceAll('Ấ', 'A')
        .replaceAll('Ầ', 'A')
        .replaceAll('Ẩ', 'A')
        .replaceAll('Ẫ', 'A')
        .replaceAll('Ậ', 'A')
        .replaceAll('É', 'E')
        .replaceAll('È', 'E')
        .replaceAll('Ẻ', 'E')
        .replaceAll('Ẽ', 'E')
        .replaceAll('Ẹ', 'E')
        .replaceAll('Ê', 'E')
        .replaceAll('Ế', 'E')
        .replaceAll('Ề', 'E')
        .replaceAll('Ể', 'E')
        .replaceAll('Ễ', 'E')
        .replaceAll('Ệ', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ì', 'I')
        .replaceAll('Ỉ', 'I')
        .replaceAll('Ĩ', 'I')
        .replaceAll('Ị', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ò', 'O')
        .replaceAll('Ỏ', 'O')
        .replaceAll('Õ', 'O')
        .replaceAll('Ọ', 'O')
        .replaceAll('Ô', 'O')
        .replaceAll('Ố', 'O')
        .replaceAll('Ồ', 'O')
        .replaceAll('Ổ', 'O')
        .replaceAll('Ỗ', 'O')
        .replaceAll('Ộ', 'O')
        .replaceAll('Ơ', 'O')
        .replaceAll('Ớ', 'O')
        .replaceAll('Ờ', 'O')
        .replaceAll('Ở', 'O')
        .replaceAll('Ỡ', 'O')
        .replaceAll('Ợ', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('Ù', 'U')
        .replaceAll('Ủ', 'U')
        .replaceAll('Ũ', 'U')
        .replaceAll('Ụ', 'U')
        .replaceAll('Ư', 'U')
        .replaceAll('Ứ', 'U')
        .replaceAll('Ừ', 'U')
        .replaceAll('Ử', 'U')
        .replaceAll('Ữ', 'U')
        .replaceAll('Ự', 'U')
        .replaceAll('Ý', 'Y')
        .replaceAll('Ỳ', 'Y')
        .replaceAll('Ỷ', 'Y')
        .replaceAll('Ỹ', 'Y')
        .replaceAll('Ỵ', 'Y')
        .replaceAll('Đ', 'D');
  }

  Future<String?> exportBudgetReport({
    required BudgetModel budget,
    required String format,
    bool autoShare = true,
  }) async {
    try {
      isExporting.value = true;
      progress.value = 0.1;
      currentStatus.value = 'Đang chuẩn bị dữ liệu...';

      try {
        await _requestStoragePermission();
      } catch (e) {
        debugPrint('Permission request failed, continuing anyway: $e');
      }
      progress.value = 0.2;

      String? filePath;
      switch (format.toLowerCase()) {
        case 'pdf':
          filePath = await _exportBudgetToPdf(budget);
          break;
        case 'excel':
        case 'xlsx':
          filePath = await _exportBudgetToExcel(budget);
          break;
        case 'csv':
          filePath = await _exportBudgetToCsv(budget);
          break;
        default:
          throw Exception('Định dạng không được hỗ trợ: $format');
      }

      progress.value = 0.9;
      currentStatus.value = 'Hoàn tất export...';

      if (autoShare) {
        await _shareFile(filePath);
      }

      progress.value = 1.0;
      return filePath;
    } catch (e) {
      debugPrint('Export error: $e');

      String errorMessage;
      if (e.toString().contains('Permission')) {
        errorMessage =
            'Không có quyền truy cập bộ nhớ. Vui lòng cấp quyền trong Cài đặt ứng dụng.';
      } else if (e.toString().contains('space') ||
          e.toString().contains('storage')) {
        errorMessage =
            'Không đủ dung lượng lưu trữ. Vui lòng giải phóng bộ nhớ và thử lại.';
      } else if (e.toString().contains('unsupported') ||
          e.toString().contains('operator')) {
        errorMessage =
            'Tính năng này chưa được hỗ trợ trên thiết bị của bạn. Vui lòng sử dụng "Chia sẻ Text".';
      } else {
        errorMessage =
            'Không thể tạo file. Vui lòng thử lại hoặc sử dụng "Chia sẻ Text".';
      }

      throw Exception(errorMessage);
    } finally {
      isExporting.value = false;
      currentStatus.value = '';
      progress.value = 0.0;
    }
  }

  Future<String> _exportBudgetToPdf(BudgetModel budget) async {
    try {
      currentStatus.value = 'Tạo file PDF...';
      this.progress.value = 0.4;

      final pdf = pw.Document();
      final now = DateTime.now();
      final budgetProgress =
          budget.amount > 0 ? (budget.spentAmount / budget.amount * 100) : 0.0;
      final remaining = budget.amount - budget.spentAmount;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    border: pw.Border.all(color: PdfColors.blue200),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _toAsciiSafe('BÁO CÁO NGÂN SÁCH'),
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        _toAsciiSafe(
                            'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(now)}'),
                        style: pw.TextStyle(
                            fontSize: 12, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Container(
                  width: double.infinity,
                  child: pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    children: [
                      _buildTableRow('Tên ngân sách:', budget.name, true),
                      _buildTableRow('Danh mục:',
                          categoryToString(budget.category), false),
                      _buildTableRow(
                          'Tổng ngân sách:',
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                              .format(budget.amount),
                          false),
                      _buildTableRow(
                          'Đã chi tiêu:',
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                              .format(budget.spentAmount),
                          false),
                      _buildTableRow(
                          'Còn lại:',
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
                              .format(remaining),
                          false),
                      _buildTableRow('Tiến độ:',
                          '${budgetProgress.toStringAsFixed(1)}%', false),
                      _buildTableRow(
                          'Trạng thái:',
                          budget.isActive
                              ? 'Đang hoạt động'
                              : 'Không hoạt động',
                          false),
                      _buildTableRow(
                          'Ngày bắt đầu:',
                          DateFormat('dd/MM/yyyy').format(budget.startDate),
                          false),
                      _buildTableRow(
                          'Ngày kết thúc:',
                          DateFormat('dd/MM/yyyy').format(budget.endDate),
                          false),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Container(
                  width: double.infinity,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _toAsciiSafe('TIEN DO SU DUNG NGAN SACH'),
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Container(
                        width: double.infinity,
                        height: 20,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                        ),
                        child: pw.Stack(
                          children: [
                            pw.Container(
                              width: (budgetProgress / 100) * 500,
                              height: 20,
                              color: budgetProgress > 90
                                  ? PdfColors.red
                                  : budgetProgress > 70
                                      ? PdfColors.orange
                                      : PdfColors.green,
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        _toAsciiSafe(
                            '${budgetProgress.toStringAsFixed(1)}% da su dung'),
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Container(
                  width: double.infinity,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    _toAsciiSafe('Duoc tao boi Task & Expense Manager'),
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey500,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      this.progress.value = 0.7;

      final directory = await _getExportDirectory();
      final fileName = _generateFileName('Budget_${budget.name}', 'pdf');
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      debugPrint('Error exporting budget to PDF: $e');
      throw Exception('Không thể tạo file PDF: $e');
    }
  }

  Future<String> _exportBudgetToExcel(BudgetModel budget) async {
    try {
      currentStatus.value = 'Tạo file Excel...';
      this.progress.value = 0.4;

      final excel = Excel.createExcel();
      final sheet = excel['Báo cáo Ngân sách'];

      final now = DateTime.now();
      final budgetProgress =
          budget.amount > 0 ? (budget.spentAmount / budget.amount * 100) : 0.0;
      final remaining = budget.amount - budget.spentAmount;

      final headerStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.blue,
        fontColorHex: ExcelColor.white,
      );

      sheet.cell(CellIndex.indexByString('A1')).value =
          TextCellValue('BÁO CÁO NGÂN SÁCH');
      sheet.cell(CellIndex.indexByString('A1')).cellStyle = headerStyle;

      sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue(
          'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}');

      int row = 3;
      final data = [
        ['Tên ngân sách:', budget.name],
        ['Danh mục:', categoryToString(budget.category)],
        [
          'Tổng ngân sách:',
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
              .format(budget.amount)
        ],
        [
          'Đã chi tiêu:',
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
              .format(budget.spentAmount)
        ],
        [
          'Còn lại:',
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
              .format(remaining)
        ],
        ['Tiến độ (%):', '${budgetProgress.toStringAsFixed(1)}%'],
        ['Trạng thái:', budget.isActive ? 'Đang hoạt động' : 'Không hoạt động'],
        ['Ngày bắt đầu:', DateFormat('dd/MM/yyyy').format(budget.startDate)],
        ['Ngày kết thúc:', DateFormat('dd/MM/yyyy').format(budget.endDate)],
      ];

      for (final item in data) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = TextCellValue(item[0]);
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = TextCellValue(item[1]);
        row++;
      }

      this.progress.value = 0.7;

      final directory = await _getExportDirectory();
      final fileName = _generateFileName('Budget_${budget.name}', 'xlsx');
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(excel.encode()!);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting budget to Excel: $e');
      throw Exception('Không thể tạo file Excel: $e');
    }
  }

  Future<String> _exportBudgetToCsv(BudgetModel budget) async {
    try {
      currentStatus.value = 'Tạo file CSV...';
      this.progress.value = 0.4;

      final now = DateTime.now();
      final budgetProgress =
          budget.amount > 0 ? (budget.spentAmount / budget.amount * 100) : 0.0;
      final remaining = budget.amount - budget.spentAmount;

      final csvData = [
        ['Mục', 'Giá trị'],
        ['Ngày tạo', DateFormat('dd/MM/yyyy HH:mm').format(now)],
        ['Tên ngân sách', budget.name],
        ['Danh mục', categoryToString(budget.category)],
        [
          'Tổng ngân sách',
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
              .format(budget.amount)
        ],
        [
          'Đã chi tiêu',
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
              .format(budget.spentAmount)
        ],
        [
          'Còn lại',
          NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
              .format(remaining)
        ],
        ['Tiến độ (%)', budgetProgress.toStringAsFixed(1)],
        ['Trạng thái', budget.isActive ? 'Đang hoạt động' : 'Không hoạt động'],
        ['Ngày bắt đầu', DateFormat('dd/MM/yyyy').format(budget.startDate)],
        ['Ngày kết thúc', DateFormat('dd/MM/yyyy').format(budget.endDate)],
      ];

      final csvString = const ListToCsvConverter().convert(csvData);

      this.progress.value = 0.7;

      final directory = await _getExportDirectory();
      final fileName = _generateFileName('Budget_${budget.name}', 'csv');
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(csvString, encoding: utf8);

      return file.path;
    } catch (e) {
      debugPrint('Error exporting budget to CSV: $e');
      throw Exception('Không thể tạo file CSV: $e');
    }
  }

  pw.TableRow _buildTableRow(String label, String value, bool isHeader) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          color: isHeader ? PdfColors.grey200 : null,
          child: pw.Text(
            _toAsciiSafe(label),
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: isHeader ? 14 : 12,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            _toAsciiSafe(value),
            style: pw.TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _generateFileName(String baseName, String extension) {
    final now = DateTime.now();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);
    final cleanName =
        baseName.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
    return '${cleanName}_$timestamp.$extension';
  }

  Future<Directory> _getExportDirectory() async {
    try {
      if (kIsWeb) {
        throw UnsupportedError('File export not supported on web platform');
      }

      try {
        if (!kIsWeb && Platform.isAndroid) {
          try {
            final externalDir = await getExternalStorageDirectory();
            if (externalDir != null && await externalDir.exists()) {
              final exportDir =
                  Directory('${externalDir.path}/TaskExpenseManager/Exports');
              await exportDir.create(recursive: true);
              return exportDir;
            }
          } catch (e) {
            debugPrint('External storage not available: $e');
          }
        }
      } catch (e) {
        debugPrint('Platform detection failed, using fallback: $e');
      }

      try {
        final documentsDir = await getApplicationDocumentsDirectory();
        final exportDir =
            Directory('${documentsDir.path}/TaskExpenseManager/Exports');
        await exportDir.create(recursive: true);
        return exportDir;
      } catch (e) {
        debugPrint('Documents directory failed: $e');
      }

      try {
        final tempDir = await getTemporaryDirectory();
        final exportDir = Directory('${tempDir.path}/Exports');
        await exportDir.create(recursive: true);
        return exportDir;
      } catch (e) {
        debugPrint('Temp directory failed: $e');
      }

      throw UnsupportedError('Cannot create export directory on this platform');
    } catch (e) {
      debugPrint('Error creating export directory: $e');
      throw UnsupportedError(
          'Export không được hỗ trợ trên thiết bị này. Vui lòng sử dụng "Chia sẻ Text".');
    }
  }

  Future<void> _requestStoragePermission() async {
    try {
      if (kIsWeb) {
        return;
      }

      try {
        if (!kIsWeb && Platform.isAndroid) {
          final status = await Permission.storage.status;
          if (!status.isGranted) {
            final result = await Permission.storage.request();
            if (!result.isGranted) {
              debugPrint('Storage permission denied');
              SnackbarHelper.showError(
                  'Vui lòng cấp quyền truy cập bộ nhớ để lưu file');
              return; // Dừng lại nếu không có quyền
            } else {
              debugPrint('Storage permission granted');
            }
          } else {
            debugPrint('Storage permission already granted');
          }
        }
      } catch (e) {
        debugPrint('Platform-specific permission request failed: $e');
      }
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
  }

  Future<void> _shareFile(String filePath) async {
    currentStatus.value = 'Chia sẻ file...';
    try {
      if (await File(filePath).exists()) {
        try {
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
            final file = XFile(filePath);
            await Share.shareXFiles(
              [file],
              text: 'Báo cáo được tạo từ Task & Expense Manager',
            );
          } else {
            await Share.share(
              'Báo cáo đã được lưu tại: $filePath',
              subject: 'Báo cáo Task & Expense Manager',
            );
          }
        } catch (e) {
          debugPrint('Platform-specific sharing failed: $e');
          await Share.share(
            'Báo cáo đã được lưu tại: ${filePath.split('/').last}',
            subject: 'Báo cáo Task & Expense Manager',
          );
        }
      } else {
        throw Exception('File không tồn tại: $filePath');
      }
    } catch (e) {
      debugPrint('Error sharing file: $e');
      SnackbarHelper.showInfo(
          'File đã được lưu tại: ${filePath.split('/').last}');
    }
  }

  Future<void> fallbackToTextShare(BudgetModel budget) async {
    try {
      final now = DateTime.now();
      final progress =
          budget.amount > 0 ? (budget.spentAmount / budget.amount * 100) : 0.0;
      final remaining = budget.amount - budget.spentAmount;

      final textReport = '''
💰 BÁO CÁO NGÂN SÁCH
━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}
📝 Tên: ${budget.name}
🏷️ Danh mục: ${categoryToString(budget.category)}
💵 Tổng ngân sách: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(budget.amount)}
💸 Đã chi tiêu: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(budget.spentAmount)}
💰 Còn lại: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ').format(remaining)}
📊 Tiến độ: ${progress.toStringAsFixed(1)}%
📈 Trạng thái: ${budget.isActive ? 'Đang hoạt động' : 'Không hoạt động'}
📅 Bắt đầu: ${DateFormat('dd/MM/yyyy').format(budget.startDate)}
📅 Kết thúc: ${DateFormat('dd/MM/yyyy').format(budget.endDate)}

──────────────────────────────────
Được tạo bởi Task & Expense Manager
''';

      await Share.share(textReport,
          subject: 'Báo cáo Ngân sách: ${budget.name}');
      SnackbarHelper.showSuccess('Báo cáo đã được chia sẻ dưới dạng text');
    } catch (e) {
      SnackbarHelper.showError('Không thể chia sẻ: $e');
    }
  }

  Future<void> showExportOptionsDialog({
    required BudgetModel budget,
    List<String> availableFormats = const ['pdf', 'excel', 'csv'],
  }) async {
    String selectedFormat = availableFormats.first;
    bool autoShare = true;

    await Get.dialog(
      AlertDialog(
        title: const Text('Xuất báo cáo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedFormat,
              decoration: const InputDecoration(
                labelText: 'Định dạng file',
                border: OutlineInputBorder(),
              ),
              items: availableFormats.map((format) {
                final displayName = {
                      'pdf': 'PDF',
                      'excel': 'Excel',
                      'csv': 'CSV',
                    }[format] ??
                    format;

                return DropdownMenuItem(
                  value: format,
                  child: Text(displayName),
                );
              }).toList(),
              onChanged: (value) => selectedFormat = value ?? selectedFormat,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Tự động chia sẻ sau khi export'),
              value: autoShare,
              onChanged: (value) => autoShare = value ?? true,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await exportBudgetReport(
                budget: budget,
                format: selectedFormat,
                autoShare: autoShare,
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<String?> exportExpenseReport({
    required List<ExpenseModel> expenses,
    required double totalExpense,
    required double totalIncome,
    required String format,
    bool autoShare = true,
  }) async {
    try {
      isExporting.value = true;
      currentStatus.value = 'Đang chuẩn bị export báo cáo chi tiêu...';
      progress.value = 0.0;

      await _requestStoragePermission();
      progress.value = 0.2;

      String? filePath;
      switch (format.toLowerCase()) {
        case 'pdf':
          filePath =
              await _exportExpensesToPdf(expenses, totalExpense, totalIncome);
          break;
        case 'excel':
        case 'xlsx':
          filePath =
              await _exportExpensesToExcel(expenses, totalExpense, totalIncome);
          break;
        case 'csv':
          filePath =
              await _exportExpensesToCsv(expenses, totalExpense, totalIncome);
          break;
        default:
          throw Exception('Format không được hỗ trợ: $format');
      }

      progress.value = 0.9;
      currentStatus.value = 'Hoàn tất export...';

      if (autoShare) {
        await _shareFile(filePath);
      }

      progress.value = 1.0;
      return filePath;
    } catch (e) {
      debugPrint('Error exporting expense report: $e');
      throw Exception('Không thể export báo cáo chi tiêu: ${e.toString()}');
    } finally {
      isExporting.value = false;
    }
  }

  Future<String?> exportTaskReport({
    required List<TaskModel> tasks,
    required String format,
    bool autoShare = true,
  }) async {
    try {
      isExporting.value = true;
      currentStatus.value = 'Đang chuẩn bị export báo cáo công việc...';
      progress.value = 0.0;

      await _requestStoragePermission();
      progress.value = 0.2;

      String? filePath;
      switch (format.toLowerCase()) {
        case 'pdf':
          filePath = await _exportTasksToPdf(tasks);
          break;
        case 'excel':
        case 'xlsx':
          filePath = await _exportTasksToExcel(tasks);
          break;
        case 'csv':
          filePath = await _exportTasksToCsv(tasks);
          break;
        default:
          throw Exception('Format không được hỗ trợ: $format');
      }

      progress.value = 0.9;
      currentStatus.value = 'Hoàn tất export...';

      if (autoShare) {
        await _shareFile(filePath);
      }

      progress.value = 1.0;
      return filePath;
    } catch (e) {
      debugPrint('Error exporting task report: $e');
      throw Exception('Không thể export báo cáo công việc: ${e.toString()}');
    } finally {
      isExporting.value = false;
    }
  }

  Future<String?> exportFullReport({
    required List<ExpenseModel> expenses,
    required List<TaskModel> tasks,
    required List<BudgetModel> budgets,
    required String format,
    bool autoShare = true,
  }) async {
    try {
      isExporting.value = true;
      currentStatus.value = 'Đang chuẩn bị export báo cáo tổng hợp...';
      progress.value = 0.0;

      await _requestStoragePermission();
      progress.value = 0.2;

      String? filePath;
      switch (format.toLowerCase()) {
        case 'pdf':
          filePath = await _exportFullReportToPdf(expenses, tasks, budgets);
          break;
        case 'excel':
        case 'xlsx':
          filePath = await _exportFullReportToExcel(expenses, tasks, budgets);
          break;
        case 'csv':
          filePath = await _exportFullReportToCsv(expenses, tasks, budgets);
          break;
        default:
          throw Exception('Format không được hỗ trợ: $format');
      }

      progress.value = 0.9;
      currentStatus.value = 'Hoàn tất export...';

      if (autoShare) {
        await _shareFile(filePath);
      }

      progress.value = 1.0;
      return filePath;
    } catch (e) {
      debugPrint('Error exporting full report: $e');
      throw Exception('Không thể export báo cáo tổng hợp: ${e.toString()}');
    } finally {
      isExporting.value = false;
    }
  }

  Future<String> _exportExpensesToPdf(List<ExpenseModel> expenses,
      double totalExpense, double totalIncome) async {
    currentStatus.value = 'Tạo PDF báo cáo chi tiêu...';
    progress.value = 0.3;

    final pdf = pw.Document();
    final now = DateTime.now();
    final formatter = NumberFormat('#,##0', 'vi_VN');
    final balance = totalIncome - totalExpense;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                _toAsciiSafe('BAO CAO CHI TIEU'),
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 16),
              child: pw.Text(
                'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('TỔNG QUAN TÀI CHÍNH',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tổng thu nhập:'),
                      pw.Text('${formatter.format(totalIncome)} VNĐ',
                          style: pw.TextStyle(color: PdfColors.green)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tổng chi tiêu:'),
                      pw.Text('${formatter.format(totalExpense)} VNĐ',
                          style: pw.TextStyle(color: PdfColors.red)),
                    ],
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Số dư:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                        '${formatter.format(balance)} VNĐ',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: balance >= 0 ? PdfColors.green : PdfColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('CHI TIẾT CÁC KHOẢN CHI TIÊU',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            if (expenses.isNotEmpty) ...[
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Ngày',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Tiêu đề',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Danh mục',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Số tiền',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...expenses.map((expense) => pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(DateFormat('dd/MM/yyyy')
                                  .format(expense.date))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(expense.title)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(expense.category)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                  '${formatter.format(expense.amount)} VNĐ')),
                        ],
                      )),
                ],
              ),
            ] else ...[
              pw.Text('Không có dữ liệu chi tiêu'),
            ],
            pw.SizedBox(height: 20),
            pw.Text(
              'Báo cáo được tạo bởi Task & Expense Manager',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ];
        },
      ),
    );

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/expense_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportExpensesToExcel(List<ExpenseModel> expenses,
      double totalExpense, double totalIncome) async {
    currentStatus.value = 'Tạo Excel báo cáo chi tiêu...';
    progress.value = 0.3;

    final excel = Excel.createExcel();
    final sheet = excel['Báo cáo Chi tiêu'];
    final now = DateTime.now();
    final formatter = NumberFormat('#,##0', 'vi_VN');

    sheet.cell(CellIndex.indexByString('A1')).value =
        TextCellValue('BÁO CÁO CHI TIÊU');
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
        'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}');

    sheet.cell(CellIndex.indexByString('A4')).value =
        TextCellValue('TỔNG QUAN TÀI CHÍNH');
    sheet.cell(CellIndex.indexByString('A5')).value =
        TextCellValue('Tổng thu nhập:');
    sheet.cell(CellIndex.indexByString('B5')).value =
        TextCellValue('${formatter.format(totalIncome)} VNĐ');
    sheet.cell(CellIndex.indexByString('A6')).value =
        TextCellValue('Tổng chi tiêu:');
    sheet.cell(CellIndex.indexByString('B6')).value =
        TextCellValue('${formatter.format(totalExpense)} VNĐ');
    sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue('Số dư:');
    sheet.cell(CellIndex.indexByString('B7')).value =
        TextCellValue('${formatter.format(totalIncome - totalExpense)} VNĐ');

    int row = 9;
    sheet.cell(CellIndex.indexByString('A$row')).value =
        TextCellValue('CHI TIẾT CÁC KHOẢN CHI TIÊU');
    row += 2;

    if (expenses.isNotEmpty) {
      sheet.cell(CellIndex.indexByString('A$row')).value =
          TextCellValue('Ngày');
      sheet.cell(CellIndex.indexByString('B$row')).value =
          TextCellValue('Tiêu đề');
      sheet.cell(CellIndex.indexByString('C$row')).value =
          TextCellValue('Danh mục');
      sheet.cell(CellIndex.indexByString('D$row')).value =
          TextCellValue('Số tiền');
      row++;

      for (final expense in expenses) {
        sheet.cell(CellIndex.indexByString('A$row')).value =
            TextCellValue(DateFormat('dd/MM/yyyy').format(expense.date));
        sheet.cell(CellIndex.indexByString('B$row')).value =
            TextCellValue(expense.title);
        sheet.cell(CellIndex.indexByString('C$row')).value =
            TextCellValue(expense.category);
        sheet.cell(CellIndex.indexByString('D$row')).value =
            TextCellValue('${formatter.format(expense.amount)} VNĐ');
        row++;
      }
    } else {
      sheet.cell(CellIndex.indexByString('A$row')).value =
          TextCellValue('Không có dữ liệu chi tiêu');
    }

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/expense_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.xlsx';

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportExpensesToCsv(List<ExpenseModel> expenses,
      double totalExpense, double totalIncome) async {
    currentStatus.value = 'Tạo CSV báo cáo chi tiêu...';
    progress.value = 0.3;

    final now = DateTime.now();
    final formatter = NumberFormat('#,##0', 'vi_VN');

    List<List<dynamic>> rows = [
      ['BÁO CÁO CHI TIÊU'],
      ['Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}'],
      [],
      ['TỔNG QUAN TÀI CHÍNH'],
      ['Tổng thu nhập:', '${formatter.format(totalIncome)} VNĐ'],
      ['Tổng chi tiêu:', '${formatter.format(totalExpense)} VNĐ'],
      ['Số dư:', '${formatter.format(totalIncome - totalExpense)} VNĐ'],
      [],
      ['CHI TIẾT CÁC KHOẢN CHI TIÊU'],
      ['Ngày', 'Tiêu đề', 'Danh mục', 'Số tiền'],
    ];

    if (expenses.isNotEmpty) {
      for (final expense in expenses) {
        rows.add([
          DateFormat('dd/MM/yyyy').format(expense.date),
          expense.title,
          expense.category,
          '${formatter.format(expense.amount)} VNĐ',
        ]);
      }
    } else {
      rows.add(['Không có dữ liệu chi tiêu']);
    }

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/expense_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';

    final csvData = const ListToCsvConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csvData, encoding: utf8);

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportTasksToPdf(List<TaskModel> tasks) async {
    currentStatus.value = 'Tạo PDF báo cáo công việc...';
    progress.value = 0.3;

    final pdf = pw.Document();
    final now = DateTime.now();
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'BÁO CÁO CÔNG VIỆC',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 16),
              child: pw.Text(
                'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('TỔNG QUAN CÔNG VIỆC',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tổng số công việc:'),
                      pw.Text('${tasks.length}'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Đã hoàn thành:'),
                      pw.Text('$completedTasks',
                          style: pw.TextStyle(color: PdfColors.green)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Chưa hoàn thành:'),
                      pw.Text('$pendingTasks',
                          style: pw.TextStyle(color: PdfColors.orange)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tỷ lệ hoàn thành:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          '${tasks.isEmpty ? 0 : (completedTasks / tasks.length * 100).toStringAsFixed(1)}%'),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('CHI TIẾT CÁC CÔNG VIỆC',
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            if (tasks.isNotEmpty) ...[
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Tiêu đề',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Danh mục',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Hạn',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Trạng thái',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  ...tasks.map((task) => pw.TableRow(
                        children: [
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(task.title)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(task.category)),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(DateFormat('dd/MM/yyyy')
                                  .format(task.dueDate))),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(task.isCompleted
                                  ? 'Hoàn thành'
                                  : 'Chưa hoàn thành')),
                        ],
                      )),
                ],
              ),
            ] else ...[
              pw.Text('Không có dữ liệu công việc'),
            ],
          ];
        },
      ),
    );

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/task_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportTasksToExcel(List<TaskModel> tasks) async {
    currentStatus.value = 'Tạo Excel báo cáo công việc...';
    progress.value = 0.3;

    final excel = Excel.createExcel();
    final sheet = excel['Báo cáo Công việc'];
    final now = DateTime.now();
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;

    sheet.cell(CellIndex.indexByString('A1')).value =
        TextCellValue('BÁO CÁO CÔNG VIỆC');
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
        'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}');

    sheet.cell(CellIndex.indexByString('A4')).value =
        TextCellValue('TỔNG QUAN CÔNG VIỆC');
    sheet.cell(CellIndex.indexByString('A5')).value =
        TextCellValue('Tổng số công việc:');
    sheet.cell(CellIndex.indexByString('B5')).value =
        IntCellValue(tasks.length);
    sheet.cell(CellIndex.indexByString('A6')).value =
        TextCellValue('Đã hoàn thành:');
    sheet.cell(CellIndex.indexByString('B6')).value =
        IntCellValue(completedTasks);
    sheet.cell(CellIndex.indexByString('A7')).value =
        TextCellValue('Chưa hoàn thành:');
    sheet.cell(CellIndex.indexByString('B7')).value =
        IntCellValue(pendingTasks);
    sheet.cell(CellIndex.indexByString('A8')).value =
        TextCellValue('Tỷ lệ hoàn thành:');
    sheet.cell(CellIndex.indexByString('B8')).value = TextCellValue(
        '${tasks.isEmpty ? 0 : (completedTasks / tasks.length * 100).toStringAsFixed(1)}%');

    int row = 10;
    sheet.cell(CellIndex.indexByString('A$row')).value =
        TextCellValue('CHI TIẾT CÁC CÔNG VIỆC');
    row += 2;

    if (tasks.isNotEmpty) {
      sheet.cell(CellIndex.indexByString('A$row')).value =
          TextCellValue('Tiêu đề');
      sheet.cell(CellIndex.indexByString('B$row')).value =
          TextCellValue('Danh mục');
      sheet.cell(CellIndex.indexByString('C$row')).value = TextCellValue('Hạn');
      sheet.cell(CellIndex.indexByString('D$row')).value =
          TextCellValue('Trạng thái');
      row++;

      for (final task in tasks) {
        sheet.cell(CellIndex.indexByString('A$row')).value =
            TextCellValue(task.title);
        sheet.cell(CellIndex.indexByString('B$row')).value =
            TextCellValue(task.category);
        sheet.cell(CellIndex.indexByString('C$row')).value =
            TextCellValue(DateFormat('dd/MM/yyyy').format(task.dueDate));
        sheet.cell(CellIndex.indexByString('D$row')).value =
            TextCellValue(task.isCompleted ? 'Hoàn thành' : 'Chưa hoàn thành');
        row++;
      }
    } else {
      sheet.cell(CellIndex.indexByString('A$row')).value =
          TextCellValue('Không có dữ liệu công việc');
    }

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/task_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.xlsx';

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportTasksToCsv(List<TaskModel> tasks) async {
    currentStatus.value = 'Tạo CSV báo cáo công việc...';
    progress.value = 0.3;

    final now = DateTime.now();
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final pendingTasks = tasks.length - completedTasks;

    List<List<dynamic>> rows = [
      ['BÁO CÁO CÔNG VIỆC'],
      ['Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}'],
      [],
      ['TỔNG QUAN CÔNG VIỆC'],
      ['Tổng số công việc:', tasks.length],
      ['Đã hoàn thành:', completedTasks],
      ['Chưa hoàn thành:', pendingTasks],
      [
        'Tỷ lệ hoàn thành:',
        '${tasks.isEmpty ? 0 : (completedTasks / tasks.length * 100).toStringAsFixed(1)}%'
      ],
      [],
      ['CHI TIẾT CÁC CÔNG VIỆC'],
      ['Tiêu đề', 'Danh mục', 'Hạn', 'Trạng thái'],
    ];

    if (tasks.isNotEmpty) {
      for (final task in tasks) {
        rows.add([
          task.title,
          task.category,
          DateFormat('dd/MM/yyyy').format(task.dueDate),
          task.isCompleted ? 'Hoàn thành' : 'Chưa hoàn thành',
        ]);
      }
    }

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/task_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';

    final csvData = const ListToCsvConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csvData, encoding: utf8);

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportFullReportToPdf(List<ExpenseModel> expenses,
      List<TaskModel> tasks, List<BudgetModel> budgets) async {
    currentStatus.value = 'Tạo PDF báo cáo tổng hợp...';
    progress.value = 0.3;

    final pdf = pw.Document();
    final now = DateTime.now();
    final formatter = NumberFormat('#,##0', 'vi_VN');

    final totalExpense =
        expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final totalIncome = expenses
        .where((e) => e.incomeType != IncomeType.none)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final activeBudgets = budgets.where((b) => b.isActive).length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'BÁO CÁO TỔNG HỢP',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 16),
              child: pw.Text(
                'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(border: pw.Border.all()),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('TỔNG QUAN CHUNG',
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tổng thu nhập:'),
                      pw.Text('${formatter.format(totalIncome)} VNĐ',
                          style: pw.TextStyle(color: PdfColors.green)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tổng chi tiêu:'),
                      pw.Text('${formatter.format(totalExpense)} VNĐ',
                          style: pw.TextStyle(color: PdfColors.red)),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Số dư:'),
                      pw.Text(
                          '${formatter.format(totalIncome - totalExpense)} VNĐ'),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tổng công việc:'),
                      pw.Text('${tasks.length}'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Công việc hoàn thành:'),
                      pw.Text('$completedTasks'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Ngân sách đang hoạt động:'),
                      pw.Text('$activeBudgets'),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Báo cáo được tạo bởi Task & Expense Manager',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ];
        },
      ),
    );

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/full_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportFullReportToExcel(List<ExpenseModel> expenses,
      List<TaskModel> tasks, List<BudgetModel> budgets) async {
    currentStatus.value = 'Tạo Excel báo cáo tổng hợp...';
    progress.value = 0.3;

    final excel = Excel.createExcel();
    final sheet = excel['Báo cáo Tổng hợp'];
    final now = DateTime.now();
    final formatter = NumberFormat('#,##0', 'vi_VN');

    final totalExpense =
        expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final totalIncome = expenses
        .where((e) => e.incomeType != IncomeType.none)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final activeBudgets = budgets.where((b) => b.isActive).length;

    sheet.cell(CellIndex.indexByString('A1')).value =
        TextCellValue('BÁO CÁO TỔNG HỢP');
    sheet.cell(CellIndex.indexByString('A2')).value = TextCellValue(
        'Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}');

    sheet.cell(CellIndex.indexByString('A4')).value =
        TextCellValue('TỔNG QUAN CHUNG');
    sheet.cell(CellIndex.indexByString('A5')).value =
        TextCellValue('Tổng thu nhập:');
    sheet.cell(CellIndex.indexByString('B5')).value =
        TextCellValue('${formatter.format(totalIncome)} VNĐ');
    sheet.cell(CellIndex.indexByString('A6')).value =
        TextCellValue('Tổng chi tiêu:');
    sheet.cell(CellIndex.indexByString('B6')).value =
        TextCellValue('${formatter.format(totalExpense)} VNĐ');
    sheet.cell(CellIndex.indexByString('A7')).value = TextCellValue('Số dư:');
    sheet.cell(CellIndex.indexByString('B7')).value =
        TextCellValue('${formatter.format(totalIncome - totalExpense)} VNĐ');
    sheet.cell(CellIndex.indexByString('A9')).value =
        TextCellValue('Tổng công việc:');
    sheet.cell(CellIndex.indexByString('B9')).value =
        IntCellValue(tasks.length);
    sheet.cell(CellIndex.indexByString('A10')).value =
        TextCellValue('Công việc hoàn thành:');
    sheet.cell(CellIndex.indexByString('B10')).value =
        IntCellValue(completedTasks);
    sheet.cell(CellIndex.indexByString('A11')).value =
        TextCellValue('Ngân sách đang hoạt động:');
    sheet.cell(CellIndex.indexByString('B11')).value =
        IntCellValue(activeBudgets);

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/full_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.xlsx';

    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);

    progress.value = 0.8;
    return filePath;
  }

  Future<String> _exportFullReportToCsv(List<ExpenseModel> expenses,
      List<TaskModel> tasks, List<BudgetModel> budgets) async {
    currentStatus.value = 'Tạo CSV báo cáo tổng hợp...';
    progress.value = 0.3;

    final now = DateTime.now();
    final formatter = NumberFormat('#,##0', 'vi_VN');

    final totalExpense =
        expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final totalIncome = expenses
        .where((e) => e.incomeType != IncomeType.none)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final activeBudgets = budgets.where((b) => b.isActive).length;

    List<List<dynamic>> rows = [
      ['BÁO CÁO TỔNG HỢP'],
      ['Ngày tạo: ${DateFormat('dd/MM/yyyy HH:mm').format(now)}'],
      [],
      ['TỔNG QUAN CHUNG'],
      ['Tổng thu nhập:', '${formatter.format(totalIncome)} VNĐ'],
      ['Tổng chi tiêu:', '${formatter.format(totalExpense)} VNĐ'],
      ['Số dư:', '${formatter.format(totalIncome - totalExpense)} VNĐ'],
      [],
      ['Tổng công việc:', tasks.length],
      ['Công việc hoàn thành:', completedTasks],
      ['Ngân sách đang hoạt động:', activeBudgets],
    ];

    progress.value = 0.7;
    final directory = await _getExportDirectory();
    final filePath =
        '${directory.path}/full_report_${DateFormat('yyyyMMdd_HHmmss').format(now)}.csv';

    final csvData = const ListToCsvConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csvData, encoding: utf8);

    progress.value = 0.8;
    return filePath;
  }
}
