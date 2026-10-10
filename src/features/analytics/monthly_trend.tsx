import React from 'react';
import { useAppStore } from '@/store/app.store';
import { formatCurrency } from '@/core/formatters/currency_formatter';
import { TrendingUp, TrendingDown } from 'lucide-react';

export const MonthlyTrend: React.FC = () => {
  const { transactions, currency } = useAppStore();

  const totalIncome = transactions
    .filter((tx) => tx.type === 'income')
    .reduce((sum, tx) => sum + tx.amount, 0);

  const totalExpense = transactions
    .filter((tx) => tx.type === 'expense')
    .reduce((sum, tx) => sum + tx.amount, 0);

  const netCashFlow = totalIncome - totalExpense;
  const isPositive = netCashFlow >= 0;

  const maxValue = Math.max(totalIncome, totalExpense, 1);
  const incomeHeight = Math.round((totalIncome / maxValue) * 100);
  const expenseHeight = Math.round((totalExpense / maxValue) * 100);

  return (
    <div className="p-4 rounded-xl bg-card border border-border/70 space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
          Perbandingan Arus Kas Bulanan
        </h3>
        <div className={`flex items-center gap-1 text-xs font-semibold ${isPositive ? 'text-emerald-400' : 'text-rose-400'}`}>
          {isPositive ? <TrendingUp className="w-3.5 h-3.5" /> : <TrendingDown className="w-3.5 h-3.5" />}
          <span>Net: {formatCurrency(netCashFlow, currency)}</span>
        </div>
      </div>

      <div className="h-32 flex items-end justify-center gap-8 pt-4 pb-2 border-b border-border/50">
        <div className="flex flex-col items-center gap-2">
          <span className="text-[10px] font-mono text-emerald-400">{formatCurrency(totalIncome, currency)}</span>
          <div
            className="w-12 bg-emerald-500 rounded-t-lg transition-all duration-500 shadow-lg shadow-emerald-500/20"
            style={{ height: `${Math.max(incomeHeight, 10)}%` }}
          />
          <span className="text-xs font-medium text-slate-400">Masuk</span>
        </div>

        <div className="flex flex-col items-center gap-2">
          <span className="text-[10px] font-mono text-rose-400">{formatCurrency(totalExpense, currency)}</span>
          <div
            className="w-12 bg-rose-500 rounded-t-lg transition-all duration-500 shadow-lg shadow-rose-500/20"
            style={{ height: `${Math.max(expenseHeight, 10)}%` }}
          />
          <span className="text-xs font-medium text-slate-400">Keluar</span>
        </div>
      </div>
    </div>
  );
};
