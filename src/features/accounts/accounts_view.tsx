import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { AccountCard } from './account_card';
import { AddAccountModal } from './add_account_modal';
import { Plus, WalletCards } from 'lucide-react';
import { formatCurrency } from '@/core/formatters/currency_formatter';

export const AccountsView: React.FC = () => {
  const { accounts, currency } = useAppStore();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const total = accounts
    .filter((a) => !a.isExcludedFromTotal)
    .reduce((sum, a) => sum + a.balance, 0);

  return (
    <div className="p-4 space-y-4">
      <div className="p-5 rounded-2xl bg-card border border-border/80 flex items-center justify-between">
        <div>
          <span className="text-xs text-subtle font-medium">Akumulasi Saldo Aktif</span>
          <div className="text-2xl font-extrabold text-white font-mono mt-1">
            {formatCurrency(total, currency)}
          </div>
          <span className="text-xs text-emerald-400 font-semibold mt-1 inline-block">
            Fitur Multi-Dompet Tanpa Batas (Free)
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
          <WalletCards className="w-3.5 h-3.5" />
          <span>Daftar Dompet & Akun ({accounts.length})</span>
        </div>

        {accounts.map((acc) => (
          <AccountCard key={acc.id} account={acc} />
        ))}
      </div>

      <AddAccountModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
      />
    </div>
  );
};
