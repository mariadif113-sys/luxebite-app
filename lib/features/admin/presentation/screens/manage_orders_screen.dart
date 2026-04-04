import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/core/providers/language_provider.dart';
import 'package:flutter_application_1/features/admin/presentation/providers/admin_orders_provider.dart';
import 'package:flutter_application_1/shared/widgets/glass_card.dart';
import 'package:flutter_application_1/core/utils/haptics_manager.dart';

class ManageOrdersScreen extends ConsumerWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = ref.watch(languageProvider);
    final isAr = locale.languageCode == 'ar';
    final isFr = locale.languageCode == 'fr';
    final orders = ref.watch(adminOrdersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isAr ? 'إدارة الطلبات' : (isFr ? 'GÉRER LES COMMANDES' : 'MANAGE ORDERS'),
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2, color: theme.primaryColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: orders.isEmpty
          ? Center(child: Text(isAr ? 'لا توجد طلبات جارية' : 'No active orders', style: GoogleFonts.outfit(color: Colors.white38)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, ref, order, isAr, isFr, theme);
              },
            ),
    );
  }

  Widget _buildOrderCard(BuildContext context, WidgetRef ref, AdminOrder order, bool isAr, bool isFr, ThemeData theme) {
    final statusColor = _getStatusColor(order.status);
    final statusText = _getStatusText(order.status, isAr, isFr);
    final timeStr = DateFormat('HH:mm').format(order.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        height: 180,
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.id, style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: theme.primaryColor, letterSpacing: 1)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(statusText, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(order.customerName, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              order.items.join(', '),
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$timeStr • ${order.totalPrice.toInt()} DZD', style: GoogleFonts.outfit(fontSize: 12, color: Colors.white38)),
                Row(
                  children: [
                    if (order.status != OrderStatus.delivered)
                      _buildStatusButton(
                        context,
                        ref,
                        order,
                        _getNextStatus(order.status),
                        isAr,
                        isFr,
                        theme,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.1),
    );
  }

  Widget _buildStatusButton(BuildContext context, WidgetRef ref, AdminOrder order, OrderStatus nextStatus, bool isAr, bool isFr, ThemeData theme) {
    final btnText = _getNextStatusActionText(nextStatus, isAr, isFr);
    return ElevatedButton(
      onPressed: () {
        HapticsManager.success();
        ref.read(adminOrdersProvider.notifier).updateOrderStatus(order.id, nextStatus);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor.withOpacity(0.1),
        foregroundColor: theme.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: theme.primaryColor.withOpacity(0.3))),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        minimumSize: const Size(0, 32),
      ),
      child: Text(btnText, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.preparing: return Colors.blue;
      case OrderStatus.ready: return Colors.green;
      case OrderStatus.delivered: return Colors.grey;
    }
  }

  String _getStatusText(OrderStatus status, bool isAr, bool isFr) {
    switch (status) {
      case OrderStatus.pending: return isAr ? 'قيد الانتظار' : (isFr ? 'EN ATTENTE' : 'PENDING');
      case OrderStatus.preparing: return isAr ? 'يتم التحضير' : (isFr ? 'EN PRÉPARATION' : 'PREPARING');
      case OrderStatus.ready: return isAr ? 'جاهز' : (isFr ? 'PRÊT' : 'READY');
      case OrderStatus.delivered: return isAr ? 'تم التوصيل' : (isFr ? 'LIVRÉ' : 'DELIVERED');
    }
  }

  OrderStatus _getNextStatus(OrderStatus current) {
    switch (current) {
      case OrderStatus.pending: return OrderStatus.preparing;
      case OrderStatus.preparing: return OrderStatus.ready;
      case OrderStatus.ready: return OrderStatus.delivered;
      case OrderStatus.delivered: return OrderStatus.delivered;
    }
  }

  String _getNextStatusActionText(OrderStatus next, bool isAr, bool isFr) {
    switch (next) {
      case OrderStatus.pending: return '';
      case OrderStatus.preparing: return isAr ? 'ابدأ التحضير' : (isFr ? 'Commencer' : 'Start Cooking');
      case OrderStatus.ready: return isAr ? 'تم التحضير' : (isFr ? 'Marquer comme Prêt' : 'Mark Ready');
      case OrderStatus.delivered: return isAr ? 'تم التوصيل' : (isFr ? 'تم التوصيل' : 'Mark Delivered');
    }
  }
}
