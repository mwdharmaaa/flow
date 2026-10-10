export interface Budget {
  id: string;
  category: string;
  monthlyLimit: number;
  spent: number;
  color: string;
}

export interface CreateBudgetDto {
  category: string;
  monthlyLimit: number;
  color: string;
}
