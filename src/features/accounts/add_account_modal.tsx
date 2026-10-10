import React, { useState } from 'react';
import { useAppStore } from '@/store/app.store';
import { Modal } from '@/components/common/modal';
import { Input } from '@/components/common/input';
import { Button } from '@/components/common/button';
import { AccountType } from '@/types/account.types';

interface AddAccountModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const COLORS = [
  '#3B82F6', // Blue
  '#10B981', // Emerald
  '#8B5CF6', // Purple
  '#F59E0B', // Amber
  '#EC4899', // Pink
  '#06B6D4', // Cyan
  '#F43F5E', // Rose
];

export const AddAccountModal: React.FC<AddAccountModalProps> = ({
  isOpen,
  onClose,
}) => {
  const addAccount = useAppStore((state) => state.addAccount);
  const [name, setName] = useState('');
  const [type, setType] = useState<AccountType>('bank');
  const [balance, setBalance] = useState('');
  const [color, setColor] = useState(COLORS[0]);
  const [isExcluded, setIsExcluded] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;

    addAccount({
      name: name.trim(),
      type,
      balance: parseFloat(balance) || 0,
      color,
      isExcludedFromTotal: isExcluded,
    });

    setName('');
    setBalance('');
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Tambah Dompet / Rekening">
      <form onSubmit={handleSubmit} className="space-y-4">
        <Input
          label="Nama Akun"
          placeholder="Contoh: Bank Mandiri, Dompet Harian..."
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />

        <div className="space-y-1.5">
          <label className="block text-xs font-semibold text-slate-400">Tipe Akun</label>
          <select
            value={type}
            onChange={(e) => setType(e.target.value as AccountType)}
            className="w-full px-3 py-2.5 bg-surface border border-border rounded-xl text-sm text-slate-100 focus:outline-none focus:border-blue-500"
          >
            <option value="cash">Uang Tunai / Cash</option>
            <option value="bank">Rekening Bank</option>
            <option value="ewallet">E-Wallet (GoPay, OVO, DANA)</option>
            <option value="investment">Investasi / Tabungan Darurat</option>
            <option value="credit">Kartu Kredit / PayLater</option>
          </select>
        </div>

        <Input
          label="Saldo Awal (Rp)"
          type="number"
          placeholder="Contoh: 1000000"
          value={balance}
          onChange={(e) => setBalance(e.target.value)}
        />

        <div className="space-y-1.5">
          <label className="block text-xs font-semibold text-slate-400">Pilih Warna Aset</label>
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

        <div className="flex items-center gap-2 pt-1">
          <input
            type="checkbox"
            id="exclude"
            checked={isExcluded}
            onChange={(e) => setIsExcluded(e.target.checked)}
            className="rounded border-border text-blue-600 focus:ring-blue-500 bg-surface"
          />
          <label htmlFor="exclude" className="text-xs text-slate-300">
            Abaikan saldo ini dari total saldo bersih
          </label>
        </div>

        <div className="pt-2">
          <Button type="submit" fullWidth>
            Simpan Dompet Baru
          </Button>
        </div>
      </form>
    </Modal>
  );
};
