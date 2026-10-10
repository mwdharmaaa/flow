import React from 'react';
import { useAppStore } from '@/store/app.store';
import { Sparkles, ShieldCheck } from 'lucide-react';

export const TopHeader: React.FC = () => {
  const activeTab = useAppStore((state) => state.activeTab);

  const titles: Record<string, string> = {
    dashboard: 'Flow',
    transactions: 'Riwayat Transaksi',
    accounts: 'Dompet & Rekening',
    budgets: 'Anggaran Bulanan',
    analytics: 'Laporan & Analitik',
    debts: 'Catatan Hutang & Piutang',
    recurring: 'Langganan & Rutin',
    settings: 'Pengaturan & Cadangan',
  };

  return (
    <header className="sticky top-0 z-40 bg-background/90 backdrop-blur-md px-5 py-4 border-b border-border/50 flex items-center justify-between">
      <div>
        <div className="flex items-center gap-2">
          <h1 className="text-xl font-bold tracking-tight text-white">
            {titles[activeTab] || 'Flow'}
          </h1>
          {activeTab === 'dashboard' && (
            <span className="flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
              <ShieldCheck className="w-3 h-3" />
              Lokal Penuh
            </span>
          )}
        </div>
        <p className="text-xs text-subtle mt-0.5">
          {activeTab === 'dashboard' ? 'Semua Fitur Premium Terbuka Bebas' : 'Manajemen Finansial Mandiri'}
        </p>
      </div>

      <div className="flex items-center gap-1 px-2.5 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-xs font-semibold">
        <Sparkles className="w-3.5 h-3.5" />
        PRO AKTIF
      </div>
    </header>
  );
};
