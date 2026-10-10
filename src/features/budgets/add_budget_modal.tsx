import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { Modal } from '@/components/common/modal';
import { Input } from '@/components/common/input';
import { Button } from '@/components/common/button';

interface AddBudgetModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const CATEGORIES = [
  'Makanan & Minuman',
  'Transportasi',
  'Belanja',
  'Hiburan & Langganan',
  'Tagihan & Utilitas',
  'Kesehatan',
  'Pendidikan',
  'Lain-lain',
];

const COLORS = ['#F43F5E', '#3B82F6', '#8B5CF6', '#EAB308', '#10B981', '#EC4899'];

export const AddBudgetModal: React.FC<AddBudgetModalProps> = ({ isOpen, onClose }) => {
  const addBudget = useAppStore((state) => state.addBudget);
  const [category, setCategory] = useState(CATEGORIES[0]);
  const [monthlyLimit, setMonthlyLimit] = useState('');
  const [color, setColor] = useState(COLORS[0]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const limit = parseFloat(monthlyLimit);
    if (!limit || limit <= 0) return;

    addBudget({
      category,
      monthlyLimit: limit,
      color,
    });

    setMonthlyLimit('');
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tambah Anggaran Baru">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="space-y-1.5">
          <label className="block text-xs font-semibold text-slate-400">Pilih Kategori</label>
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

        <Input
          label="Batas Bulanan (Rp)"
          type="number"
          placeholder="Contoh: 1500000"
          value={monthlyLimit}
          onChange={(e) => setMonthlyLimit(e.target.value)}
          required
        />

        <div className="space-y-1.5">
          <label className="block text-xs font-semibold text-slate-400">Warna Indikator</label>
          <div className="flex items-center gap-2 pt-1">
            {COLORS.map((c) => (
              <button
                key={c}
                type="button"
                onClick={() => setColor(c)}
                className={`w-7 h-7 rounded-full border-2 transition-transform ${
                  color === c ? 'scale-125 border-white shadow-lg' : 'border-transparent'
                }`}
                style={{ backgroundColor: c }}
              />
            ))}
          </div>
        </div>

        <div className="pt-2">
          <Button type="submit" fullWidth>
            Simpan Anggaran
          </Button>
        </div>
      </form>
    </Modal>
  );
};
