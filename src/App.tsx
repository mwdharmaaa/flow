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

interface ErrorBoundaryProps {
  children: React.ReactNode;
}

interface ErrorBoundaryState {
  hasError: boolean;
  error: string;
}

class ErrorBoundary extends React.Component<ErrorBoundaryProps, ErrorBoundaryState> {
  constructor(props: ErrorBoundaryProps) {
    super(props);
    this.state = { hasError: false, error: '' };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error: error.message };
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="p-6 text-center text-slate-100 flex flex-col items-center justify-center min-h-[50vh] space-y-3">
          <h2 className="text-base font-bold text-rose-400">Gagal Memuat Komponen</h2>
          <p className="text-xs text-slate-400">{this.state.error}</p>
          <button
            onClick={() => window.location.reload()}
            className="px-4 py-2 bg-blue-600 rounded-xl text-xs font-semibold text-white"
          >
            Muat Ulang
          </button>
        </div>
      );
    }
    return this.props.children;
  }
}

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
    <ErrorBoundary>
      <MobileShell>
        <TopHeader />
        <main className="flex-1 overflow-y-auto">{renderActiveView()}</main>
        <BottomNav />
      </MobileShell>
    </ErrorBoundary>
  );
};

export default App;
