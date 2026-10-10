import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { TransactionItem } from './transaction_item';
import { AddTransactionModal } from './add_transaction_modal';
import { Plus, Search, Filter } from 'lucide-react';
import { TransactionType } from '@/types/transaction.types';

export const TransactionsView: React.FC = () => {
  const { transactions } = useAppStore();
  const [filterType, setFilterType] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [isModalOpen, setIsModalOpen] = useState(false);

  const filtered = transactions.filter((tx) => {
    const matchesType = filterType === 'all' || tx.type === filterType;
    const matchesSearch =
      tx.category.toLowerCase().includes(searchQuery.toLowerCase()) ||
      tx.note.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesType && matchesSearch;
  });

  return (
    <div className="p-4 space-y-4">
      <div className="flex items-center gap-2">
        <div className="relative flex-1">
          <Search className="w-4 h-4 absolute left-3 top-3 text-slate-500" />
          <input
            type="text"
            placeholder="Cari transaksi atau catatan..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-9 pr-3 py-2 bg-surface border border-border rounded-xl text-xs text-slate-100 placeholder-slate-500 focus:outline-none focus:border-blue-500"
          />
        </div>

        <button
          onClick={() => setIsModalOpen(true)}
          className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-blue-600 hover:bg-blue-500 text-white text-xs font-semibold shadow-md shadow-blue-500/20"
        >
          <Plus className="w-4 h-4" />
          <span>Baru</span>
        </button>
      </div>

      <div className="flex items-center gap-1.5 overflow-x-auto pb-1 text-xs">
        <Filter className="w-3.5 h-3.5 text-slate-500 shrink-0 mr-1" />
        {[
          { key: 'all', label: 'Semua' },
          { key: 'expense', label: 'Pengeluaran' },
          { key: 'income', label: 'Pemasukan' },
          { key: 'transfer', label: 'Transfer' },
        ].map((tab) => (
          <button
            key={tab.key}
            onClick={() => setFilterType(tab.key)}
            className={`px-3 py-1.5 rounded-lg font-medium whitespace-nowrap transition-colors ${
              filterType === tab.key
                ? 'bg-blue-500/20 text-blue-400 border border-blue-500/30'
                : 'bg-surface text-slate-400 hover:text-slate-200 border border-border'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      <div className="space-y-2">
        {filtered.length === 0 ? (
          <div className="p-10 text-center bg-card rounded-2xl border border-border/50 text-slate-500 text-xs">
            Tidak ada transaksi yang cocok dengan filter.
          </div>
        ) : (
          filtered.map((tx) => <TransactionItem key={tx.id} transaction={tx} />)
        )}
      </div>

      <AddTransactionModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        defaultType={(filterType === 'income' || filterType === 'transfer' ? filterType : 'expense') as TransactionType}
      />
    </div>
  );
};
