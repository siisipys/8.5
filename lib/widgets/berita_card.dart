import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/berita_model.dart';
import '../utils/app_theme.dart';

class BeritaCard extends StatelessWidget {
  final Berita berita;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BeritaCard({
    super.key,
    required this.berita,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _buildImage(),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori dan Tanggal
                  Row(
                    children: [
                      _buildKategoriChip(),
                      const Spacer(),
                      Text(
                        _formatTanggal(berita.tanggalDibuat),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Judul
                  Text(
                    berita.judul,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Preview Isi
                  Text(
                    berita.isi,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Penulis dan Actions
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          berita.penulis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: onEdit,
                          color: AppTheme.primaryColor,
                          tooltip: 'Edit',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: onDelete,
                          color: AppTheme.errorColor,
                          tooltip: 'Hapus',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (berita.gambarUrl != null && berita.gambarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: berita.gambarUrl!,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 180,
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.getKategoriColor(berita.kategori).withValues(alpha: 0.8),
            AppTheme.getKategoriColor(berita.kategori),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getKategoriIcon(berita.kategori),
          size: 48,
          color: Colors.white.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildKategoriChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.getKategoriColor(berita.kategori),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        berita.kategori,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatTanggal(DateTime tanggal) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(tanggal);
  }

  IconData _getKategoriIcon(String kategori) {
    switch (kategori) {
      case 'Politik':
        return Icons.account_balance;
      case 'Ekonomi':
        return Icons.trending_up;
      case 'Teknologi':
        return Icons.computer;
      case 'Olahraga':
        return Icons.sports_soccer;
      case 'Hiburan':
        return Icons.movie;
      case 'Kesehatan':
        return Icons.health_and_safety;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.article;
    }
  }
}

