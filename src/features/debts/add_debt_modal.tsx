import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { Modal } from '@/components/common/modal';
import { Input } from '@/components/common/input';
import { Button } from '@/components/common/button';
import { DebtType } from '@/types/debt.types';

interface AddDebtModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const AddDebtModal: React.FC<AddDebtModalProps> = ({ isOpen, onClose }) => {
  const addDebt = useAppStore((state) => state.addDebt);
  const [type, setType] = useState<DebtType>('receivable');
  const [personName, setPersonName] = useState('');
  const [amount, setAmount] = useState('');
  const [dueDate, setDueDate] = useState(new Date().toISOString().split('T')[0]);
  const [note, setNote] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const parsedAmount = parseFloat(amount);
    if (!personName.trim() || !parsedAmount || parsedAmount <= 0) return;

    addDebt({
      type,
      personName: personName.trim(),
      amount: parsedAmount,
      dueDate,
      note,
    });

    setPersonName('');
    setAmount('');
    setNote('');
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tambah Catatan Hutang / Piutang">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-2 gap-2 p-1 bg-surface rounded-xl border border-border">
          <button
            type="button"
            onClick={() => setType('receivable')}
            className={`py-2 text-xs font-semibold rounded-lg transition-colors ${
              type === 'receivable'
                ? 'bg-emerald-500/20 text-emerald-300 border border-emerald-500/30'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            Piutang (Dipinjamkan)
          </button>
          <button
            type="button"
            onClick={() => setType('payable')}
            className={`py-2 text-xs font-semibold rounded-lg transition-colors ${
              type === 'payable'
                ? 'bg-rose-500/20 text-rose-300 border border-rose-500/30'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            Hutang (Meminjam)
          </button>
        </div>

        <Input
          label="Nama Orang / Pihak"
          placeholder="Contoh: Rian, Teman Kantor..."
          value={personName}
          onChange={(e) => setPersonName(e.target.value)}
          required
        />

        <Input
          label="Nominal (Rp)"
          type="number"
          placeholder="Contoh: 250000"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          required
        />

        <Input
          label="Tanggal Jatuh Tempo"
          type="date"
          value={dueDate}
          onChange={(e) => setDueDate(e.target.value)}
          required
        />

        <Input
          label="Catatan (Opsional)"
          placeholder="Contoh: Beli tiket konser bersama..."
          value={note}
          onChange={(e) => setNote(e.target.value)}
        />

        <div className="pt-2">
          <Button type="submit" fullWidth>
            Simpan Catatan
          </Button>
        </div>
      </form>
    </Modal>
  );
};
