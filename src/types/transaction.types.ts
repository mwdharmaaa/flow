export type TransactionType = 'expense' | 'income' | 'transfer';

export interface Transaction {
  id: string;
  type: TransactionType;
  amount: number;
  accountId: string;
  destinationAccountId?: string;
  category: string;
  date: string;
  note: string;
  createdAt: number;
}

export interface CreateTransactionDto {
  type: TransactionType;
  amount: number;
  accountId: string;
  destinationAccountId?: string;
  category: string;
  date: string;
  note: string;
}
