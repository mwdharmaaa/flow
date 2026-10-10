import React from 'react';
import { useAppStore } from '@/store/app.store';
import { formatCurrency } from '@/core/formatters/currency_formatter';

export const CategoryBreakdown: React.FC = () => {
  const { transactions, currency } = useAppStore();

  const expenseTransactions = transactions.filter((tx) => tx.type === 'expense');
  const totalExpense = expenseTransactions.reduce((sum, tx) => sum + tx.amount, 0);

  const categoryMap: Record<string, number> = {};
  expenseTransactions.forEach((tx) => {
    categoryMap[tx.category] = (categoryMap[tx.category] || 0) + tx.amount;
  });

  const sortedCategories = Object.entries(categoryMap)
    .map(([cat, amount]) => ({
      name: cat,
      amount,
      percentage: totalExpense > 0 ? Math.round((amount / totalExpense) * 100) : 0,
    }))
    .sort((a, b) => b.amount - a.amount);

  const colors = ['#F43F5E', '#3B82F6', '#8B5CF6', '#F59E0B', '#10B981', '#EC4899', '#06B6D4'];

  return (
    <div className="p-4 rounded-xl bg-card border border-border/70 space-y-3">
      <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
        Distribusi Pengeluaran per Kategori
      </h3>

      {sortedCategories.length === 0 ? (
        <p className="text-xs text-subtle text-center py-4">Belum ada pengeluaran tercatat.</p>
      ) : (
        <div className="space-y-3">
          {sortedCategories.map((item, index) => {
            const color = colors[index % colors.length];
            return (
              <div key={item.name} className="space-y-1">
                <div className="flex items-center justify-between text-xs">
                  <div className="flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full" style={{ backgroundColor: color }} />
                    <span className="font-medium text-slate-200">{item.name}</span>
                  </div>
                  <div className="flex items-center gap-2 font-mono">
                    <span className="text-slate-400">{item.percentage}%</span>
                    <span className="font-semibold text-slate-100">
                      {formatCurrency(item.amount, currency)}
                    </span>
                  </div>
                </div>

                <div className="w-full h-1.5 bg-surface rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-300"
                    style={{ width: `${item.percentage}%`, backgroundColor: color }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
