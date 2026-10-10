import React from 'react';
import { useAppStore } from '@/store/app.store';
import { MobileShell } from '@/components/layout/mobile_shell';
import { TopHeader } from '@/components/layout/top_header';
import { BottomNav } from '@/components/layout/bottom_nav';
import { DashboardView } from '@/features/dashboard/dashboard_view';
import { TransactionsView } from '@/features/transactions/transactions_view';
import { AccountsView } from '@/features/accounts/accounts_view';
import { BudgetsView } from '@/features/budgets/budgets_view';
import { AnalyticsView } from '@/features/analytics/analytics_view';
import { DebtsView } from '@/features/debts/debts_view';
import { RecurringView } from '@/features/recurring/recurring_view';
import { SettingsView } from '@/features/settings/settings_view';

export const App: React.FC = () => {
  const activeTab = useAppStore((state) => state.activeTab);

  const renderActiveView = () => {
    switch (activeTab) {
      case 'dashboard':
        return <DashboardView />;
      case 'transactions':
        return <TransactionsView />;
      case 'accounts':
        return <AccountsView />;
      case 'budgets':
        return <BudgetsView />;
      case 'analytics':
        return <AnalyticsView />;
      case 'debts':
        return <DebtsView />;
      case 'recurring':
        return <RecurringView />;
      case 'settings':
        return <SettingsView />;
      default:
        return <DashboardView />;
    }
  };

  return (
    <MobileShell>
      <TopHeader />
      <main className="flex-1 overflow-y-auto">{renderActiveView()}</main>
      <BottomNav />
    </MobileShell>
  );
};

export default App;
