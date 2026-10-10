import React from 'react';
import { useAppStore } from '@/store/app.store';
import { Download, Database, RotateCcw } from 'lucide-react';

export const ExportDataCard: React.FC = () => {
  const { transactions, accounts, budgets, debts, recurring, resetAllData } = useAppStore();

  const handleExportCSV = () => {
    const headers = 'ID,Tipe,Nominal,Kategori,Akun,Tanggal,Catatan\n';
    const rows = transactions
      .map(
        (tx) =>
          `"${tx.id}","${tx.type}","${tx.amount}","${tx.category}","${tx.accountId}","${tx.date}","${tx.note.replace(/"/g, '""')}"`
      )
      .join('\n');

    const blob = new Blob([headers + rows], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `flow_transactions_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleExportJSON = () => {
    const backupData = {
      version: '1.0',
      exportedAt: new Date().toISOString(),
      accounts,
      transactions,
      budgets,
      debts,
      recurring,
    };

    const blob = new Blob([JSON.stringify(backupData, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', `flow_backup_${new Date().toISOString().split('T')[0]}.json`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleReset = () => {
    if (window.confirm('Apakah kamu yakin ingin mereset data kembali ke pengaturan awal?')) {
      resetAllData();
    }
  };

  return (
    <div className="p-4 rounded-xl bg-card border border-border/70 space-y-3">
      <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
        Cadangan & Ekspor Data Lokal
      </h3>
      <p className="text-xs text-subtle">
        Fitur ekspor CSV dan backup JSON lengkap tersedia gratis tanpa batas.
      </p>

      <div className="grid grid-cols-2 gap-2 pt-1">
        <button
          onClick={handleExportCSV}
          className="p-3 rounded-xl bg-surface hover:bg-card-hover border border-border flex items-center gap-2 text-xs font-semibold text-slate-200 transition-colors"
        >
          <Download className="w-4 h-4 text-emerald-400" />
          <span>Ekspor CSV</span>
        </button>

        <button
          onClick={handleExportJSON}
          className="p-3 rounded-xl bg-surface hover:bg-card-hover border border-border flex items-center gap-2 text-xs font-semibold text-slate-200 transition-colors"
        >
          <Database className="w-4 h-4 text-blue-400" />
          <span>Backup JSON</span>
        </button>
      </div>

      <div className="pt-2 border-t border-border/40">
        <button
          onClick={handleReset}
          className="w-full py-2.5 px-3 rounded-xl bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border border-rose-500/20 text-xs font-semibold flex items-center justify-center gap-1.5 transition-colors"
        >
          <RotateCcw className="w-3.5 h-3.5" />
          <span>Reset ke Data Bawaan</span>
        </button>
      </div>
    </div>
  );
};
