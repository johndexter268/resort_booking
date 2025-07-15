import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

class AdminRoomsScreen extends StatefulWidget {
  const AdminRoomsScreen({super.key});

  @override
  State<AdminRoomsScreen> createState() => _AdminRoomsScreenState();
}

class _AdminRoomsScreenState extends State<AdminRoomsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> rooms = [];
  List<Map<String, dynamic>> filteredRooms = [];
  String selectedFilterStatus = 'All Status';

  @override
  void initState() {
    super.initState();
    _loadRooms();
    _searchController.addListener(_filterRooms);
  }

  void _loadRooms() {
    setState(() {
      rooms = StorageService.getList('rooms');
      filteredRooms = List.from(rooms);
    });
  }

  void _filterRooms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredRooms = rooms.where((room) {
        final matchesSearch = room['id'].toLowerCase().contains(query) ||
            room['name'].toLowerCase().contains(query);
        final matchesStatus = selectedFilterStatus == 'All Status' ||
            (room['available'] ? 'Available' : 'Not Available') == selectedFilterStatus;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _deleteRoom(String roomId) {
    setState(() {
      rooms.removeWhere((room) => room['id'] == roomId);
      StorageService.setList('rooms', rooms);
      _filterRooms();
    });
  }

  String _generateNextRoomId() {
    final ids = rooms.map((r) => r['id'].toString()).toList();
    final numbers = ids
        .map((id) => int.tryParse(id.replaceAll('R', '')) ?? 0)
        .toList()
      ..sort();
    final nextNumber = (numbers.isNotEmpty ? numbers.last + 1 : 1)
        .toString()
        .padLeft(3, '0');
    return 'R$nextNumber';
  }

  void _showAddRoomDialog() {
    final nameController = TextEditingController();
    final imageController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isAvailable = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Add Room'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Room ID: ${_generateNextRoomId()}'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Room Name'),
                  ),
                  TextField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'Leave empty for placeholder image',
                    ),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price per night'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                  ),
                  CheckboxListTile(
                    title: const Text('Available'),
                    value: isAvailable,
                    onChanged: (value) {
                      setStateDialog(() {
                        isAvailable = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isEmpty ||
                      priceController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name and Price are required.')),
                    );
                    return;
                  }

                  final newRoom = {
                    'id': _generateNextRoomId(),
                    'name': nameController.text.trim(),
                    'image': imageController.text.trim().isEmpty
                        ? 'https://via.placeholder.com/400x300?text=Room+Image+Placeholder'
                        : imageController.text.trim(),
                    'price': double.tryParse(priceController.text.trim()) ?? 0.0,
                    'description': descriptionController.text.trim().isEmpty
                        ? 'Comfortable room for your perfect stay.'
                        : descriptionController.text.trim(),
                    'available': isAvailable,
                    'type': 'room',
                  };

                  setState(() {
                    rooms.add(newRoom);
                    StorageService.setList('rooms', rooms);
                    _filterRooms();
                  });

                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _statusChip(bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xFF10B981) : const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAvailable ? 'Available' : 'Not Available',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search room...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: selectedFilterStatus,
                  items: const [
                    DropdownMenuItem(value: 'All Status', child: Text('All Status')),
                    DropdownMenuItem(value: 'Available', child: Text('Available')),
                    DropdownMenuItem(value: 'Not Available', child: Text('Not Available')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedFilterStatus = value!;
                      _filterRooms();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _showAddRoomDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Room'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                  columns: const [
                    DataColumn(label: Text('Room ID', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Room Name', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Image', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                  ],
                  rows: filteredRooms.map((room) {
                    return DataRow(
                      cells: [
                        DataCell(Text(room['id'])),
                        DataCell(Text(room['name'])),
                        DataCell(
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              room['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: const Color(0xFFF1F5F9),
                                  child: const Icon(Icons.image_not_supported, color: Color(0xFF64748B)),
                                );
                              },
                            ),
                          ),
                        ),
                        DataCell(Text('₱${room['price'].toStringAsFixed(0)}')),
                        DataCell(_statusChip(room['available'])),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                                onPressed: () => _deleteRoom(room['id']),
                                tooltip: 'Delete Room',
                              ),
                              IconButton(
                                icon: Icon(
                                  room['available'] ? Icons.visibility_off : Icons.visibility,
                                  color: const Color(0xFF2563EB),
                                ),
                                tooltip: room['available'] ? 'Mark Unavailable' : 'Mark Available',
                                onPressed: () {
                                  setState(() {
                                    room['available'] = !room['available'];
                                    StorageService.setList('rooms', rooms);
                                    _filterRooms();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}