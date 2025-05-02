import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0a0a0a),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Inter'),
        ),
      ),
      home: const ChatHomePage(),
    );
  }
}

// Custom Toast Notification Widget
class ToastNotification extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color backgroundColor;

  const ToastNotification({
    Key? key,
    required this.message,
    this.icon,
    this.backgroundColor = const Color(0xFF323232),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12.0),
          ],
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Show toast helper function
void showToast(BuildContext context, String message, {IconData? icon, Color? backgroundColor}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50.0,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ToastNotification(
            message: message,
            icon: icon,
            backgroundColor: backgroundColor ?? const Color(0xFF323232),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

// Custom Alert Dialog
Future<void> showCustomAlert(
    BuildContext context, {
      required String title,
      required String message,
      String confirmText = 'OK',
      String? cancelText,
      VoidCallback? onConfirm,
      VoidCallback? onCancel,
      Color? confirmColor,
      IconData? icon,
    }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
            ],
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(message, style: const TextStyle(color: Colors.white70)),
        ),
        actions: <Widget>[
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel();
              },
              child: Text(cancelText, style: const TextStyle(color: Colors.grey)),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            style: TextButton.styleFrom(
              backgroundColor: confirmColor ?? Colors.blue.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

// Activity tracking
class ActivityTracker {
  static final ActivityTracker _instance = ActivityTracker._internal();
  factory ActivityTracker() => _instance;
  ActivityTracker._internal();

  final List<ActivityLog> _logs = [];

  void logActivity(String activity, {String? details}) {
    _logs.add(ActivityLog(
      activity: activity,
      timestamp: DateTime.now(),
      details: details,
    ));
    print('Activity logged: $activity | ${details ?? ""}');
  }

  List<ActivityLog> get recentActivities => _logs.reversed.take(20).toList();
}

class ActivityLog {
  final String activity;
  final DateTime timestamp;
  final String? details;

  ActivityLog({
    required this.activity,
    required this.timestamp,
    this.details,
  });
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  int _selectedIndex = 0;
  final ActivityTracker _activityTracker = ActivityTracker();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FriendListPage(activityTracker: _activityTracker),
      PersonalChatsPage(activityTracker: _activityTracker),
      CallsPage(activityTracker: _activityTracker),
      ActivityPage(activityTracker: _activityTracker),
    ];

    _activityTracker.logActivity('App Started', details: 'User opened the app');

    // Show welcome toast after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showToast(
          context,
          'Selamat datang kembali!',
          icon: FontAwesomeIcons.check,
          backgroundColor: Colors.green.shade700,
        );
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _activityTracker.logActivity(
      'Navigation',
      details: 'Navigated to ${index == 0 ? 'Beranda' : index == 1 ? 'Obrolan' : index == 2 ? 'Panggilan' : 'Activity'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xFF121212),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Expanded(
              child: _pages[_selectedIndex],
            ),
            BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: const Color(0xFF0a0a0a),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.commentAlt),
                    label: 'Obrolan'
                ),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.phoneAlt),
                    label: 'Panggilan'
                ),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.listAlt),
                    label: 'Activity'
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FriendListPage extends StatelessWidget {
  final ActivityTracker activityTracker;
  final String profileImageUrl = 'https://randomuser.me/api/portraits/women/75.jpg'; // Fixed profile image

  FriendListPage({required this.activityTracker});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildProfileHeader(context),
          SizedBox(height: 16),
          _buildSearchBar(context),
          SizedBox(height: 16),
          _sectionHeader(context, 'Daftar Teman', 'Lihat Semua'),
          SizedBox(height: 8),
          _friendItem(
            context,
            icon: FontAwesomeIcons.userPlus,
            title: 'Tambah Teman',
            subtitle: 'Tambahkan sebagai teman dan mulai obrolan.',
            iconBgColor: Colors.green,
            onTap: () {
              activityTracker.logActivity('Friend Action', details: 'User tapped on Add Friend');
              showCustomAlert(
                context,
                title: 'Tambah Teman',
                message: 'Masukkan ID teman atau pindai kode QR untuk menambahkan teman baru.',
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
            imageUrl: 'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/11/22/F_gJ2prbIAAxoX3-1843359882.jpg',
            title: 'BTS (Grup)',
            subtitle: "This is Bangtan Style (77)",
            trailingCount: '7',
            onTap: () {
              activityTracker.logActivity('Friend Action', details: 'User tapped on BTS Group');
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
          SizedBox(height: 8),
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
        activityTracker.logActivity('Profile', details: 'User tapped on profile header');
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
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                  Text(
                    'Sri Yanti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Masukkan pesan status',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
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
                  boxShadow: [
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
        activityTracker.logActivity('Search', details: 'User tapped on search bar');
        showToast(
          context,
          'Pencarian teman dibuka',
          icon: FontAwesomeIcons.search,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.search, size: 16, color: Colors.grey),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cari',
                style: TextStyle(color: Colors.grey),
              ),
            ),
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
        Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            activityTracker.logActivity('Section Action', details: 'User tapped on $action for $title');
            showToast(
              context,
              'Membuka semua $title...',
              icon: FontAwesomeIcons.list,
            );
          },
          child: Text(action, style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w500)),
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
        margin: EdgeInsets.only(bottom: 8),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey),
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
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black12,
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trailingCount,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceIcon(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        activityTracker.logActivity('Service', details: 'User tapped on $label service');
        showCustomAlert(
          context,
          title: label,
          message: 'Apakah Anda ingin membuka layanan $label?',
          confirmText: 'Buka',
          cancelText: 'Batal',
          icon: icon,
          onConfirm: () {
            showToast(
              context,
              'Membuka layanan $label...',
              icon: icon,
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
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
            SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}


class PersonalChatsPage extends StatefulWidget {
  final ActivityTracker activityTracker;

  const PersonalChatsPage({super.key, required this.activityTracker});

  @override
  State<PersonalChatsPage> createState() => _PersonalChatsPageState();
}

class _PersonalChatsPageState extends State<PersonalChatsPage> {
  List<Map<String, String>> chats = [
    {
      'name': 'Yann',
      'date': 'Hari ini',
      'message': 'Ohayo Gozaimasu',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr2qLjOGy_lbYJ6V_E7wemM44cgy3Cknn3GjZhnha0WYBVsE-cpTrd8vNzrUExEGhe7SU&usqp=CAU'
    },
    {
      'name': 'Jk',
      'date': 'Hari ini',
      'message': 'Annyeong',
      'imageUrl': 'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/12/06/jungkook-1117564109.jpg'
    },
    {
      'name': 'BTS (GROUP)',
      'date': '14/6/2024',
      'message': '@Yoongi Hallo',
      'imageUrl': 'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/11/22/F_gJ2prbIAAxoX3-1843359882.jpg'
    },
    {
      'name': 'Neo',
      'date': '14/6/2024',
      'message': 'Wah bener-bener sih',
      'imageUrl': 'https://i.mydramalist.com/YYzxDW_5_c.jpg'
    },
    {
      'name': 'LINE',
      'date': '15/6/2024',
      'message': 'Alamat email berhasil didaftarkan.',
      'imageUrl': 'https://static.arenalte.com/uploads/2019/02/Screenshot_20190226-183053_1_1-480x360.jpg'
    },
    {
      'name': 'Memo Keep',
      'date': '',
      'message': 'Kirim teks, foto, video, dan tautan yang ingin disimpan untuk diri sendiri.',
      'imageUrl': 'https://static.arenalte.com/uploads/2019/04/Sticker-LINE-sticker-custon-sticker-LINE-480x360.jpg'
    },
  ];

  List<bool> _selected = [];
  bool _showCheckbox = false;
  List<Map<String, String>> _recentlyDeleted = [];

  @override
  void initState() {
    super.initState();
    _selected = List.generate(chats.length, (_) => false);

    widget.activityTracker.logActivity('Chat Tab', details: 'User viewed personal chats');
  }

  void _toggleCheckboxMode() {
    setState(() {
      _showCheckbox = !_showCheckbox;
      if (!_showCheckbox) {
        _selected = List.generate(chats.length, (_) => false);
      }
    });

    widget.activityTracker.logActivity(
        'Chat Action',
        details: _showCheckbox ? 'User entered delete mode' : 'User exited delete mode'
    );

    if (_showCheckbox) {
      showToast(
          context,
          'Pilih pesan untuk dihapus',
          icon: FontAwesomeIcons.trash,
          backgroundColor: Colors.red.shade700
      );
    }
  }

  void _deleteSelected() {
    List<Map<String, String>> deleted = [];
    List<Map<String, String>> newChats = [];
    List<bool> newSelected = [];

    for (int i = 0; i < chats.length; i++) {
      if (_selected[i]) {
        deleted.add(chats[i]);
      } else {
        newChats.add(chats[i]);
        newSelected.add(false);
      }
    }

    setState(() {
      chats = newChats;
      _selected = newSelected;
      _showCheckbox = false;
      _recentlyDeleted = deleted;
    });

    if (deleted.isNotEmpty) {
      widget.activityTracker.logActivity(
          'Chat Action',
          details: 'User deleted ${deleted.length} chats'
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${deleted.length} chat dihapus'),
          backgroundColor: Colors.blueGrey.shade900,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              widget.activityTracker.logActivity('Chat Action', details: 'User restored deleted chats');
              setState(() {
                chats.insertAll(0, _recentlyDeleted);
                _selected.insertAll(0, List.generate(_recentlyDeleted.length, (_) => false));
                _recentlyDeleted.clear();
              });
              showToast(
                  context,
                  'Chat berhasil dipulihkan',
                  icon: FontAwesomeIcons.check,
                  backgroundColor: Colors.green.shade700
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('Obrolan', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white70),
            onPressed: _toggleCheckboxMode,
          ),
          if (_showCheckbox)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _deleteSelected,
            ),
          IconButton(
            icon: const Icon(Icons.add_comment, color: Colors.white70),
            onPressed: () {
              widget.activityTracker.logActivity('Chat Action', details: 'User tapped new chat button');
              showCustomAlert(
                context,
                title: 'Obrolan Baru',
                message: 'Pilih kontak untuk memulai obrolan baru',
                confirmText: 'Pilih Kontak',
                cancelText: 'Batal',
                icon: FontAwesomeIcons.userFriends,
                onConfirm: () {
                  showToast(
                    context,
                    'Membuka daftar kontak...',
                    icon: FontAwesomeIcons.addressBook,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_showCheckbox) {
                setState(() {
                  _selected[index] = !_selected[index];
                });
              } else {
                widget.activityTracker.logActivity(
                    'Chat Action',
                    details: 'User opened chat with ${chats[index]['name']}'
                );
                showToast(
                  context,
                  'Membuka chat dengan ${chats[index]['name']}',
                  icon: FontAwesomeIcons.comment,
                );
              }
            },
            onLongPress: () {
              if (!_showCheckbox) {
                _toggleCheckboxMode();
                setState(() {
                  _selected[index] = true;
                });
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: _selected[index] ? Colors.blueGrey.shade900.withOpacity(0.5) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Hero(
                  tag: 'chat-avatar-${chats[index]['name']}',
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(chats[index]['imageUrl']!),
                  ),
                ),
                title: Text(
                    chats[index]['name']!,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                    chats[index]['message']!,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis
                ),
                trailing: _showCheckbox
                    ? Checkbox(
                  value: _selected[index],
                  onChanged: (val) {
                    setState(() {
                      _selected[index] = val!;
                    });
                  },
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                )
                    : Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: chats[index]['date'] == 'Hari ini'
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    chats[index]['date']!,
                    style: TextStyle(
                        color: chats[index]['date'] == 'Hari ini' ? Colors.blue : Colors.grey,
                        fontSize: 12
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: !_showCheckbox ? FloatingActionButton(
        onPressed: () {
          widget.activityTracker.logActivity('Chat Action', details: 'User tapped new chat button');
          showCustomAlert(
            context,
            title: 'Mulai Obrolan Baru',
            message: 'Buat grup baru atau chat personal?',
            confirmText: 'Grup Baru',
            cancelText: 'Chat Personal',
            icon: FontAwesomeIcons.comments,
            confirmColor: Colors.purple,
            onConfirm: () {
              showToast(
                context,
                'Membuat grup baru...',
                icon: FontAwesomeIcons.userFriends,
              );
            },
            onCancel: () {
              showToast(
                context,
                'Pilih kontak untuk chat personal',
                icon: FontAwesomeIcons.user,
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.chat, color: Colors.white),
      ) : null,
    );
  }
}


class CallsPage extends StatelessWidget {
  final ActivityTracker activityTracker;

  const CallsPage({super.key, required this.activityTracker});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activityTracker.logActivity('Calls Tab', details: 'User viewed call history');
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('Panggilan', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call, color: Colors.white70),
            onPressed: () {
              activityTracker.logActivity('Call Action', details: 'User initiated new video call');
              showCustomAlert(
                context,
                title: 'Video Call Baru',
                message: 'Pilih kontak untuk memulai video call',
                confirmText: 'Pilih Kontak',
                cancelText: 'Batal',
                icon: FontAwesomeIcons.video,
                onConfirm: () {
                  showToast(
                    context,
                    'Membuka daftar kontak untuk video call...',
                    icon: FontAwesomeIcons.video,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white70),
            onPressed: () {
              activityTracker.logActivity('Call Action', details: 'User initiated new voice call');
              showCustomAlert(
                context,
                title: 'Voice Call Baru',
                message: 'Pilih kontak untuk memulai voice call',
                confirmText: 'Pilih Kontak',
                cancelText: 'Batal',
                icon: FontAwesomeIcons.phone,
                onConfirm: () {
                  showToast(
                    context,
                    'Membuka daftar kontak untuk voice call...',
                    icon: FontAwesomeIcons.phone,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildCallItem(
            context,
            name: 'Jk',
            type: 'Voice',
            time: 'Hari ini, 09.15',
            imageUrl: 'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/12/06/jungkook-1117564109.jpg',
            isMissed: true,
          ),
          _buildCallItem(
            context,
            name: 'Neo',
            type: 'Video',
            time: 'Kemarin, 20.42',
            imageUrl: 'https://i.mydramalist.com/YYzxDW_5_c.jpg',
            isMissed: false,
          ),
          _buildCallItem(
            context,
            name: 'Jk',
            type: 'Video',
            time: '20 Apr 2024, 15.10',
            imageUrl: 'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/12/06/jungkook-1117564109.jpg',
            isMissed: false,
          ),
          _buildCallItem(
            context,
            name: 'BTS (Group)',
            type: 'Voice',
            time: '15 Apr 2024, 21.00',
            imageUrl: 'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/11/22/F_gJ2prbIAAxoX3-1843359882.jpg',
            isMissed: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          activityTracker.logActivity('Call Action', details: 'User tapped on new call button');
          showCustomAlert(
            context,
            title: 'Panggilan Baru',
            message: 'Pilih jenis panggilan yang ingin Anda lakukan',
            confirmText: 'Video Call',
            cancelText: 'Voice Call',
            icon: FontAwesomeIcons.phone,
            confirmColor: Colors.green,
            onConfirm: () {
              showToast(
                context,
                'Memulai video call baru...',
                icon: FontAwesomeIcons.video,
                backgroundColor: Colors.green,
              );
            },
            onCancel: () {
              showToast(
                context,
                'Memulai voice call baru...',
                icon: FontAwesomeIcons.phone,
                backgroundColor: Colors.blue,
              );
            },
          );
        },
        backgroundColor: Colors.green,
        child: Icon(FontAwesomeIcons.phone, color: Colors.white),
      ),
    );
  }

  Widget _buildCallItem(
      BuildContext context, {
        required String name,
        required String type,
        required String time,
        required String imageUrl,
        required bool isMissed,
      }) {
    return GestureDetector(
      onTap: () {
        activityTracker.logActivity('Call Action', details: 'User tapped on call history item: $name');
        showCustomAlert(
          context,
          title: 'Info Panggilan',
          message: 'Panggilan $type dengan $name pada $time',
          confirmText: 'Panggil Kembali',
          cancelText: 'Tutup',
          icon: type == 'Video' ? FontAwesomeIcons.video : FontAwesomeIcons.phone,
          confirmColor: type == 'Video' ? Colors.purple : Colors.green,
          onConfirm: () {
            showToast(
              context,
              'Memanggil $name...',
              icon: type == 'Video' ? FontAwesomeIcons.video : FontAwesomeIcons.phone,
              backgroundColor: type == 'Video' ? Colors.purple : Colors.green,
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Hero(
            tag: 'call-avatar-$name-$time',
            child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
          ),
          title: Text(
            name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              Icon(
                type == 'Video' ? FontAwesomeIcons.video : FontAwesomeIcons.phone,
                size: 12,
                color: isMissed ? Colors.red : Colors.grey,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$type pada $time',
                  style: TextStyle(color: isMissed ? Colors.red : Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              type == 'Video' ? FontAwesomeIcons.video : FontAwesomeIcons.phone,
              color: type == 'Video' ? Colors.purple : Colors.green,
              size: 20,
            ),
            onPressed: () {
              activityTracker.logActivity('Call Action', details: 'User initiated callback to $name');
              showToast(
                context,
                'Memanggil $name...',
                icon: type == 'Video' ? FontAwesomeIcons.video : FontAwesomeIcons.phone,
                backgroundColor: type == 'Video' ? Colors.purple : Colors.green,
              );
            },
          ),
        ),
      ),
    );
  }
}

// New Activity Page to track user actions
class ActivityPage extends StatelessWidget {
  final ActivityTracker activityTracker;

  const ActivityPage({super.key, required this.activityTracker});

  @override
  Widget build(BuildContext context) {
    final activities = activityTracker.recentActivities;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text('Aktivitas Terakhir', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.sync, color: Colors.white70),
            onPressed: () {
              activityTracker.logActivity('Activity', details: 'User refreshed activity log');
              showToast(
                context,
                'Aktivitas diperbarui',
                icon: FontAwesomeIcons.check,
                backgroundColor: Colors.green,
              );
              // Force rebuild
              (context as Element).markNeedsBuild();
            },
          ),
        ],
      ),
      body: activities.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.clipboardList, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada aktivitas',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Aktivitas Anda akan muncul di sini',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          IconData icon;
          Color iconColor;

          // Determine icon based on activity type
          if (activity.activity.contains('Chat')) {
            icon = FontAwesomeIcons.comment;
            iconColor = Colors.blue;
          } else if (activity.activity.contains('Call')) {
            icon = FontAwesomeIcons.phone;
            iconColor = Colors.green;
          } else if (activity.activity.contains('Friend')) {
            icon = FontAwesomeIcons.userFriends;
            iconColor = Colors.orange;
          } else if (activity.activity.contains('Profile')) {
            icon = FontAwesomeIcons.userCircle;
            iconColor = Colors.purple;
          } else if (activity.activity.contains('Navigation')) {
            icon = FontAwesomeIcons.compass;
            iconColor = Colors.cyan;
          } else {
            icon = FontAwesomeIcons.bell;
            iconColor = Colors.grey;
          }

          return Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: iconColor.withOpacity(0.2),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              title: Text(
                activity.activity,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activity.details != null)
                    Text(
                      activity.details!,
                      style: TextStyle(color: Colors.grey),
                    ),
                  Text(
                    _formatDateTime(activity.timestamp),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(FontAwesomeIcons.ellipsisV, size: 16, color: Colors.grey),
                onPressed: () {
                  showCustomAlert(
                    context,
                    title: 'Detail Aktivitas',
                    message: 'Aktivitas: ${activity.activity}\nWaktu: ${_formatDateTime(activity.timestamp)}\nDetail: ${activity.details ?? "Tidak ada detail"}',
                    confirmText: 'Tutup',
                    icon: icon,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 2) {
      return 'Kemarin';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class CallItem extends StatelessWidget {
  final String name;
  final String type;
  final String time;
  final String imageUrl;
  final bool isMissed;

  const CallItem({
    super.key,
    required this.name,
    required this.type,
    required this.time,
    required this.imageUrl,
    required this.isMissed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '$type pada $time',
        style: TextStyle(color: isMissed ? Colors.red : Colors.grey),
      ),
      trailing: Icon(
        type == 'Video' ? Icons.videocam : Icons.phone,
        color: Colors.grey,
      ),
    );
  }
}