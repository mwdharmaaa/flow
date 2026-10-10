import React from 'react';
import { CategoryBreakdown } from './category_breakdown';
import { MonthlyTrend } from './monthly_trend';
import { BarChart3, Sparkles } from 'lucide-react';

export const AnalyticsView: React.FC = () => {
  return (
    <div className="p-4 space-y-4">
      <div className="p-4 rounded-xl bg-blue-500/10 border border-blue-500/20 flex items-center justify-between">
        <div className="flex items-center gap-2 text-blue-400">
          <BarChart3 className="w-5 h-5" />
          <div>
            <h3 className="text-xs font-bold uppercase tracking-wider">Analitik & Visualisasi Mendalam</h3>
            <p className="text-[11px] text-slate-300">Fitur Premium Terbuka Penuh & Berjalan 100% Offline</p>
          </div>
        </div>
        <Sparkles className="w-4 h-4 text-blue-400" />
      </div>

      <MonthlyTrend />

      <CategoryBreakdown />
    </div>
  );
};
