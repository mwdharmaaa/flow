import React from 'react';
import { useAppStore } from '@/store/app.store';
import { ExportDataCard } from './export_data_card';
import { BarChart3, HandCoins, Repeat, ShieldCheck, ChevronRight, Coins } from 'lucide-react';

export const SettingsView: React.FC = () => {
  const { setActiveTab, currency, setCurrency } = useAppStore();

  return (
    <div className="p-4 space-y-4">
      <div className="p-4 rounded-xl bg-card border border-border/70 space-y-3">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
          Fitur Tambahan & Laporan
        </h3>

        <div className="divide-y divide-border/40">
          <button
            onClick={() => setActiveTab('analytics')}
            className="w-full py-3 flex items-center justify-between text-left group"
          >
            <div className="flex items-center gap-3">
              <div className="p-2 rounded-lg bg-blue-500/10 text-blue-400">
                <BarChart3 className="w-4 h-4" />
              </div>
              <div>
                <h4 className="text-sm font-semibold text-slate-200">Analitik & Visualisasi</h4>
                <p className="text-[11px] text-subtle">Grafik kategori dan arus kas bulanan</p>
              </div>
            </div>
            <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-slate-300 transition-colors" />
          </button>

          <button
            onClick={() => setActiveTab('debts')}
            className="w-full py-3 flex items-center justify-between text-left group"
          >
            <div className="flex items-center gap-3">
              <div className="p-2 rounded-lg bg-amber-500/10 text-amber-400">
                <HandCoins className="w-4 h-4" />
              </div>
              <div>
                <h4 className="text-sm font-semibold text-slate-200">Catatan Hutang & Piutang</h4>
                <p className="text-[11px] text-subtle">Kelola pinjaman dan jatuh tempo</p>
              </div>
            </div>
            <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-slate-300 transition-colors" />
          </button>

          <button
            onClick={() => setActiveTab('recurring')}
            className="w-full py-3 flex items-center justify-between text-left group"
          >
            <div className="flex items-center gap-3">
              <div className="p-2 rounded-lg bg-emerald-500/10 text-emerald-400">
                <Repeat className="w-4 h-4" />
              </div>
              <div>
                <h4 className="text-sm font-semibold text-slate-200">Transaksi Rutin & Langganan</h4>
                <p className="text-[11px] text-subtle">Otomasi pengeluaran bulanan</p>
              </div>
            </div>
            <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-slate-300 transition-colors" />
          </button>
        </div>
      </div>

      <div className="p-4 rounded-xl bg-card border border-border/70 space-y-3">
        <div className="flex items-center gap-2 text-slate-200">
          <Coins className="w-4 h-4 text-blue-400" />
          <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
            Mata Uang Utama
          </h3>
        </div>

        <div className="grid grid-cols-3 gap-2">
          {['IDR', 'USD', 'EUR'].map((curr) => (
            <button
              key={curr}
              onClick={() => setCurrency(curr)}
              className={`py-2 px-3 rounded-lg text-xs font-semibold border transition-colors ${
                currency === curr
                  ? 'bg-blue-500/20 text-blue-400 border-blue-500/30'
                  : 'bg-surface text-slate-400 border-border hover:text-slate-200'
              }`}
            >
              {curr}
            </button>
          ))}
        </div>
      </div>

      <ExportDataCard />

      <div className="p-4 rounded-xl bg-surface border border-border/50 text-center space-y-1 text-xs text-subtle">
        <div className="flex items-center justify-center gap-1.5 text-slate-300 font-semibold">
          <ShieldCheck className="w-4 h-4 text-emerald-400" />
          <span>Flow Personal Finance v1.0.0</span>
        </div>
        <p>100% Offline Lokal • Tanpa Pelacak • Bebas Biaya Langganan</p>
      </div>
    </div>
  );
};
