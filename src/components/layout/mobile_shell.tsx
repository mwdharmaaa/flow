import React from 'react';

interface MobileShellProps {
  children: React.ReactNode;
}

export const MobileShell: React.FC<MobileShellProps> = ({ children }) => {
  return (
    <div className="min-h-screen bg-background flex justify-center selection:bg-blue-500/30">
      <div className="w-full max-w-md min-h-screen bg-background flex flex-col relative pb-24 shadow-2xl border-x border-border/40">
        {children}
      </div>
    </div>
  );
};
