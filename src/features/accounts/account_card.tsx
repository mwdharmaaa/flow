import React from 'react';
import { Account } from '@/types/account.types';
import { useAppStore } from '@/store/app.store';
import { formatCurrency } from '@/core/formatters/currency_formatter';
import { Wallet, Landmark, Smartphone, PiggyBank, CreditCard } from 'lucide-react';

interface AccountCardProps {
  account: Account;
}

export const AccountCard: React.FC<AccountCardProps> = ({ account }) => {
  const currency = useAppStore((state) => state.currency);

  const getIcon = () => {
    switch (account.type) {
      case 'bank':
        return Landmark;
      case 'ewallet':
        return Smartphone;
      case 'investment':
        return PiggyBank;
      case 'credit':
        return CreditCard;
      default:
        return Wallet;
    }
  };

  const Icon = getIcon();

  return (
    <div className="p-4 rounded-xl bg-card border border-border/70 hover:border-border transition-all flex items-center justify-between">
      <div className="flex items-center gap-3">
        <div
          className="p-3 rounded-xl flex items-center justify-center text-white"
          style={{ backgroundColor: `${account.color}25`, color: account.color }}
        >
          <Icon className="w-5 h-5" />
        </div>

        <div>
          <h4 className="text-sm font-semibold text-slate-100">{account.name}</h4>
          <span className="text-xs text-subtle capitalize">
            {account.type === 'ewallet' ? 'E-Wallet' : account.type}
          </span>
        </div>
      </div>

      <div className="text-right">
        <div className="text-sm font-bold text-slate-100 font-mono">
          {formatCurrency(account.balance, currency)}
        </div>
        {account.isExcludedFromTotal && (
          <span className="text-[10px] text-amber-400 font-medium">Diabaikan dr Total</span>
        )}
      </div>
    </div>
  );
};
