export type AccountType = 'cash' | 'bank' | 'ewallet' | 'investment' | 'credit';

export interface Account {
  id: string;
  name: string;
  type: AccountType;
  balance: number;
  color: string;
  isExcludedFromTotal: boolean;
}

export interface CreateAccountDto {
  name: string;
  type: AccountType;
  balance: number;
  color: string;
  isExcludedFromTotal?: boolean;
}
