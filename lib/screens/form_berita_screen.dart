import 'package:flutter/material.dart';
import '../models/berita_model.dart';
import '../services/berita_service.dart';
import '../utils/app_theme.dart';

class FormBeritaScreen extends StatefulWidget {
  final Berita? berita;

  const FormBeritaScreen({
    super.key,
    this.berita,
  });

  @override
  State<FormBeritaScreen> createState() => _FormBeritaScreenState();
}

class _FormBeritaScreenState extends State<FormBeritaScreen> {
  final _formKey = GlobalKey<FormState>();
  final BeritaService _beritaService = BeritaService();

  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _penulisController;
  late TextEditingController _gambarUrlController;
  
  String _selectedKategori = KategoriBerita.daftar.first;
  bool _isLoading = false;

  bool get isEditing => widget.berita != null;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.berita?.judul ?? '');
    _isiController = TextEditingController(text: widget.berita?.isi ?? '');
    _penulisController = TextEditingController(text: widget.berita?.penulis ?? '');
    _gambarUrlController = TextEditingController(text: widget.berita?.gambarUrl ?? '');
    _selectedKategori = widget.berita?.kategori ?? KategoriBerita.daftar.first;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    _penulisController.dispose();
    _gambarUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Berita' : 'Tambah Berita'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.1),
                      AppTheme.secondaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEditing ? Icons.edit_note : Icons.post_add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? 'Edit Berita' : 'Berita Baru',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditing 
                                ? 'Perbarui informasi berita yang sudah ada'
                                : 'Isi form di bawah untuk menambah berita',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Judul
              _buildLabel('Judul Berita', true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul berita',
                  prefixIcon: Icon(Icons.title),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  if (value.trim().length < 10) {
                    return 'Judul minimal 10 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Kategori
              _buildLabel('Kategori', true),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category),
                ),
                items: KategoriBerita.daftar.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppTheme.getKategoriColor(kategori),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(kategori),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKategori = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Penulis
              _buildLabel('Nama Penulis', true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _penulisController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama penulis',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama penulis tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Gambar URL (Optional)
              _buildLabel('URL Gambar', false),
              const SizedBox(height: 8),
              TextFormField(
                controller: _gambarUrlController,
                decoration: const InputDecoration(
                  hintText: 'https://images.unsplash.com/... (opsional)',
                  prefixIcon: Icon(Icons.image),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // Validasi URL sederhana - hanya cek format https://
                    final urlPattern = RegExp(
                      r'^https?:\/\/.+',
                      caseSensitive: false,
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return 'URL harus dimulai dengan http:// atau https://';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Isi Berita
              _buildLabel('Isi Berita', true),
              const SizedBox(height: 8),
              TextFormField(
                controller: _isiController,
                decoration: const InputDecoration(
                  hintText: 'Tulis isi berita di sini...',
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                minLines: 5,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi berita tidak boleh kosong';
                  }
                  if (value.trim().length < 50) {
                    return 'Isi berita minimal 50 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Tombol Submit
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isEditing ? Icons.save : Icons.add),
                            const SizedBox(width: 8),
                            Text(isEditing ? 'Simpan Perubahan' : 'Publikasikan Berita'),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Batal
              SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Text('Batal'),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isRequired) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: AppTheme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final berita = Berita(
        id: widget.berita?.id,
        judul: _judulController.text.trim(),
        isi: _isiController.text.trim(),
        kategori: _selectedKategori,
        penulis: _penulisController.text.trim(),
        gambarUrl: _gambarUrlController.text.trim().isEmpty 
            ? null 
            : _gambarUrlController.text.trim(),
        tanggalDibuat: widget.berita?.tanggalDibuat ?? DateTime.now(),
      );

      if (isEditing) {
        await _beritaService.updateBerita(widget.berita!.id!, berita);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berita berhasil diperbarui!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _beritaService.tambahBerita(berita);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berita berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan berita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

