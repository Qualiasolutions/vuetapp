import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/family_providers.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';

class InviteMemberScreen extends ConsumerStatefulWidget {
  const InviteMemberScreen({super.key});

  @override
  ConsumerState<InviteMemberScreen> createState() => _InviteMemberScreenState();
}

class _InviteMemberScreenState extends ConsumerState<InviteMemberScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final familyInvitationState = ref.watch(familyInvitationControllerProvider);

    ref.listen<AsyncValue<void>>(
      familyInvitationControllerProvider,
      (AsyncValue<void>? previous, AsyncValue<void> next) {
        if (next.isLoading && next.hasValue) {
          // This state means it's loading but also has a previous successful value,
          // which might happen on a refresh. We don't want to pop or show success yet.
          return;
        }

        if (next.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send invitation: ${next.error}')),
          );
        } else if (next.hasValue && !next.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invitation sent successfully!')),
          );
          Navigator.of(context).pop(); // Go back after successful invitation
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Family Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the email address of the person you want to invite to your family.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'example@example.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: familyInvitationState.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await ref.read(familyInvitationControllerProvider.notifier).inviteFamilyMember(
                                  _emailController.text.trim(),
                                );
                          }
                        },
                  icon: familyInvitationState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(familyInvitationState.isLoading ? 'Sending Invitation...' : 'Send Invitation'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              if (familyInvitationState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ErrorView(
                    message: 'Error: ${familyInvitationState.error}',
                    onRetry: null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
