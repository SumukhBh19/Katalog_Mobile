import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';
import '../../widgets/inventory_list_tile.dart';

class ManualItemScreen extends StatefulWidget {
  const ManualItemScreen({super.key});

  @override
  State<ManualItemScreen> createState() => _ManualItemScreenState();
}

class _ManualItemScreenState extends State<ManualItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _countCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();

  // In-memory item list for this session
  final List<Map<String, dynamic>> _items = [];
  bool _showForm = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _countCtrl.dispose();
    _brandCtrl.dispose();
    _skuCtrl.dispose();
    super.dispose();
  }

  void _addItem() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _items.add({
        'name': _nameCtrl.text.trim(),
        'brand': _brandCtrl.text.trim(),
        'sku': _skuCtrl.text.trim(),
        'count': int.tryParse(_countCtrl.text.trim()) ?? 1,
      });
      _nameCtrl.clear();
      _countCtrl.clear();
      _brandCtrl.clear();
      _skuCtrl.clear();
      _showForm = false; // Collapse form after adding
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.accentPrimary.withOpacity(0.15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppTheme.accentPrimary.withOpacity(0.4)),
        ),
        content: Text(
          'Item added to catalog',
          style: const TextStyle(color: AppTheme.accentPrimary),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  void _editItem(int index) {
    final item = _items[index];
    _nameCtrl.text = item['name'];
    _countCtrl.text = item['count'].toString();
    _brandCtrl.text = item['brand'];
    _skuCtrl.text = item['sku'];
    setState(() {
      _items.removeAt(index);
      _showForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.glassBg.withOpacity(0.9),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textDim,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : context.go('/seller/dashboard'),
        ),
        title: Text(
          'MANUAL CATALOG',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
              ).createShader(const Rect.fromLTWH(0, 0, 160, 20)),
          ),
        ),
        actions: [
          if (_items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentSecondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.accentSecondary.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    '${_items.length} item${_items.length > 1 ? 's' : ''}',
                    style: GoogleFonts.orbitron(
                      color: AppTheme.accentSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Add Item Form ─────────────────────────────────
            GestureDetector(
              onTap: () => setState(() => _showForm = !_showForm),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.glassCard(
                  borderColor: AppTheme.accentPrimary.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    Icon(
                      _showForm ? Icons.expand_less : Icons.add_circle_outline,
                      color: AppTheme.accentPrimary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _showForm ? 'Hide Form' : 'Add New Item',
                      style: GoogleFonts.orbitron(
                        color: AppTheme.accentPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            if (_showForm) ...[
              const SizedBox(height: 14),
              Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppTheme.glassCard(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('ITEM DETAILS'),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _nameCtrl,
                            style: const TextStyle(color: AppTheme.textMain),
                            decoration: AppTheme.neonInput(
                              'Product / Item Name *',
                              icon: Icons.inventory_2_outlined,
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Item name is required'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _brandCtrl,
                            style: const TextStyle(color: AppTheme.textMain),
                            decoration: AppTheme.neonInput(
                              'Brand Name',
                              icon: Icons.business_outlined,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _skuCtrl,
                                  style: const TextStyle(
                                    color: AppTheme.textMain,
                                  ),
                                  decoration: AppTheme.neonInput(
                                    'SKU / Barcode',
                                    icon: Icons.qr_code_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _countCtrl,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    color: AppTheme.textMain,
                                  ),
                                  decoration: AppTheme.neonInput(
                                    'Qty *',
                                    icon: Icons.numbers_outlined,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(v.trim()) == null) {
                                      return 'Numbers only';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          NeonButton(label: 'ADD TO CATALOG', onTap: _addItem),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideY(begin: -0.05, end: 0),
            ],

            const SizedBox(height: 18),

            // ── Catalog List ──────────────────────────────────
            Container(
              decoration: AppTheme.glassCard(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionLabel('CATALOG ENTRIES'),
                      if (_items.isNotEmpty)
                        Text(
                          'Swipe to delete • Tap to edit',
                          style: TextStyle(
                            color: AppTheme.textDim.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              color: AppTheme.textDim.withOpacity(0.3),
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No items yet.\nUse the form above to add items manually.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.textDim.withOpacity(0.5),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _items.length,
                      itemBuilder: (context, i) {
                        final item = _items[i];
                        return Dismissible(
                          key: ValueKey('$i-${item['name']}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                          ),
                          onDismissed: (_) => _deleteItem(i),
                          child: GestureDetector(
                            onTap: () => _editItem(i),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InventoryListTile(
                                    name: item['name'],
                                    count: item['count'],
                                    isLast: i == _items.length - 1,
                                  ),
                                  if ((item['brand'] as String).isNotEmpty ||
                                      (item['sku'] as String).isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 6,
                                        left: 2,
                                      ),
                                      child: Text(
                                        [
                                          if ((item['brand'] as String)
                                              .isNotEmpty)
                                            item['brand'],
                                          if ((item['sku'] as String)
                                              .isNotEmpty)
                                            'SKU: ${item['sku']}',
                                        ].join(' · '),
                                        style: TextStyle(
                                          color: AppTheme.textDim,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

            // ── Summary & Export ──────────────────────────────
            if (_items.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard(
                  borderColor: AppTheme.accentGreen.withOpacity(0.25),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.summarize_outlined,
                      color: AppTheme.accentGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_items.length} product${_items.length > 1 ? 's' : ''} · '
                            '${_items.fold<int>(0, (s, e) => s + (e['count'] as int))} total units',
                            style: const TextStyle(
                              color: AppTheme.textMain,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Ready for ONDC catalog submission',
                            style: TextStyle(
                              color: AppTheme.textDim,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: _items.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _showForm = true),
              backgroundColor: AppTheme.accentPrimary,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.add),
              label: Text(
                'ADD MORE',
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : null,
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: TextStyle(
      color: AppTheme.textDim,
      fontSize: 11,
      letterSpacing: 1.5,
      fontWeight: FontWeight.w600,
    ),
  );
}
