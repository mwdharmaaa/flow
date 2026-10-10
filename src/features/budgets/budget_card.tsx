import React from 'react';
import { Budget } from '@/types/budget.types';
import { useAppStore } from '@/store/app.store';
import { formatCurrency } from '@/core/formatters/currency_formatter';
import { AlertTriangle, CheckCircle2 } from 'lucide-react';

interface BudgetCardProps {
  budget: Budget;
}

export const BudgetCard: React.FC<BudgetCardProps> = ({ budget }) => {
  const currency = useAppStore((state) => state.currency);

  const percentage = Math.min(Math.round((budget.spent / budget.monthlyLimit) * 100), 100);
  const remaining = budget.monthlyLimit - budget.spent;
  const isOverBudget = remaining < 0;

  const getProgressBarColor = () => {
    if (isOverBudget || percentage >= 90) return 'bg-rose-500';
    if (percentage >= 70) return 'bg-amber-500';
    return 'bg-emerald-500';
  };

  return (
    <div className="p-4 rounded-xl bg-card border border-border/70 space-y-3">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div
            className="w-3 h-3 rounded-full"
            style={{ backgroundColor: budget.color }}
          />
          <h4 className="text-sm font-semibold text-slate-100">{budget.category}</h4>
        </div>

        <div className="flex items-center gap-1 text-xs">
          {isOverBudget ? (
            <span className="flex items-center gap-1 text-rose-400 font-medium">
              <AlertTriangle className="w-3.5 h-3.5" /> Over Budget
            </span>
          ) : (
            <span className="flex items-center gap-1 text-emerald-400 font-medium">
              <CheckCircle2 className="w-3.5 h-3.5" /> Sisa {formatCurrency(remaining, currency)}
            </span>
          )}
        </div>
      </div>

      <div className="space-y-1.5">
        <div className="w-full h-2 bg-surface rounded-full overflow-hidden">
          <div
            className={`h-full transition-all duration-300 rounded-full ${getProgressBarColor()}`}
            style={{ width: `${percentage}%` }}
          />
        </div>

        <div className="flex items-center justify-between text-xs text-subtle font-mono">
          <span>Terpakai: {formatCurrency(budget.spent, currency)}</span>
          <span>Batas: {formatCurrency(budget.monthlyLimit, currency)}</span>
        </div>
      </div>
    </div>
  );
};
