export type RecurringInterval = 'daily' | 'weekly' | 'monthly' | 'yearly';

export interface RecurringTransaction {
  id: string;
  name: string;
  type: 'expense' | 'income';
  amount: number;
  accountId: string;
  category: string;
  interval: RecurringInterval;
  nextExecutionDate: string;
  isActive: boolean;
}

export interface CreateRecurringDto {
  name: string;
  type: 'expense' | 'income';
  amount: number;
  accountId: string;
  category: string;
  interval: RecurringInterval;
  nextExecutionDate: string;
}
