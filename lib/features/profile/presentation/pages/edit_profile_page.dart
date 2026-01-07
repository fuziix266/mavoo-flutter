import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();
  final _profilePicController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      final user = state.user;
      final names = (user.fullName ?? '').split(' ');
      _firstNameController.text = names.isNotEmpty ? names.first : '';
      _lastNameController.text =
          names.length > 1 ? names.sublist(1).join(' ') : '';
      _usernameController.text = user.username ?? '';
      _bioController.text = user.bio ?? '';
      _websiteController.text = user.website ?? '';
      _profilePicController.text = user.profileImage ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    _profilePicController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<AuthBloc>().state;
      String? userId;
      if (state is AuthAuthenticated) {
        userId = state.user.id;
      }

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No User ID found')),
        );
        return;
      }

      final updatedData = {
        'id': userId,
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'username': _usernameController.text.trim(),
        'bio': _bioController.text.trim(),
        'website': _websiteController.text.trim(),
        'profile_pic': _profilePicController.text
            .trim(), // In real app, upload image first
      };

      context.read<AuthBloc>().add(AuthUpdateProfileRequested(updatedData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado correctamente')),
          );
          // Optional: pop or stay
          Navigator.pop(context);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error actualizando perfil: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profilePicController.text.isNotEmpty
                            ? NetworkImage(_profilePicController.text)
                            : const NetworkImage(
                                'https://via.placeholder.com/150'),
                        onBackgroundImageError: (_, __) {},
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField('Nombre', _firstNameController),
                const SizedBox(height: 16),
                _buildTextField('Apellido', _lastNameController),
                const SizedBox(height: 16),
                _buildTextField('Usuario', _usernameController),
                const SizedBox(height: 16),
                _buildTextField('Bio', _bioController),
                const SizedBox(height: 16),
                _buildTextField('Sitio Web', _websiteController),
                const SizedBox(height: 16),
                _buildTextField(
                    'URL Foto Perfil (Temporal)', _profilePicController),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator(
                              color: Colors.white);
                        }
                        return const Text('Guardar Cambios');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (label == 'Usuario' || label == 'Nombre') {
              if (value == null || value.isEmpty) {
                return 'Este campo es obligatorio';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
