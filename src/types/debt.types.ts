export type DebtType = 'payable' | 'receivable';

export interface Debt {
  id: string;
  type: DebtType;
  personName: string;
  amount: number;
  remainingAmount: number;
  dueDate: string;
  note: string;
  isSettled: boolean;
  createdAt: number;
}

export interface CreateDebtDto {
  type: DebtType;
  personName: string;
  amount: number;
  dueDate: string;
  note: string;
}
