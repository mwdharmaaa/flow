import { create } from 'zustand';
import { LocalStorageService } from '@/core/storage/local_storage.service';
import {
  INITIAL_ACCOUNTS,
  INITIAL_BUDGETS,
  INITIAL_TRANSACTIONS,
  INITIAL_DEBTS,
  INITIAL_RECURRING,
} from '@/core/seed/initial_data.seed';
import { Account, CreateAccountDto } from '@/types/account.types';
import { Transaction, CreateTransactionDto } from '@/types/transaction.types';
import { Budget, CreateBudgetDto } from '@/types/budget.types';
import { Debt, CreateDebtDto } from '@/types/debt.types';
import { RecurringTransaction, CreateRecurringDto } from '@/types/recurring.types';

export type NavigationTab = 'dashboard' | 'transactions' | 'accounts' | 'budgets' | 'analytics' | 'debts' | 'recurring' | 'settings';

interface AppState {
  activeTab: NavigationTab;
  currency: string;
  accounts: Account[];
  transactions: Transaction[];
  budgets: Budget[];
  debts: Debt[];
  recurring: RecurringTransaction[];
  setActiveTab: (tab: NavigationTab) => void;
  setCurrency: (curr: string) => void;
  addTransaction: (dto: CreateTransactionDto) => void;
  deleteTransaction: (id: string) => void;
  addAccount: (dto: CreateAccountDto) => void;
  addBudget: (dto: CreateBudgetDto) => void;
  addDebt: (dto: CreateDebtDto) => void;
  settleDebt: (id: string) => void;
  addRecurring: (dto: CreateRecurringDto) => void;
  toggleRecurring: (id: string) => void;
  resetAllData: () => void;
}

export const useAppStore = create<AppState>((set, get) => ({
  activeTab: 'dashboard',
  currency: LocalStorageService.getItem('currency', 'IDR'),
  accounts: LocalStorageService.getItem('accounts', INITIAL_ACCOUNTS),
  transactions: LocalStorageService.getItem('transactions', INITIAL_TRANSACTIONS),
  budgets: LocalStorageService.getItem('budgets', INITIAL_BUDGETS),
  debts: LocalStorageService.getItem('debts', INITIAL_DEBTS),
  recurring: LocalStorageService.getItem('recurring', INITIAL_RECURRING),

  setActiveTab: (tab) => set({ activeTab: tab }),

  setCurrency: (currency) => {
    LocalStorageService.setItem('currency', currency);
    set({ currency });
  },

  addTransaction: (dto) => {
    const newTx: Transaction = {
      ...dto,
      id: `tx_${Date.now()}`,
      createdAt: Date.now(),
    };

    const currentAccounts = [...get().accounts];
    const updatedAccounts = currentAccounts.map((acc) => {
      if (acc.id === dto.accountId) {
        if (dto.type === 'expense' || dto.type === 'transfer') {
          return { ...acc, balance: acc.balance - dto.amount };
        } else if (dto.type === 'income') {
          return { ...acc, balance: acc.balance + dto.amount };
        }
      }
      if (dto.type === 'transfer' && acc.id === dto.destinationAccountId) {
        return { ...acc, balance: acc.balance + dto.amount };
      }
      return acc;
    });

    const updatedTransactions = [newTx, ...get().transactions];
    LocalStorageService.setItem('transactions', updatedTransactions);
    LocalStorageService.setItem('accounts', updatedAccounts);

    set({ transactions: updatedTransactions, accounts: updatedAccounts });
  },

  deleteTransaction: (id) => {
    const updated = get().transactions.filter((tx) => tx.id !== id);
    LocalStorageService.setItem('transactions', updated);
    set({ transactions: updated });
  },

  addAccount: (dto) => {
    const newAcc: Account = {
      ...dto,
      id: `acc_${Date.now()}`,
      isExcludedFromTotal: dto.isExcludedFromTotal || false,
    };
    const updated = [...get().accounts, newAcc];
    LocalStorageService.setItem('accounts', updated);
    set({ accounts: updated });
  },

  addBudget: (dto) => {
    const newBudget: Budget = {
      ...dto,
      id: `bgt_${Date.now()}`,
      spent: 0,
    };
    const updated = [...get().budgets, newBudget];
    LocalStorageService.setItem('budgets', updated);
    set({ budgets: updated });
  },

  addDebt: (dto) => {
    const newDebt: Debt = {
      ...dto,
      id: `debt_${Date.now()}`,
      remainingAmount: dto.amount,
      isSettled: false,
      createdAt: Date.now(),
    };
    const updated = [newDebt, ...get().debts];
    LocalStorageService.setItem('debts', updated);
    set({ debts: updated });
  },

  settleDebt: (id) => {
    const updated = get().debts.map((d) => (d.id === id ? { ...d, isSettled: true, remainingAmount: 0 } : d));
    LocalStorageService.setItem('debts', updated);
    set({ debts: updated });
  },

  addRecurring: (dto) => {
    const newRec: RecurringTransaction = {
      ...dto,
      id: `rec_${Date.now()}`,
      isActive: true,
    };
    const updated = [...get().recurring, newRec];
    LocalStorageService.setItem('recurring', updated);
    set({ recurring: updated });
  },

  toggleRecurring: (id) => {
    const updated = get().recurring.map((r) => (r.id === id ? { ...r, isActive: !r.isActive } : r));
    LocalStorageService.setItem('recurring', updated);
    set({ recurring: updated });
  },

  resetAllData: () => {
    LocalStorageService.clearAll();
    set({
      accounts: INITIAL_ACCOUNTS,
      transactions: INITIAL_TRANSACTIONS,
      budgets: INITIAL_BUDGETS,
      debts: INITIAL_DEBTS,
      recurring: INITIAL_RECURRING,
    });
  },
}));
