import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liteline/activity_tracker.dart';
import 'package:liteline/utils/helpers.dart'; // Import for showToast and showCustomAlert

class FriendListPage extends StatelessWidget {
  final ActivityTracker activityTracker;
  final String profileImageUrl =
      'https://randomuser.me/api/portraits/women/75.jpg'; // Fixed profile image

  FriendListPage({super.key, required this.activityTracker});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 16),
          _buildSearchBar(context),
          const SizedBox(height: 16),
          _sectionHeader(context, 'Daftar Teman', 'Lihat Semua'),
          const SizedBox(height: 8),
          _friendItem(
            context,
            icon: FontAwesomeIcons.userPlus,
            title: 'Tambah Teman',
            subtitle: 'Tambahkan sebagai teman dan mulai obrolan.',
            iconBgColor: Colors.green,
            onTap: () {
              activityTracker.logActivity(
                'Friend Action',
                details: 'User tapped on Add Friend',
              );
              showCustomAlert(
                context,
                title: 'Tambah Teman',
                message:
                    'Masukkan ID teman atau pindai kode QR untuk menambahkan teman baru.',
                confirmText: 'Pindai QR',
                cancelText: 'Cari ID',
                icon: FontAwesomeIcons.qrcode,
                onConfirm: () {
                  showToast(
                    context,
                    'Pembuka QR Code sedang dipersiapkan...',
                    icon: FontAwesomeIcons.qrcode,
                  );
                },
                onCancel: () {
                  showToast(
                    context,
                    'Pencarian ID teman dibuka',
                    icon: FontAwesomeIcons.search,
                  );
                },
              );
            },
          ),
          _friendImageItem(
            context,
            imageUrl:
                'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/11/22/F_gJ2prbIAAxoX3-1843359882.jpg',
            title: 'BTS (Grup)',
            subtitle: "This is Bangtan Style (77)",
            trailingCount: '7',
            onTap: () {
              activityTracker.logActivity(
                'Friend Action',
                details: 'User tapped on BTS Group',
              );
              showCustomAlert(
                context,
                title: 'BTS (Grup)',
                message: 'Buka obrolan grup atau lihat detail anggota?',
                confirmText: 'Buka Obrolan',
                cancelText: 'Lihat Anggota',
                icon: FontAwesomeIcons.users,
                confirmColor: Colors.purple,
                onConfirm: () {
                  // Open chat logic
                  showToast(
                    context,
                    'Membuka obrolan grup BTS...',
                    icon: FontAwesomeIcons.commentAlt,
                  );
                },
              );
            },
          ),
          _sectionHeader(context, 'Layanan', 'Lihat Semua'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _serviceIcon(context, FontAwesomeIcons.fileAlt, 'Split Bill'),
              _serviceIcon(context, FontAwesomeIcons.moneyBillAlt, 'LINE Bank'),
              _serviceIcon(context, FontAwesomeIcons.solidHeart, 'Tema'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        activityTracker.logActivity(
          'Profile',
          details: 'User tapped on profile header',
        );
        showCustomAlert(
          context,
          title: 'Profil Pengguna',
          message: 'Anda dapat mengubah foto profil, nama dan status di sini',
          confirmText: 'Edit Profil',
          cancelText: 'Tutup',
          icon: FontAwesomeIcons.userEdit,
          onConfirm: () {
            showToast(
              context,
              'Membuka pengaturan profil...',
              icon: FontAwesomeIcons.cog,
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sri Yanti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Masukkan pesan status',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Hero(
              tag: 'profile-image',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        activityTracker.logActivity(
          'Search',
          details: 'User tapped on search bar',
        );
        showToast(
          context,
          'Pencarian teman dibuka',
          icon: FontAwesomeIcons.search,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(FontAwesomeIcons.search, size: 16, color: Colors.grey),
            SizedBox(width: 12),
            Expanded(child: Text('Cari', style: TextStyle(color: Colors.grey))),
            Icon(FontAwesomeIcons.sliders, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            activityTracker.logActivity(
              'Section Action',
              details: 'User tapped on $action for $title',
            );
            showToast(
              context,
              'Membuka semua $title...',
              icon: FontAwesomeIcons.list,
            );
          },
          child: Text(
            action,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: iconBgColor,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _friendImageItem(
    BuildContext context, {
    required String imageUrl,
    required String title,
    required String subtitle,
    required String trailingCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12,
        ),
        child: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trailingCount,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceIcon(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        activityTracker.logActivity(
          'Service',
          details: 'User tapped on $label service',
        );
        showCustomAlert(
          context,
          title: label,
          message: 'Apakah Anda ingin membuka layanan $label?',
          confirmText: 'Buka',
          cancelText: 'Batal',
          icon: icon,
          onConfirm: () {
            showToast(context, 'Membuka layanan $label...', icon: icon);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}