import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/workout_group.dart';
import '../models/workout_session.dart';
import '../services/auth_service.dart';
import '../services/workout_group_service.dart';
import '../services/workout_session_service.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final _authService = AuthService();
  final _groupService = WorkoutGroupService();
  final _sessionService = WorkoutSessionService();
  List<WorkoutGroup> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _isLoading = true);
    final user = await _authService.getCurrentUser();
    if (user != null) {
      final groups = await _groupService.getGroups(user.id);
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    }
  }

  Future<void> _showCreateGroupDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = await _authService.getCurrentUser();
              if (user != null && nameController.text.isNotEmpty) {
                final group = WorkoutGroup(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  memberIds: [user.id],
                  adminId: user.id,
                  createdAt: DateTime.now(),
                );
                await _groupService.createGroup(group);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _loadGroups();
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _showJoinGroupDialog() async {
    final groupIdController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Group'),
        content: TextField(
          controller: groupIdController,
          decoration: const InputDecoration(
            labelText: 'Group ID',
            border: OutlineInputBorder(),
            hintText: 'Enter group ID',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = await _authService.getCurrentUser();
              if (user != null && groupIdController.text.isNotEmpty) {
                await _groupService.joinGroup(groupIdController.text, user.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _loadGroups();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Joined group!')),
                  );
                }
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Future<void> _showGroupDetails(WorkoutGroup group) async {
    // Get all sessions from group members
    final allSessions = <WorkoutSession>[];
    for (var memberId in group.memberIds) {
      final sessions = await _sessionService.getSessions(memberId);
      allSessions.addAll(sessions.where((s) => s.isCompleted));
    }
    
    // Sort by date
    allSessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(group.name),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.description),
                const SizedBox(height: 16),
                Text(
                  'Members: ${group.memberIds.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Group ID: ${group.id}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recent Group Activity',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: allSessions.isEmpty
                      ? const Text('No activity yet')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: allSessions.take(5).length,
                          itemBuilder: (context, index) {
                            final session = allSessions[index];
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.fitness_center, size: 20),
                              title: Text(
                                session.planName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                DateFormat('MMM dd, HH:mm').format(session.startTime),
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                '${session.duration.inMinutes}m',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: _groups.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.group, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No groups yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showCreateGroupDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Create Group'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _showJoinGroupDialog,
                    icon: const Icon(Icons.login),
                    label: const Text('Join Group'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => _showGroupDetails(group),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.group, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  group.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            group.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${group.memberIds.length} members',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: _groups.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'create',
                  onPressed: _showCreateGroupDialog,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'join',
                  onPressed: _showJoinGroupDialog,
                  child: const Icon(Icons.login),
                ),
              ],
            )
          : null,
    );
  }
}
