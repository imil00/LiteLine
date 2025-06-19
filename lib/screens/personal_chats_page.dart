import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liteline/activity_tracker.dart';
import 'package:liteline/utils/helpers.dart'; 

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
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTr2qLjOGy_lbYJ6V_E7wemM44cgy3Cknn3GjZhnha0WYBVsE-cpTrd8vNzrUExEGhe7SU&usqp=CAU',
    },
    {
      'name': 'Jk',
      'date': 'Hari ini',
      'message': 'Annyeong',
      'imageUrl':
          'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/12/06/jungkook-1117564109.jpg',
    },
    {
      'name': 'BTS (GROUP)',
      'date': '14/6/2024',
      'message': '@Yoongi Hallo',
      'imageUrl':
          'https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/150/2023/11/22/F_gJ2prbIAAxoX3-1843359882.jpg',
    },
    {
      'name': 'Neo',
      'date': '14/6/2024',
      'message': 'Wah bener-bener sih',
      'imageUrl': 'https://i.mydramalist.com/YYzxDW_5_c.jpg',
    },
    {
      'name': 'LINE',
      'date': '15/6/2024',
      'message': 'Alamat email berhasil didaftarkan.',
      'imageUrl':
          'https://static.arenalte.com/uploads/2019/02/Screenshot_20190226-183053_1_1-480x360.jpg',
    },
    {
      'name': 'Memo Keep',
      'date': '',
      'message':
          'Kirim teks, foto, video, dan tautan yang ingin disimpan untuk diri sendiri.',
      'imageUrl':
          'https://static.arenalte.com/uploads/2019/04/Sticker-LINE-sticker-custon-sticker-LINE-480x360.jpg',
    },
  ];

  List<bool> _selected = [];
  bool _showCheckbox = false;
  List<Map<String, String>> _recentlyDeleted = [];

  @override
  void initState() {
    super.initState();
    _selected = List.generate(chats.length, (_) => false);

    widget.activityTracker.logActivity(
      'Chat Tab',
      details: 'User viewed personal chats',
    );
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
      details:
          _showCheckbox ? 'User entered delete mode' : 'User exited delete mode',
    );

    if (_showCheckbox) {
      showToast(
        context,
        'Pilih pesan untuk dihapus',
        icon: FontAwesomeIcons.trash,
        backgroundColor: Colors.red.shade700,
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
        details: 'User deleted ${deleted.length} chats',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${deleted.length} chat dihapus'),
          backgroundColor: Colors.blueGrey.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              widget.activityTracker.logActivity(
                'Chat Action',
                details: 'User restored deleted chats',
              );
              setState(() {
                chats.insertAll(0, _recentlyDeleted);
                _selected.insertAll(
                  0,
                  List.generate(_recentlyDeleted.length, (_) => false),
                );
                _recentlyDeleted.clear();
              });
              showToast(
                context,
                'Chat berhasil dipulihkan',
                icon: FontAwesomeIcons.check,
                backgroundColor: Colors.green.shade700,
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
        title: const Text(
          'Obrolan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
              widget.activityTracker.logActivity(
                'Chat Action',
                details: 'User tapped new chat button',
              );
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
                  details: 'User opened chat with ${chats[index]['name']}',
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
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: _selected[index]
                    ? Colors.blueGrey.shade900.withOpacity(0.5)
                    : Colors.transparent,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  chats[index]['message']!,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: chats[index]['date'] == 'Hari ini'
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          chats[index]['date']!,
                          style: TextStyle(
                            color: chats[index]['date'] == 'Hari ini'
                                ? Colors.blue
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: !_showCheckbox
          ? FloatingActionButton(
              onPressed: () {
                widget.activityTracker.logActivity(
                  'Chat Action',
                  details: 'User tapped new chat button',
                );
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
              child: const Icon(Icons.chat, color: Colors.white),
            )
          : null,
    );
  }
}