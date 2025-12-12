import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/berita_model.dart';
import '../models/user_model.dart';
import '../services/berita_service.dart';
import '../services/user_service.dart';
import '../widgets/berita_card.dart';
import '../widgets/shimmer_loading.dart';
import '../utils/app_theme.dart';
import 'detail_berita_screen.dart';
import 'form_berita_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BeritaService _beritaService = BeritaService();
  final UserService _userService = UserService();
  String _selectedKategori = 'Semua';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with User Greeting
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      Color(0xFF303F9F),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // User greeting
                        _buildUserGreeting(),
                        const SizedBox(height: 16),
                        // App title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.newspaper,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Portal Berita',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Berita terkini untuk Anda',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari berita...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // Kategori Filter
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildKategoriChip('Semua'),
                  ...KategoriBerita.daftar.map((kategori) => _buildKategoriChip(kategori)),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          // Daftar Berita
          StreamBuilder<List<Berita>>(
            stream: _searchQuery.isNotEmpty
                ? _beritaService.cariBerita(_searchQuery)
                : _selectedKategori == 'Semua'
                    ? _beritaService.getSemuaBerita()
                    : _beritaService.getBeritaByKategori(_selectedKategori),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: ShimmerLoading(),
                );
              }

              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi kesalahan',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final beritaList = snapshot.data ?? [];

              if (beritaList.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada berita',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tekan tombol di bawah untuk memuat data contoh',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _seedDummyData,
                          icon: const Icon(Icons.cloud_download),
                          label: const Text('Muat Data Contoh'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                        if (currentUser != null) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _navigateToAdd,
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Berita Manual'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final berita = beritaList[index];
                    return BeritaCard(
                      berita: berita,
                      onTap: () => _navigateToDetail(berita),
                      // Only show edit/delete if user is logged in
                      onEdit: currentUser != null ? () => _navigateToEdit(berita) : null,
                      onDelete: currentUser != null ? () => _showDeleteDialog(berita) : null,
                    );
                  },
                  childCount: beritaList.length,
                ),
              );
            },
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
      // Only show FAB if user is logged in
      floatingActionButton: currentUser != null 
          ? FloatingActionButton.extended(
              onPressed: _navigateToAdd,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Berita'),
            )
          : null,
    );
  }

  Widget _buildUserGreeting() {
    final greeting = _getGreeting();
    final userName = currentUser?.displayName ?? 'Pengguna';
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // User Avatar
        _buildSimpleAvatar(),
      ],
    );
  }

  Widget _buildSimpleAvatar() {
    final initial = currentUser?.displayName?.isNotEmpty == true 
        ? currentUser!.displayName![0].toUpperCase() 
        : 'U';
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: AppTheme.secondaryColor,
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(UserProfile? userProfile) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: AppTheme.secondaryColor,
        backgroundImage: userProfile?.fotoUrl != null && userProfile!.fotoUrl!.isNotEmpty
            ? NetworkImage(userProfile.fotoUrl!)
            : null,
        child: userProfile?.fotoUrl == null || userProfile!.fotoUrl!.isEmpty
            ? Text(
                userProfile?.initials ?? 
                    (currentUser?.displayName?.isNotEmpty == true 
                        ? currentUser!.displayName![0].toUpperCase() 
                        : 'U'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            : null,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  Widget _buildKategoriChip(String kategori) {
    final isSelected = _selectedKategori == kategori;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(kategori),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedKategori = kategori;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
        ),
      ),
    );
  }

  void _navigateToDetail(Berita berita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBeritaScreen(berita: berita),
      ),
    );
  }

  void _navigateToAdd() {
    // Check if user is logged in
    if (currentUser == null) {
      _showLoginRequiredDialog();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FormBeritaScreen(),
      ),
    );
  }

  void _navigateToEdit(Berita berita) {
    // Check if user is logged in
    if (currentUser == null) {
      _showLoginRequiredDialog();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormBeritaScreen(berita: berita),
      ),
    );
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Login Diperlukan'),
          ],
        ),
        content: const Text(
          'Anda harus login terlebih dahulu untuk menggunakan fitur ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Berita berita) {
    // Check if user is logged in
    if (currentUser == null) {
      _showLoginRequiredDialog();
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: AppTheme.errorColor),
            const SizedBox(width: 8),
            const Text('Hapus Berita'),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus "${berita.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _beritaService.hapusBerita(berita.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Berita berhasil dihapus'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus: $e'),
                      backgroundColor: AppTheme.errorColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Seed dummy data
  Future<void> _seedDummyData() async {
    // Show options dialog
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.cloud_download, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Muat Data Contoh'),
          ],
        ),
        content: const Text(
          'Pilih cara memuat data contoh:',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Batal'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, 'force'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Reset & Muat Ulang'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'normal'),
            child: const Text('Muat Data'),
          ),
        ],
      ),
    );

    if (result == null || result == 'cancel') return;

    final forceReload = result == 'force';

    // Show loading dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(
                forceReload ? 'Mereset dan memuat data...' : 'Memuat data contoh...',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    try {
      final count = await _beritaService.seedDummyData(forceReload: forceReload);
      
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        if (count > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Berhasil memuat $count berita contoh'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          // Jika count 0, tampilkan pilihan untuk force reload
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(child: Text('Data sudah ada. Pilih "Reset & Muat Ulang" untuk memuat ulang.')),
                ],
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}
