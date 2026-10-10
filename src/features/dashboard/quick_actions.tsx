import React from 'react';
import { useAppStore } from '@/store/app.store';
import { BarChart3, Clock, HandCoins, ArrowRightLeft } from 'lucide-react';

interface QuickActionsProps {
  onOpenAddModal: (type?: 'expense' | 'income' | 'transfer') => void;
}

export const QuickActions: React.FC<QuickActionsProps> = ({ onOpenAddModal }) => {
  const setActiveTab = useAppStore((state) => state.setActiveTab);

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <h2 className="text-xs font-bold uppercase tracking-wider text-slate-400">
          Aksi Cepat & Navigasi Pro
        </h2>
      </div>

      <div className="grid grid-cols-4 gap-2 text-center">
        <button
          onClick={() => onOpenAddModal('transfer')}
          className="p-3 rounded-xl bg-surface hover:bg-card border border-border flex flex-col items-center gap-1.5 transition-all group"
        >
          <div className="p-2 rounded-lg bg-purple-500/10 text-purple-400 group-hover:scale-110 transition-transform">
            <ArrowRightLeft className="w-4 h-4" />
          </div>
          <span className="text-[11px] font-medium text-slate-300">Transfer</span>
        </button>

        <button
          onClick={() => setActiveTab('analytics')}
          className="p-3 rounded-xl bg-surface hover:bg-card border border-border flex flex-col items-center gap-1.5 transition-all group"
        >
          <div className="p-2 rounded-lg bg-blue-500/10 text-blue-400 group-hover:scale-110 transition-transform">
            <BarChart3 className="w-4 h-4" />
          </div>
          <span className="text-[11px] font-medium text-slate-300">Analitik</span>
        </button>

        <button
          onClick={() => setActiveTab('debts')}
          className="p-3 rounded-xl bg-surface hover:bg-card border border-border flex flex-col items-center gap-1.5 transition-all group"
        >
          <div className="p-2 rounded-lg bg-amber-500/10 text-amber-400 group-hover:scale-110 transition-transform">
            <HandCoins className="w-4 h-4" />
          </div>
          <span className="text-[11px] font-medium text-slate-300">Hutang</span>
        </button>

        <button
          onClick={() => setActiveTab('recurring')}
          className="p-3 rounded-xl bg-surface hover:bg-card border border-border flex flex-col items-center gap-1.5 transition-all group"
        >
          <div className="p-2 rounded-lg bg-emerald-500/10 text-emerald-400 group-hover:scale-110 transition-transform">
            <Clock className="w-4 h-4" />
          </div>
          <span className="text-[11px] font-medium text-slate-300">Rutin</span>
        </button>
      </div>
    </div>
  );
};
