import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/berita_model.dart';
import '../utils/app_theme.dart';
import 'form_berita_screen.dart';

class DetailBeritaScreen extends StatelessWidget {
  final Berita berita;

  const DetailBeritaScreen({
    super.key,
    required this.berita,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Image Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              // Only show edit button if user is logged in
              if (FirebaseAuth.instance.currentUser != null)
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormBeritaScreen(berita: berita),
                        ),
                      );
                    },
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildHeaderImage(),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Category badge
                  Positioned(
                    bottom: 60,
                    left: 20,
                    child: _buildKategoriChip(),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        berita.judul,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          height: 1.3,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Info Row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Penulis
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons.person,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Penulis',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          berita.penulis,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 14,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade200,
                            ),
                            
                            // Tanggal
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons.calendar_today,
                                      color: AppTheme.secondaryColor,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tanggal',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _formatTanggal(berita.tanggalDibuat),
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Isi Berita
                      Text(
                        'Isi Berita',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      Text(
                        berita.isi,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.justify,
                      ),
                      
                      if (berita.tanggalDiubah != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.update,
                                size: 16,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Diperbarui: ${_formatTanggalLengkap(berita.tanggalDiubah!)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    if (berita.gambarUrl != null && berita.gambarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: berita.gambarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade300,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      );
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
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
          size: 80,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildKategoriChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.getKategoriColor(berita.kategori),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        berita.kategori,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTanggal(DateTime tanggal) {
    return DateFormat('dd MMM yyyy').format(tanggal);
  }

  String _formatTanggalLengkap(DateTime tanggal) {
    return DateFormat('dd MMMM yyyy, HH:mm').format(tanggal);
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

