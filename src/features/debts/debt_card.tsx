import React from 'react';
import { Debt } from '@/types/debt.types';
import { useAppStore } from '@/store/app.store';
import { formatCurrency, formatDateIndonesian } from '@/core/formatters/currency_formatter';
import { Check, Calendar } from 'lucide-react';

interface DebtCardProps {
  debt: Debt;
}

export const DebtCard: React.FC<DebtCardProps> = ({ debt }) => {
  const { currency, settleDebt } = useAppStore();

  const isReceivable = debt.type === 'receivable';

  return (
    <div className={`p-4 rounded-xl bg-card border ${debt.isSettled ? 'border-border/40 opacity-60' : 'border-border/80'} space-y-2`}>
      <div className="flex items-center justify-between">
        <div>
          <span
            className={`text-[10px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full ${
              isReceivable ? 'bg-emerald-500/10 text-emerald-400' : 'bg-rose-500/10 text-rose-400'
            }`}
          >
            {isReceivable ? 'Piutang (Orang Lain Berhutang)' : 'Hutang (Kamu Berhutang)'}
          </span>
          <h4 className="text-sm font-semibold text-slate-100 mt-1">{debt.personName}</h4>
        </div>

        <div className="text-right">
          <div className={`text-sm font-bold font-mono ${isReceivable ? 'text-emerald-400' : 'text-rose-400'}`}>
            {formatCurrency(debt.amount, currency)}
          </div>
          {debt.isSettled ? (
            <span className="text-[10px] text-emerald-400 font-semibold">Lunas</span>
          ) : (
            <span className="text-[10px] text-amber-400 font-medium">Belum Lunas</span>
          )}
        </div>
      </div>

      <div className="flex items-center justify-between pt-2 border-t border-border/40 text-xs text-subtle">
        <div className="flex items-center gap-1">
          <Calendar className="w-3.5 h-3.5" />
          <span>Jatuh Tempo: {formatDateIndonesian(debt.dueDate)}</span>
        </div>

        {!debt.isSettled && (
          <button
            onClick={() => settleDebt(debt.id)}
            className="flex items-center gap-1 px-2.5 py-1 rounded-lg bg-emerald-500/10 hover:bg-emerald-500/20 text-emerald-400 text-xs font-semibold transition-colors"
          >
            <Check className="w-3 h-3" />
            <span>Tandai Lunas</span>
          </button>
        )}
      </div>
    </div>
  );
};
