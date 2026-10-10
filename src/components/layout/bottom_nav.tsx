import React from 'react';
import { useAppStore, NavigationTab } from '@/store/app.store';
import { Home, Receipt, Wallet, PieChart, MoreHorizontal } from 'lucide-react';

export const BottomNav: React.FC = () => {
  const { activeTab, setActiveTab } = useAppStore();

  const navItems: { tab: NavigationTab; label: string; icon: React.FC<{ className?: string }> }[] = [
    { tab: 'dashboard', label: 'Ringkasan', icon: Home },
    { tab: 'transactions', label: 'Transaksi', icon: Receipt },
    { tab: 'accounts', label: 'Dompet', icon: Wallet },
    { tab: 'budgets', label: 'Anggaran', icon: PieChart },
    { tab: 'settings', label: 'Lainnya', icon: MoreHorizontal },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-40 flex justify-center bg-background/95 backdrop-blur-lg border-t border-border/80">
      <div className="w-full max-w-md flex items-center justify-around py-2 px-3">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeTab === item.tab || (item.tab === 'settings' && ['analytics', 'debts', 'recurring', 'settings'].includes(activeTab));

          return (
            <button
              key={item.tab}
              onClick={() => setActiveTab(item.tab)}
              className={`flex flex-col items-center gap-1 py-1 px-3 rounded-xl transition-all duration-150 ${
                isActive
                  ? 'text-blue-400 font-semibold scale-105'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              <Icon className="w-5 h-5" />
              <span className="text-[11px] tracking-tight">{item.label}</span>
            </button>
          );
        })}
      </div>
    </nav>
  );
};
