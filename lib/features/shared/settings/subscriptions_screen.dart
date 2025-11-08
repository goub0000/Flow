import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Subscriptions Management Screen
///
/// Allows users to view and manage their subscriptions.
/// Features:
/// - Active subscriptions list
/// - Subscription history
/// - Upgrade/downgrade options
/// - Cancel subscription
/// - Billing information
///
/// Backend Integration TODO:
/// - Fetch user subscriptions
/// - Handle subscription updates
/// - Process payments
/// - Manage billing cycles

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active Subscription Card
          _buildActiveSubscriptionCard(),
          const SizedBox(height: 24),

          // Available Plans
          Text(
            'Available Plans',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildPlanCard(
            title: 'Basic Plan',
            price: 'Free',
            features: [
              'Access to basic courses',
              'Limited storage',
              'Email support',
            ],
            isCurrentPlan: true,
          ),
          const SizedBox(height: 12),
          _buildPlanCard(
            title: 'Premium Plan',
            price: '\$9.99/month',
            features: [
              'Access to all courses',
              'Unlimited storage',
              'Priority support',
              'Offline downloads',
              'Certificate of completion',
            ],
            isCurrentPlan: false,
          ),
          const SizedBox(height: 12),
          _buildPlanCard(
            title: 'Institution Plan',
            price: '\$49.99/month',
            features: [
              'Everything in Premium',
              'Multi-user management',
              'Analytics dashboard',
              'Custom branding',
              'API access',
            ],
            isCurrentPlan: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSubscriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Basic Plan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Active',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.success,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildInfoRow('Status', 'Active'),
            const SizedBox(height: 8),
            _buildInfoRow('Plan', 'Basic (Free)'),
            const SizedBox(height: 8),
            _buildInfoRow('Started', 'January 1, 2025'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Show upgrade dialog
                },
                child: const Text('Upgrade Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isCurrentPlan,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (isCurrentPlan)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Current',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        size: 20,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(feature),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            if (!isCurrentPlan)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle subscription upgrade
                  },
                  child: const Text('Select Plan'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
