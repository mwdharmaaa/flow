import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { Modal } from '@/components/common/modal';
import { Input } from '@/components/common/input';
import { Button } from '@/components/common/button';
import { TransactionType } from '@/types/transaction.types';

interface AddTransactionModalProps {
  isOpen: boolean;
  onClose: () => void;
  defaultType?: TransactionType;
}

const CATEGORIES = [
  'Makanan & Minuman',
  'Transportasi',
  'Belanja',
  'Hiburan & Langganan',
  'Tagihan & Utilitas',
  'Kesehatan',
  'Pendidikan',
  'Gaji Bulanan',
  'Bonus & Hadiah',
  'Investasi',
  'Lain-lain',
];

export const AddTransactionModal: React.FC<AddTransactionModalProps> = ({
  isOpen,
  onClose,
  defaultType = 'expense',
}) => {
  const { accounts, addTransaction } = useAppStore();
  const [type, setType] = useState<TransactionType>(defaultType);
  const [amount, setAmount] = useState<string>('');
  const [accountId, setAccountId] = useState<string>(accounts[0]?.id || '');
  const [destinationAccountId, setDestinationAccountId] = useState<string>(accounts[1]?.id || '');
  const [category, setCategory] = useState<string>(CATEGORIES[0]);
  const [date, setDate] = useState<string>(new Date().toISOString().split('T')[0]);
  const [note, setNote] = useState<string>('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const parsedAmount = parseFloat(amount);
    if (!parsedAmount || parsedAmount <= 0) return;

    addTransaction({
      type,
      amount: parsedAmount,
      accountId,
      destinationAccountId: type === 'transfer' ? destinationAccountId : undefined,
      category: type === 'transfer' ? 'Transfer Saldo' : category,
      date,
      note,
    });

    setAmount('');
    setNote('');
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tambah Transaksi Baru">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-3 gap-2 p-1 bg-surface rounded-xl border border-border">
          {(['expense', 'income', 'transfer'] as TransactionType[]).map((t) => (
            <button
              key={t}
              type="button"
              onClick={() => setType(t)}
              className={`py-2 text-xs font-semibold rounded-lg capitalize transition-colors ${
                type === t
                  ? t === 'expense'
                    ? 'bg-rose-500/20 text-rose-300 border border-rose-500/30'
                    : t === 'income'
                    ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30'
                    : 'bg-purple-500/20 text-purple-300 border border-purple-500/30'
                  : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              {t === 'expense' ? 'Pengeluaran' : t === 'income' ? 'Pemasukan' : 'Transfer'}
            </button>
          ))}
        </div>

        <Input
          label="Nominal (Rp)"
          type="number"
          placeholder="Contoh: 50000"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          required
        />

        <div className="grid grid-cols-2 gap-3">
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-400">
              {type === 'transfer' ? 'Dari Akun' : 'Akun Dompet'}
            </label>
            <select
              value={accountId}
              onChange={(e) => setAccountId(e.target.value)}
              className="w-full px-3 py-2.5 bg-surface border border-border rounded-xl text-sm text-slate-100 focus:outline-none focus:border-blue-500"
            >
              {accounts.map((a) => (
                <option key={a.id} value={a.id}>
                  {a.name}
                </option>
              ))}
            </select>
          </div>

          {type === 'transfer' ? (
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-slate-400">Ke Akun Tujuan</label>
              <select
                value={destinationAccountId}
                onChange={(e) => setDestinationAccountId(e.target.value)}
                className="w-full px-3 py-2.5 bg-surface border border-border rounded-xl text-sm text-slate-100 focus:outline-none focus:border-blue-500"
              >
                {accounts
                  .filter((a) => a.id !== accountId)
                  .map((a) => (
                    <option key={a.id} value={a.id}>
                      {a.name}
                    </option>
                  ))}
              </select>
            </div>
          ) : (
            <div className="space-y-1.5">
              <label className="block text-xs font-semibold text-slate-400">Kategori</label>
              <select
                value={category}
                onChange={(e) => setCategory(e.target.value)}
                className="w-full px-3 py-2.5 bg-surface border border-border rounded-xl text-sm text-slate-100 focus:outline-none focus:border-blue-500"
              >
                {CATEGORIES.map((cat) => (
                  <option key={cat} value={cat}>
                    {cat}
                  </option>
                ))}
              </select>
            </div>
          )}
        </div>

        <Input
          label="Tanggal"
          type="date"
          value={date}
          onChange={(e) => setDate(e.target.value)}
          required
        />

        <Input
          label="Catatan (Opsional)"
          placeholder="Keterangan transaksi..."
          value={note}
          onChange={(e) => setNote(e.target.value)}
        />

        <div className="pt-2">
          <Button type="submit" fullWidth>
            Simpan Transaksi
          </Button>
        </div>
      </form>
    </Modal>
  );
};
