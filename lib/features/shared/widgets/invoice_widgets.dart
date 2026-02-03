import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import 'payment_widgets.dart';

/// Invoice and Receipt Widgets
///
/// Provides components for displaying and generating invoices/receipts:
/// - Invoice header
/// - Line items
/// - Totals calculation
/// - Receipt summary
/// - Print/download actions
///
/// Backend Integration TODO:
/// ```dart
/// // Generate PDF receipts
/// import 'package:pdf/pdf.dart';
/// import 'package:pdf/widgets.dart' as pw;
/// import 'package:printing/printing.dart';
///
/// class InvoiceService {
///   Future<void> generatePDF(Invoice invoice) async {
///     final pdf = pw.Document();
///
///     pdf.addPage(
///       pw.Page(
///         build: (context) => pw.Column(
///           children: [
///             pw.Text('Invoice #${invoice.id}'),
///             pw.Text('Date: ${invoice.date}'),
///             // Add more invoice details
///           ],
///         ),
///       ),
///     );
///
///     await Printing.layoutPdf(
///       onLayout: (format) async => pdf.save(),
///     );
///   }
/// }
/// ```

/// Invoice Model
class Invoice {
  final String id;
  final String number;
  final DateTime issueDate;
  final DateTime dueDate;
  final String billTo;
  final String billToAddress;
  final List<InvoiceLineItem> lineItems;
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String currency;
  final String status;
  final String? notes;

  Invoice({
    required this.id,
    required this.number,
    required this.issueDate,
    required this.dueDate,
    required this.billTo,
    required this.billToAddress,
    required this.lineItems,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.currency = 'KES',
    this.status = 'pending',
    this.notes,
  });

  String get formattedTotal {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${total.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'KES':
        return 'KSh ';
      default:
        return currency;
    }
  }
}

/// Invoice Line Item
class InvoiceLineItem {
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  InvoiceLineItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  }) : total = quantity * unitPrice;
}

/// Invoice Header Widget
class InvoiceHeader extends StatelessWidget {
  final Invoice invoice;
  final String? logoUrl;
  final String companyName;
  final String companyAddress;

  const InvoiceHeader({
    super.key,
    required this.invoice,
    this.logoUrl,
    this.companyName = 'Flow EdTech Platform',
    this.companyAddress = 'Nairobi, Kenya',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (logoUrl != null)
                    Image.network(
                      logoUrl!,
                      height: 40,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    )
                  else
                    Text(
                      companyName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    companyAddress,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              // Invoice Number and Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _getStatusColor()),
                    ),
                    child: Text(
                      invoice.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.swInvoiceNumber(invoice.number),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.swInvoiceIssued(_formatDate(invoice.issueDate)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    context.l10n.swInvoiceDue(_formatDate(invoice.dueDate)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 32),

          // Bill To
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.swInvoiceBillTo,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                invoice.billTo,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                invoice.billToAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (invoice.status.toLowerCase()) {
      case 'paid':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'overdue':
        return AppColors.error;
      case 'cancelled':
        return AppColors.textSecondary;
      default:
        return AppColors.info;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Invoice Line Items Table
class InvoiceLineItemsTable extends StatelessWidget {
  final List<InvoiceLineItem> lineItems;
  final String currency;

  const InvoiceLineItemsTable({
    super.key,
    required this.lineItems,
    this.currency = 'KES',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    context.l10n.swInvoiceDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.swInvoiceQty,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.swInvoiceRate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.swInvoiceAmount,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // Line Items
          ...lineItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == lineItems.length - 1;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: !isLast
                    ? const Border(
                        bottom: BorderSide(color: AppColors.border),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item.quantity}',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _formatCurrency(item.unitPrice),
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _formatCurrency(item.total),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'KES':
        return 'KSh ';
      default:
        return currency;
    }
  }
}

/// Invoice Totals Widget
class InvoiceTotals extends StatelessWidget {
  final Invoice invoice;

  const InvoiceTotals({
    super.key,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = _getCurrencySymbol(invoice.currency);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _TotalRow(
            label: context.l10n.swInvoiceSubtotal,
            value: '$symbol${invoice.subtotal.toStringAsFixed(2)}',
          ),
          if (invoice.discount > 0) ...[
            const SizedBox(height: 12),
            _TotalRow(
              label: context.l10n.swInvoiceDiscount,
              value: '-$symbol${invoice.discount.toStringAsFixed(2)}',
              valueColor: AppColors.success,
            ),
          ],
          if (invoice.tax > 0) ...[
            const SizedBox(height: 12),
            _TotalRow(
              label: context.l10n.swInvoiceTax,
              value: '+$symbol${invoice.tax.toStringAsFixed(2)}',
            ),
          ],
          const Divider(height: 24),
          _TotalRow(
            label: context.l10n.swInvoiceTotal,
            value: invoice.formattedTotal,
            labelStyle: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            valueStyle: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'KES':
        return 'KSh ';
      default:
        return currency;
    }
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

/// Receipt Summary Widget (Compact version for confirmations)
class ReceiptSummary extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onDownload;

  const ReceiptSummary({
    super.key,
    required this.transaction,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success,
            AppColors.success.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),

          // Amount
          Text(
            transaction.formattedAmount,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            transaction.description,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Transaction ID
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  context.l10n.swInvoiceTransactionId,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.id,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          // Download Button
          if (onDownload != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download, color: Colors.white),
                label: Text(
                  context.l10n.swInvoiceDownloadReceipt,
                  style: const TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
