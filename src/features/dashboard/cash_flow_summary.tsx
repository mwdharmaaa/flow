import React from 'react';
import { useAppStore } from '@/store/app.store';
import { formatCurrency } from '@/core/formatters/currency_formatter';
import { ArrowDownLeft, ArrowUpRight } from 'lucide-react';

export const CashFlowSummary: React.FC = () => {
  const { transactions, currency } = useAppStore();

  const totalIncome = transactions
    .filter((tx) => tx.type === 'income')
    .reduce((sum, tx) => sum + tx.amount, 0);

  const totalExpense = transactions
    .filter((tx) => tx.type === 'expense')
    .reduce((sum, tx) => sum + tx.amount, 0);

  return (
    <div className="grid grid-cols-2 gap-3">
      <div className="p-4 rounded-xl bg-card border border-border/70 flex flex-col justify-between">
        <div className="flex items-center gap-2 text-emerald-400">
          <div className="p-1.5 rounded-lg bg-emerald-500/10">
            <ArrowDownLeft className="w-4 h-4" />
          </div>
          <span className="text-xs font-semibold">Pemasukan</span>
        </div>
        <div className="mt-2 text-base font-bold text-slate-100 font-mono">
          {formatCurrency(totalIncome, currency)}
        </div>
      </div>

      <div className="p-4 rounded-xl bg-card border border-border/70 flex flex-col justify-between">
        <div className="flex items-center gap-2 text-rose-400">
          <div className="p-1.5 rounded-lg bg-rose-500/10">
            <ArrowUpRight className="w-4 h-4" />
          </div>
          <span className="text-xs font-semibold">Pengeluaran</span>
        </div>
        <div className="mt-2 text-base font-bold text-slate-100 font-mono">
          {formatCurrency(totalExpense, currency)}
        </div>
      </div>
    </div>
  );
};
