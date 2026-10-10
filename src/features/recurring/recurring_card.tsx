import React from 'react';
import { RecurringTransaction } from '@/types/recurring.types';
import { useAppStore } from '@/store/app.store';
import { formatCurrency, formatDateIndonesian } from '@/core/formatters/currency_formatter';
import { Clock, CheckCircle2, XCircle } from 'lucide-react';

interface RecurringCardProps {
  recurring: RecurringTransaction;
}

export const RecurringCard: React.FC<RecurringCardProps> = ({ recurring }) => {
  const { currency, toggleRecurring, accounts } = useAppStore();

  const account = accounts.find((a) => a.id === recurring.accountId);
  const isExpense = recurring.type === 'expense';

  return (
    <div className={`p-4 rounded-xl bg-card border ${recurring.isActive ? 'border-border/80' : 'border-border/40 opacity-60'} space-y-2`}>
      <div className="flex items-center justify-between">
        <div>
          <h4 className="text-sm font-semibold text-slate-100">{recurring.name}</h4>
          <span className="text-xs text-subtle">
            {recurring.category} • {account?.name || 'Akun'}
          </span>
        </div>

        <div className="text-right">
          <div className={`text-sm font-bold font-mono ${isExpense ? 'text-rose-400' : 'text-emerald-400'}`}>
            {isExpense ? '-' : '+'}
            {formatCurrency(recurring.amount, currency)}
          </div>
          <span className="text-[10px] text-blue-400 font-semibold uppercase tracking-wider">
            {recurring.interval}
          </span>
        </div>
      </div>

      <div className="flex items-center justify-between pt-2 border-t border-border/40 text-xs text-subtle">
        <div className="flex items-center gap-1">
          <Clock className="w-3.5 h-3.5" />
          <span>Jadwal Berikutnya: {formatDateIndonesian(recurring.nextExecutionDate)}</span>
        </div>

        <button
          onClick={() => toggleRecurring(recurring.id)}
          className={`flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-semibold transition-colors ${
            recurring.isActive
              ? 'bg-emerald-500/10 text-emerald-400 hover:bg-emerald-500/20'
              : 'bg-slate-800 text-slate-400 hover:bg-slate-700'
          }`}
        >
          {recurring.isActive ? (
            <>
              <CheckCircle2 className="w-3.5 h-3.5" />
              <span>Aktif</span>
            </>
          ) : (
            <>
              <XCircle className="w-3.5 h-3.5" />
              <span>Nonaktif</span>
            </>
          )}
        </button>
      </div>
    </div>
  );
};
