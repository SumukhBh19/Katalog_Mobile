import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/inventory_list_tile.dart';
import '../../widgets/loading_overlay.dart';

class ShelfAnalyzerScreen extends StatefulWidget {
  const ShelfAnalyzerScreen({super.key});

  @override
  State<ShelfAnalyzerScreen> createState() => _ShelfAnalyzerScreenState();
}

class _ShelfAnalyzerScreenState extends State<ShelfAnalyzerScreen> {
  File? _imageFile;
  AnalysisResult? _result;
  bool _loading = false;
  String? _error;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 90);
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
          _result = null;
          _error = null;
        });
        await _analyze();
      }
    } catch (e) {
      setState(() => _error = 'Could not pick image: $e');
    }
  }

  Future<void> _analyze() async {
    if (_imageFile == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ApiService.analyzeShelf(_imageFile!);
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.glassBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Image Source',
              style: GoogleFonts.orbitron(
                color: AppTheme.textMain,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            _PickerOption(
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
            _PickerOption(
              icon: Icons.camera_alt_outlined,
              label: 'Take a Photo',
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.glassBg.withOpacity(0.9),
        title: Text(
          'SHELF ANALYZER',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [AppTheme.accentPrimary, AppTheme.accentSecondary],
              ).createShader(const Rect.fromLTWH(0, 0, 160, 20)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textDim,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Zone ──────────────────────────────────────
            GestureDetector(
              onTap: _showPickerSheet,
              child: Container(
                width: double.infinity,
                height: 280,
                decoration: AppTheme.glassCard(),
                child: Stack(
                  children: [
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _result != null
                            ? _AnnotatedImage(
                                imageFile: _imageFile!,
                                detections: _result!.detections,
                              )
                            : Image.file(
                                _imageFile!,
                                width: double.infinity,
                                height: 280,
                                fit: BoxFit.cover,
                              ),
                      )
                    else
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 52,
                              color: AppTheme.accentPrimary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap to Upload Shelf Image',
                              style: TextStyle(
                                color: AppTheme.textDim,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Optimized for high-density retail scenes',
                              style: TextStyle(
                                color: AppTheme.textDim.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Loading overlay
                    if (_loading)
                      const Positioned.fill(child: LoadingOverlay()),

                    // Re-scan button if image loaded
                    if (_imageFile != null && !_loading)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: _showPickerSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.swap_horiz,
                                  color: AppTheme.accentPrimary,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Change',
                                  style: TextStyle(
                                    color: AppTheme.accentPrimary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            // ── Error Banner ─────────────────────────────────────
            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // ── Stats ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Total Items',
                    value: _result != null
                        ? '${_result!.metadata.totalItems}'
                        : '—',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Inference Time',
                    value: _result?.metadata.inferenceTime ?? '—',
                    valueColor: AppTheme.accentSecondary,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

            const SizedBox(height: 16),

            // ── Inventory List ───────────────────────────────────
            Container(
              decoration: AppTheme.glassCard(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INVENTORY SUMMARY',
                    style: TextStyle(
                      color: AppTheme.textDim,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_result == null || _result!.inventory.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          _imageFile == null
                              ? 'Upload image to see data'
                              : _loading
                              ? 'Analyzing...'
                              : 'No items detected',
                          style: TextStyle(
                            color: AppTheme.textDim.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  else
                    ..._result!.inventory.entries.toList().asMap().entries.map(
                      (e) => InventoryListTile(
                        name: e.value.key,
                        count: e.value.value,
                        isLast: e.key == _result!.inventory.length - 1,
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPickerSheet,
        backgroundColor: AppTheme.accentPrimary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.document_scanner_rounded),
        label: Text(
          'SCAN SHELF',
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Annotated Image with bounding boxes ──────────────────────────────────────
class _AnnotatedImage extends StatelessWidget {
  final File imageFile;
  final List<Detection> detections;

  const _AnnotatedImage({required this.imageFile, required this.detections});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Image.file(
              imageFile,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              fit: BoxFit.cover,
            ),
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _BoundingBoxPainter(
                detections: detections,
                imageSize: constraints.biggest,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BoundingBoxPainter extends CustomPainter {
  final List<Detection> detections;
  final Size imageSize;

  _BoundingBoxPainter({required this.detections, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    for (final det in detections) {
      if (det.box.length < 4) continue;
      final color = det.isLearned
          ? AppTheme.accentSecondary
          : AppTheme.accentPrimary;

      // Box
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Scale box coords relative to canvas
      final x1 = det.box[0] / 1000 * size.width;
      final y1 = det.box[1] / 1000 * size.height;
      final x2 = det.box[2] / 1000 * size.width;
      final y2 = det.box[3] / 1000 * size.height;

      canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2), paint);

      // Label background
      final bgPaint = Paint()..color = color.withOpacity(0.8);
      final labelRect = Rect.fromLTWH(
        x1,
        y1 - 22,
        (det.label.length * 7.5 + 12),
        22,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
        bgPaint,
      );

      // Label text
      final textPainter = TextPainter(
        text: TextSpan(
          text: det.label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x1 + 5, y1 - 18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

// ── Picker Option ─────────────────────────────────────────────────────────────
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppTheme.glassCard(
          borderColor: AppTheme.accentPrimary.withOpacity(0.2),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.accentPrimary, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMain,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
