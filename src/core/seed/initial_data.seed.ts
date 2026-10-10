import { Account } from '@/types/account.types';
import { Budget } from '@/types/budget.types';
import { Transaction } from '@/types/transaction.types';
import { Debt } from '@/types/debt.types';
import { RecurringTransaction } from '@/types/recurring.types';

export const INITIAL_ACCOUNTS: Account[] = [
  {
    id: 'acc_1',
    name: 'Cash / Dompet',
    type: 'cash',
    balance: 750000,
    color: '#10B981',
    isExcludedFromTotal: false,
  },
  {
    id: 'acc_2',
    name: 'Bank BCA',
    type: 'bank',
    balance: 6850000,
    color: '#3B82F6',
    isExcludedFromTotal: false,
  },
  {
    id: 'acc_3',
    name: 'GoPay / OVO',
    type: 'ewallet',
    balance: 420000,
    color: '#8B5CF6',
    isExcludedFromTotal: false,
  },
  {
    id: 'acc_4',
    name: 'Tabungan Darurat',
    type: 'investment',
    balance: 15000000,
    color: '#F59E0B',
    isExcludedFromTotal: false,
  },
];

export const INITIAL_BUDGETS: Budget[] = [
  {
    id: 'bgt_1',
    category: 'Makanan & Minuman',
    monthlyLimit: 2500000,
    spent: 980000,
    color: '#F43F5E',
  },
  {
    id: 'bgt_2',
    category: 'Transportasi',
    monthlyLimit: 800000,
    spent: 320000,
    color: '#3B82F6',
  },
  {
    id: 'bgt_3',
    category: 'Hiburan & Langganan',
    monthlyLimit: 600000,
    spent: 190000,
    color: '#8B5CF6',
  },
  {
    id: 'bgt_4',
    category: 'Tagihan & Utilitas',
    monthlyLimit: 1500000,
    spent: 650000,
    color: '#EAB308',
  },
];

export const INITIAL_TRANSACTIONS: Transaction[] = [
  {
    id: 'tx_1',
    type: 'income',
    amount: 12000000,
    accountId: 'acc_2',
    category: 'Gaji Bulanan',
    date: new Date().toISOString().split('T')[0],
    note: 'Gaji Oktober 2026',
    createdAt: Date.now() - 86400000 * 3,
  },
  {
    id: 'tx_2',
    type: 'expense',
    amount: 45000,
    accountId: 'acc_1',
    category: 'Makanan & Minuman',
    date: new Date().toISOString().split('T')[0],
    note: 'Kopi dan sarapan',
    createdAt: Date.now() - 86400000 * 2,
  },
  {
    id: 'tx_3',
    type: 'expense',
    amount: 150000,
    accountId: 'acc_3',
    category: 'Transportasi',
    date: new Date().toISOString().split('T')[0],
    note: 'Bensin & Tol',
    createdAt: Date.now() - 86400000,
  },
  {
    id: 'tx_4',
    type: 'transfer',
    amount: 500000,
    accountId: 'acc_2',
    destinationAccountId: 'acc_3',
    category: 'Transfer Saldo',
    date: new Date().toISOString().split('T')[0],
    note: 'Top up GoPay dari BCA',
    createdAt: Date.now(),
  },
];

export const INITIAL_DEBTS: Debt[] = [
  {
    id: 'debt_1',
    type: 'receivable',
    personName: 'Rian Pratama',
    amount: 250000,
    remainingAmount: 250000,
    dueDate: '2026-10-25',
    note: 'Talangan beli tiket',
    isSettled: false,
    createdAt: Date.now() - 86400000 * 4,
  },
];

export const INITIAL_RECURRING: RecurringTransaction[] = [
  {
    id: 'rec_1',
    name: 'Netflix & Spotify',
    type: 'expense',
    amount: 186000,
    accountId: 'acc_3',
    category: 'Hiburan & Langganan',
    interval: 'monthly',
    nextExecutionDate: '2026-11-01',
    isActive: true,
  },
];
