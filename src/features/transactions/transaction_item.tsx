import React from 'react';
import { Transaction } from '@/types/transaction.types';
import { useAppStore } from '@/store/app.store';
import { formatCurrency, formatDateIndonesian } from '@/core/formatters/currency_formatter';
import { ArrowDownLeft, ArrowUpRight, ArrowRightLeft, Trash2 } from 'lucide-react';

interface TransactionItemProps {
  transaction: Transaction;
}

export const TransactionItem: React.FC<TransactionItemProps> = ({ transaction }) => {
  const { accounts, currency, deleteTransaction } = useAppStore();

  const account = accounts.find((a) => a.id === transaction.accountId);
  const destAccount = accounts.find((a) => a.id === transaction.destinationAccountId);

  const isExpense = transaction.type === 'expense';
  const isIncome = transaction.type === 'income';
  const isTransfer = transaction.type === 'transfer';

  return (
    <div className="flex items-center justify-between p-3.5 rounded-xl bg-card hover:bg-card-hover border border-border/60 transition-colors group">
      <div className="flex items-center gap-3">
        <div
          className={`p-2.5 rounded-xl flex items-center justify-center ${
            isExpense
              ? 'bg-rose-500/10 text-rose-400'
              : isIncome
              ? 'bg-emerald-500/10 text-emerald-400'
              : 'bg-purple-500/10 text-purple-400'
          }`}
        >
          {isExpense && <ArrowUpRight className="w-4 h-4" />}
          {isIncome && <ArrowDownLeft className="w-4 h-4" />}
          {isTransfer && <ArrowRightLeft className="w-4 h-4" />}
        </div>

        <div>
          <h4 className="text-sm font-semibold text-slate-100">{transaction.category}</h4>
          <div className="flex items-center gap-2 mt-0.5 text-xs text-subtle">
            <span>{isTransfer && destAccount ? `${account?.name} → ${destAccount.name}` : account?.name || 'Akun'}</span>
            <span>•</span>
            <span>{formatDateIndonesian(transaction.date)}</span>
          </div>
          {transaction.note && (
            <p className="text-xs text-slate-400 italic mt-0.5">{transaction.note}</p>
          )}
        </div>
      </div>

      <div className="flex items-center gap-2">
        <div className="text-right">
          <div
            className={`text-sm font-bold font-mono ${
              isExpense ? 'text-rose-400' : isIncome ? 'text-emerald-400' : 'text-purple-400'
            }`}
          >
            {isExpense ? '-' : isIncome ? '+' : ''}
            {formatCurrency(transaction.amount, currency)}
          </div>
        </div>

        <button
          onClick={() => deleteTransaction(transaction.id)}
          className="opacity-0 group-hover:opacity-100 p-1.5 rounded-lg text-slate-500 hover:text-rose-400 hover:bg-rose-500/10 transition-all"
          title="Hapus Transaksi"
        >
          <Trash2 className="w-3.5 h-3.5" />
        </button>
      </div>
    </div>
  );
};
