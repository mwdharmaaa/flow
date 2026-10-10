import React from 'react';
import { useAppStore } from '@/store/app.store';
import { formatCurrency } from '@/core/formatters/currency_formatter';
import { TrendingUp, WalletCards } from 'lucide-react';

export const BalanceCard: React.FC = () => {
  const { accounts, currency } = useAppStore();

  const totalBalance = accounts
    .filter((a) => !a.isExcludedFromTotal)
    .reduce((sum, a) => sum + a.balance, 0);

  return (
    <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-blue-900/40 via-card to-card border border-blue-500/20 p-5 shadow-xl">
      <div className="flex items-center justify-between text-slate-400 text-xs font-medium">
        <div className="flex items-center gap-1.5">
          <WalletCards className="w-4 h-4 text-blue-400" />
          <span>Total Saldo Bersih</span>
        </div>
        <span className="text-[11px] px-2 py-0.5 rounded-full bg-blue-500/10 text-blue-400 font-semibold">
          {accounts.length} Akun Terhubung
        </span>
      </div>

      <div className="mt-3">
        <div className="text-3xl font-extrabold tracking-tight text-white font-mono">
          {formatCurrency(totalBalance, currency)}
        </div>
      </div>

      <div className="mt-4 pt-3 border-t border-border/40 flex items-center justify-between text-xs text-slate-400">
        <div className="flex items-center gap-1 text-emerald-400">
          <TrendingUp className="w-3.5 h-3.5" />
          <span>Keuangan Sehat & Stabil</span>
        </div>
        <span>100% Offline Lokal</span>
      </div>
    </div>
  );
};
