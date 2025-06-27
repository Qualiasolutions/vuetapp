import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/finance/finance_form_screen.dart'; // Assuming this exists
import 'package:vuet_app/ui/screens/finance/finance_detail_screen.dart'; // Assuming this exists
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/models/entity_model.dart'; // For BaseEntityModel and EntitySubtype
import 'package:vuet_app/providers/entity_providers.dart'; // For entityServiceProvider
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; // For quick actions
import 'package:vuet_app/ui/widgets/i_want_to_menu.dart'; // For I WANT TO menu

// --- Temporary Finance Model (will be moved to lib/models/finance_entities.dart) ---
@immutable
class Finance extends BaseEntityModel {
  final String? accountType; // e.g., Checking, Savings, Investment, Credit Card
  final double? balance;
  final String? currency;
  final String? bankName;
  final String? accountNumber;

  const Finance({
    String? id,
    required String name,
    String? description,
    String? userId,
    String? categoryId,
    String? subcategoryId,
    String? categoryName,
    String? subcategoryName,
    String? imageUrl,
    bool? isHidden,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.accountType,
    this.balance,
    this.currency,
    this.bankName,
    this.accountNumber,
  }) : super(
          id: id,
          name: name,
          description: description,
          userId: userId,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          categoryName: categoryName,
          subcategoryName: subcategoryName,
          imageUrl: imageUrl,
          isHidden: isHidden,
          createdAt: createdAt,
          updatedAt: updatedAt,
          subtype: EntitySubtype.finance, // Crucial for IWantToMenu
        );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userId,
        categoryId,
        subcategoryId,
        categoryName,
        subcategoryName,
        imageUrl,
        isHidden,
        createdAt,
        updatedAt,
        accountType,
        balance,
        currency,
        bankName,
        accountNumber,
        subtype,
      ];

  factory Finance.fromJson(Map<String, dynamic> json) {
    return Finance(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['user_id'] as String?,
      categoryId: json['category_id'] as String? ?? 'FINANCE',
      subcategoryId: json['subcategory_id'] as String?,
      categoryName: json['category_name'] as String? ?? 'Finance',
      subcategoryName: json['subcategory_name'] as String?,
      imageUrl: json['image_url'] as String?,
      isHidden: json['is_hidden'] as bool?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      accountType: json['account_type'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'user_id': userId,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'category_name': categoryName,
      'subcategory_name': subcategoryName,
      'image_url': imageUrl,
      'is_hidden': isHidden,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'account_type': accountType,
      'balance': balance,
      'currency': currency,
      'bank_name': bankName,
      'account_number': accountNumber,
      'subtype': subtype.toShortString(),
    };
  }
}

// --- End Temporary Finance Model ---

// Provider for the search query for finance accounts
final financeSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider for filtered finance accounts
final filteredFinanceProvider =
    FutureProvider.family<List<Finance>, String>((ref, searchQuery) async {
  final entityService = ref.watch(entityServiceProvider);
  final allEntities = await entityService.listEntities(
    categoryName: 'FINANCE', // Assuming 'FINANCE' is the category name
    subtype: EntitySubtype.finance,
  );

  // Cast BaseEntityModel to Finance
  final allFinanceAccounts =
      allEntities.map((e) => Finance.fromJson(e.toJson())).toList();

  if (searchQuery.isEmpty) {
    return allFinanceAccounts;
  } else {
    return allFinanceAccounts.where((finance) {
      final lowerCaseQuery = searchQuery.toLowerCase();
      return finance.name.toLowerCase().contains(lowerCaseQuery) ||
          (finance.accountType?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (finance.bankName?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (finance.accountNumber?.toLowerCase().contains(lowerCaseQuery) ?? false) ||
          (finance.description?.toLowerCase().contains(lowerCaseQuery) ?? false);
    }).toList();
  }
});

// Provider for refreshing finance list
final financeListRefreshProvider = StateProvider<bool>((ref) => false);

class FinanceListScreen extends ConsumerStatefulWidget {
  const FinanceListScreen({super.key});

  @override
  ConsumerState<FinanceListScreen> createState() => _FinanceListScreenState();
}

class _FinanceListScreenState extends ConsumerState<FinanceListScreen> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshFinanceAccounts() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Invalidate the provider to force a refresh
    ref.invalidate(financeListRefreshProvider);
    ref.invalidate(filteredFinanceProvider(ref.read(financeSearchQueryProvider)));

    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

    setState(() {
      _isRefreshing = false;
    });
  }

  void _onSearchChanged(String query) {
    ref.read(financeSearchQueryProvider.notifier).state = query;
  }

  void _navigateToCreateFinance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinanceFormScreen()),
    ).then((value) {
      if (value == true) {
        _refreshFinanceAccounts();
      }
    });
  }

  void _navigateToEditFinance(BuildContext context, Finance finance) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FinanceFormScreen(finance: finance)),
    ).then((value) {
      if (value == true) {
        _refreshFinanceAccounts();
      }
    });
  }

  Future<void> _deleteFinance(BuildContext context, String financeId) async {
    try {
      await ref.read(entityServiceProvider).deleteEntity(financeId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Finance account deleted successfully')),
        );
        _refreshFinanceAccounts();
      }
    } catch (e, st) {
      log('Error deleting finance account: $e',
          name: 'FinanceListScreen', error: e, stackTrace: st);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete finance account: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(financeSearchQueryProvider);
    final financeAsync = ref.watch(filteredFinanceProvider(searchQuery));

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text('Finance Accounts'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkJungleGreen,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search finance accounts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshFinanceAccounts,
            tooltip: 'Refresh accounts',
          ),
        ],
      ),
      body: financeAsync.when(
        data: (financeAccounts) {
          if (financeAccounts.isEmpty) {
            return _buildEmptyState(context, searchQuery.isNotEmpty);
          }
          return RefreshIndicator(
            onRefresh: _refreshFinanceAccounts,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: financeAccounts.length,
              itemBuilder: (context, index) {
                final finance = financeAccounts[index];
                return FinanceCard(
                  finance: finance,
                  onTap: () =>
                      context.go('/finance/accounts/${finance.id}'), // Navigate to detail
                  onEdit: () => _navigateToEditFinance(context, finance),
                  onDelete: () => _confirmDelete(context, finance.id!),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          log('Error loading finance accounts: $error',
              name: 'FinanceListScreen', error: error, stackTrace: stackTrace);
          return ModernComponents.modernErrorState(
            title: 'Error Loading Accounts',
            subtitle: 'Could not load finance accounts. Please try again.',
            onButtonPressed: _refreshFinanceAccounts,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateFinance(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isSearching) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.account_balance_wallet,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              isSearching
                  ? 'No matching accounts found'
                  : 'No finance accounts yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearching
                  ? 'Try adjusting your search query.'
                  : 'Create your first finance account to get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isSearching)
              ElevatedButton.icon(
                onPressed: () => _navigateToCreateFinance(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Account'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String financeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to delete this finance account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFinance(context, financeId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class FinanceCard extends StatelessWidget {
  final Finance finance;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FinanceCard({
    super.key,
    required this.finance,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finance.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (finance.bankName != null && finance.bankName!.isNotEmpty)
                          Text(
                            finance.bankName!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      } else if (value == 'payment') {
                        // Navigate to create task with FINANCE__PAYMENT tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'FINANCE__PAYMENT',
                              initialCategoryName: 'Finance',
                              initialSubcategoryName: 'Payment',
                              entityId: finance.id,
                            ),
                          ),
                        );
                      } else if (value == 'budget') {
                        // Navigate to create task with FINANCE__BUDGET tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'FINANCE__BUDGET',
                              initialCategoryName: 'Finance',
                              initialSubcategoryName: 'Budget Review',
                              entityId: finance.id,
                            ),
                          ),
                        );
                      } else if (value == 'tax') {
                        // Navigate to create task with FINANCE__TAX tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'FINANCE__TAX',
                              initialCategoryName: 'Finance',
                              initialSubcategoryName: 'Tax Preparation',
                              entityId: finance.id,
                            ),
                          ),
                        );
                      } else if (value == 'investment') {
                        // Navigate to create task with FINANCE__INVESTMENT tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'FINANCE__INVESTMENT',
                              initialCategoryName: 'Finance',
                              initialSubcategoryName: 'Investment Review',
                              entityId: finance.id,
                            ),
                          ),
                        );
                      } else if (value == 'insurance') {
                        // Navigate to create task with FINANCE__INSURANCE tag
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(
                              initialTagCode: 'FINANCE__INSURANCE',
                              initialCategoryName: 'Finance',
                              initialSubcategoryName: 'Insurance Review',
                              entityId: finance.id,
                            ),
                          ),
                        );
                      } else if (value == 'i_want_to') {
                        // Show the I WANT TO menu
                        IWantToMenu.show(
                          context: context,
                          entity: finance,
                          onTagSelected: (tag, category, subcategory) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTaskScreen(
                                  initialTagCode: tag,
                                  initialCategoryName: category,
                                  initialSubcategoryName: subcategory,
                                  entityId: finance.id,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'payment',
                        child: ListTile(
                          leading: Icon(Icons.payment),
                          title: Text('Add Payment'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'budget',
                        child: ListTile(
                          leading: Icon(Icons.savings),
                          title: Text('Budget Review'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'tax',
                        child: ListTile(
                          leading: Icon(Icons.receipt),
                          title: Text('Tax Preparation'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'investment',
                        child: ListTile(
                          leading: Icon(Icons.trending_up),
                          title: Text('Investment Review'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'insurance',
                        child: ListTile(
                          leading: Icon(Icons.security),
                          title: Text('Insurance Review'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'i_want_to',
                        child: ListTile(
                          leading: Icon(Icons.lightbulb_outline),
                          title: Text('I WANT TO...'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit Account'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (finance.description != null && finance.description!.isNotEmpty)
                Text(
                  finance.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              // Account type and number
              Row(
                children: [
                  if (finance.accountType != null && finance.accountType!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getAccountTypeColor(finance.accountType!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        finance.accountType!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getAccountTypeColor(finance.accountType!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (finance.accountNumber != null && finance.accountNumber!.isNotEmpty) ...[
                    Icon(
                      Icons.credit_card,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatAccountNumber(finance.accountNumber!),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              // Balance
              if (finance.balance != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 16,
                      color: finance.balance! >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatCurrency(finance.balance!, finance.currency ?? 'USD'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: finance.balance! >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getAccountTypeColor(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'checking':
        return Colors.blue;
      case 'savings':
        return Colors.green;
      case 'investment':
        return Colors.purple;
      case 'credit card':
        return Colors.orange;
      case 'loan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatAccountNumber(String accountNumber) {
    // Show only last 4 digits for security
    if (accountNumber.length > 4) {
      return '••••${accountNumber.substring(accountNumber.length - 4)}';
    }
    return accountNumber;
  }

  String _formatCurrency(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return currencyCode;
    }
  }
}
