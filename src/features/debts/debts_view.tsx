import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { DebtCard } from './debt_card';
import { AddDebtModal } from './add_debt_modal';
import { Plus, HandCoins } from 'lucide-react';
import { formatCurrency } from '@/core/formatters/currency_formatter';

export const DebtsView: React.FC = () => {
  const { debts, currency } = useAppStore();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const totalReceivables = debts
    .filter((d) => d.type === 'receivable' && !d.isSettled)
    .reduce((sum, d) => sum + d.remainingAmount, 0);

  const totalPayables = debts
    .filter((d) => d.type === 'payable' && !d.isSettled)
    .reduce((sum, d) => sum + d.remainingAmount, 0);

  return (
    <div className="p-4 space-y-4">
      <div className="grid grid-cols-2 gap-3">
        <div className="p-4 rounded-xl bg-card border border-border/70">
          <span className="text-[11px] text-emerald-400 font-semibold">Total Piutang Belum Lunas</span>
          <div className="text-base font-bold text-slate-100 font-mono mt-1">
            {formatCurrency(totalReceivables, currency)}
          </div>
        </div>

        <div className="p-4 rounded-xl bg-card border border-border/70">
          <span className="text-[11px] text-rose-400 font-semibold">Total Hutang Belum Lunas</span>
          <div className="text-base font-bold text-slate-100 font-mono mt-1">
            {formatCurrency(totalPayables, currency)}
          </div>
        </div>
      </div>

      <div className="flex items-center justify-between">
        <div className="flex items-center gap-1.5 text-xs font-bold uppercase tracking-wider text-slate-400">
          <HandCoins className="w-3.5 h-3.5" />
          <span>Daftar Transaksi ({debts.length})</span>
        </div>

        <button
          onClick={() => setIsModalOpen(true)}
          className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-blue-600 hover:bg-blue-500 text-white text-xs font-semibold shadow-md shadow-blue-500/20"
        >
          <Plus className="w-3.5 h-3.5" />
          <span>Tambah</span>
        </button>
      </div>

      <div className="space-y-2.5">
        {debts.length === 0 ? (
          <div className="p-10 text-center bg-card rounded-2xl border border-border/50 text-slate-500 text-xs">
            Belum ada catatan hutang atau piutang.
          </div>
        ) : (
          debts.map((d) => <DebtCard key={d.id} debt={d} />)
        )}
      </div>

      <AddDebtModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />
    </div>
  );
};
