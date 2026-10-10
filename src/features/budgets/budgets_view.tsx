import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { BudgetCard } from './budget_card';
import { AddBudgetModal } from './add_budget_modal';
import { Plus, Target } from 'lucide-react';
import { formatCurrency } from '@/core/formatters/currency_formatter';

export const BudgetsView: React.FC = () => {
  const { budgets, currency } = useAppStore();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const totalLimit = budgets.reduce((sum, b) => sum + b.monthlyLimit, 0);
  const totalSpent = budgets.reduce((sum, b) => sum + b.spent, 0);

  return (
    <div className="p-4 space-y-4">
      <div className="p-5 rounded-2xl bg-card border border-border/80 flex items-center justify-between">
        <div>
          <span className="text-xs text-subtle font-medium">Total Batas Anggaran</span>
          <div className="text-2xl font-extrabold text-white font-mono mt-1">
            {formatCurrency(totalLimit, currency)}
          </div>
          <span className="text-xs text-slate-400 mt-1 inline-block">
            Terpakai: {formatCurrency(totalSpent, currency)}
          </span>
        </div>

        <button
          onClick={() => setIsModalOpen(true)}
          className="flex items-center gap-1.5 px-3 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-500 text-white text-xs font-semibold shadow-md shadow-blue-500/20"
        >
          <Plus className="w-4 h-4" />
          <span>Tambah</span>
        </button>
      </div>

      <div className="space-y-2.5">
        <div className="flex items-center gap-1.5 text-xs font-bold uppercase tracking-wider text-slate-400">
          <Target className="w-3.5 h-3.5" />
          <span>Kategori Anggaran ({budgets.length})</span>
        </div>

        {budgets.map((b) => (
          <BudgetCard key={b.id} budget={b} />
        ))}
      </div>

      <AddBudgetModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
      />
    </div>
  );
};
