import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { RecurringCard } from './recurring_card';
import { AddRecurringModal } from './add_recurring_modal';
import { Plus, Repeat } from 'lucide-react';
import { formatCurrency } from '@/core/formatters/currency_formatter';

export const RecurringView: React.FC = () => {
  const { recurring, currency } = useAppStore();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const monthlyCommitted = recurring
    .filter((r) => r.isActive && r.type === 'expense' && r.interval === 'monthly')
    .reduce((sum, r) => sum + r.amount, 0);

  return (
    <div className="p-4 space-y-4">
      <div className="p-5 rounded-2xl bg-card border border-border/80 flex items-center justify-between">
        <div>
          <span className="text-xs text-subtle font-medium">Beban Tagihan Rutin Bulanan</span>
          <div className="text-2xl font-extrabold text-white font-mono mt-1">
            {formatCurrency(monthlyCommitted, currency)}
          </div>
          <span className="text-xs text-blue-400 font-semibold mt-1 inline-block">
            Fitur Rutin & Subscriptions Aktif (Free)
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
          <Repeat className="w-3.5 h-3.5" />
          <span>Daftar Transaksi Rutin ({recurring.length})</span>
        </div>

        {recurring.length === 0 ? (
          <div className="p-10 text-center bg-card rounded-2xl border border-border/50 text-slate-500 text-xs">
            Belum ada langganan atau tagihan rutin.
          </div>
        ) : (
          recurring.map((r) => <RecurringCard key={r.id} recurring={r} />)
        )}
      </div>

      <AddRecurringModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />
    </div>
  );
};
