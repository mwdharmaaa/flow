import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { BalanceCard } from './balance_card';
import { CashFlowSummary } from './cash_flow_summary';
import { QuickActions } from './quick_actions';
import { TransactionItem } from '@/features/transactions/transaction_item';
import { AddTransactionModal } from '@/features/transactions/add_transaction_modal';
import { Plus, ArrowRight } from 'lucide-react';
import { TransactionType } from '@/types/transaction.types';

export const DashboardView: React.FC = () => {
  const { transactions, setActiveTab } = useAppStore();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [modalDefaultType, setModalDefaultType] = useState<TransactionType>('expense');

  const recentTransactions = transactions.slice(0, 5);

  const handleOpenAdd = (type: TransactionType = 'expense') => {
    setModalDefaultType(type);
    setIsModalOpen(true);
  };

  return (
    <div className="p-4 space-y-5">
      <BalanceCard />

      <CashFlowSummary />

      <QuickActions onOpenAddModal={handleOpenAdd} />

      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h2 className="text-xs font-bold uppercase tracking-wider text-slate-400">
            Transaksi Terakhir
          </h2>
          <button
            onClick={() => setActiveTab('transactions')}
            className="flex items-center gap-1 text-xs font-semibold text-blue-400 hover:text-blue-300 transition-colors"
          >
            <span>Lihat Semua</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>

        {recentTransactions.length === 0 ? (
          <div className="p-8 text-center bg-card rounded-2xl border border-border/50 text-slate-500 text-xs">
            Belum ada catatan transaksi. Tekan tombol + untuk mulai mencatat.
          </div>
        ) : (
          <div className="space-y-2">
            {recentTransactions.map((tx) => (
              <TransactionItem key={tx.id} transaction={tx} />
            ))}
          </div>
        )}
      </div>

      {/* Floating Add Action Button */}
      <button
        onClick={() => handleOpenAdd('expense')}
        className="fixed bottom-20 right-6 z-40 p-4 rounded-full bg-blue-600 hover:bg-blue-500 text-white shadow-2xl shadow-blue-500/50 border border-blue-400/30 active:scale-95 transition-transform"
        title="Catat Transaksi"
      >
        <Plus className="w-6 h-6" />
      </button>

      <AddTransactionModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        defaultType={modalDefaultType}
      />
    </div>
  );
};
