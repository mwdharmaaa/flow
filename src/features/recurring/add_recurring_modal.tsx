import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { Modal } from '@/components/common/modal';
import { Input } from '@/components/common/input';
import { Button } from '@/components/common/button';
import { RecurringInterval } from '@/types/recurring.types';

interface AddRecurringModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const AddRecurringModal: React.FC<AddRecurringModalProps> = ({ isOpen, onClose }) => {
  const { accounts, addRecurring } = useAppStore();
  const [name, setName] = useState('');
  const [type, setType] = useState<'expense' | 'income'>('expense');
  const [amount, setAmount] = useState('');
  const [accountId, setAccountId] = useState(accounts[0]?.id || '');
  const [category, setCategory] = useState('Hiburan & Langganan');
  const [interval, setInterval] = useState<RecurringInterval>('monthly');
  const [nextDate, setNextDate] = useState(new Date().toISOString().split('T')[0]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const parsedAmount = parseFloat(amount);
    if (!name.trim() || !parsedAmount || parsedAmount <= 0) return;

    addRecurring({
      name: name.trim(),
      type,
      amount: parsedAmount,
      accountId,
      category,
      interval,
      nextExecutionDate: nextDate,
    });

    setName('');
    setAmount('');
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tambah Transaksi Rutin / Langganan">
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input
          label="Nama Langganan / Tagihan"
          placeholder="Contoh: Netflix, Spotify, Listrik PLN..."
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />

        <div className="grid grid-cols-2 gap-2 p-1 bg-surface rounded-xl border border-border">
          <button
            type="button"
            onClick={() => setType('expense')}
            className={`py-2 text-xs font-semibold rounded-lg ${
              type === 'expense'
                ? 'bg-rose-500/20 text-rose-300 border border-rose-500/30'
                : 'text-slate-400'
            }`}
          >
            Pengeluaran Rutin
          </button>
          <button
            type="button"
            onClick={() => setType('income')}
            className={`py-2 text-xs font-semibold rounded-lg ${
              type === 'income'
                ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30'
                : 'text-slate-400'
            }`}
          >
            Pemasukan Rutin
          </button>
        </div>

        <Input
          label="Nominal (Rp)"
          type="number"
          placeholder="Contoh: 186000"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          required
        />

        <div className="grid grid-cols-2 gap-3">
          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-400">Akun Sumber</label>
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

          <div className="space-y-1.5">
            <label className="block text-xs font-semibold text-slate-400">Kategori</label>
            <select
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              className="w-full px-3 py-2.5 bg-surface border border-border rounded-xl text-sm text-slate-100 focus:outline-none focus:border-blue-500"
            >
              <option value="Hiburan & Langganan">Hiburan & Langganan</option>
              <option value="Tagihan & Utilitas">Tagihan & Utilitas</option>
              <option value="Pendidikan">Pendidikan</option>
              <option value="Lain-lain">Lain-lain</option>
            </select>
          </div>
        </div>

        <div className="space-y-1.5">
          <label className="block text-xs font-semibold text-slate-400">Periode Rutin</label>
          <select
            value={interval}
            onChange={(e) => setInterval(e.target.value as RecurringInterval)}
            className="w-full px-3 py-2.5 bg-surface border border-border rounded-xl text-sm text-slate-100 focus:outline-none focus:border-blue-500"
          >
            <option value="daily">Harian</option>
            <option value="weekly">Mingguan</option>
            <option value="monthly">Bulanan</option>
            <option value="yearly">Tahunan</option>
          </select>
        </div>

        <Input
          label="Jadwal Eksekusi Pertama"
          type="date"
          value={nextDate}
          onChange={(e) => setNextDate(e.target.value)}
          required
        />

        <div className="pt-2">
          <Button type="submit" fullWidth>
            Simpan Jadwal Rutin
          </Button>
        </div>
      </form>
    </Modal>
  );
};
