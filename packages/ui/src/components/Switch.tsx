// =============================================
// 📄 packages/ui/src/components/Switch.tsx
// =============================================
import React from 'react';
import { clsx } from 'clsx';

interface SwitchProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label?: string;
  disabled?: boolean;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export const Switch: React.FC<SwitchProps> = ({
  checked,
  onChange,
  label,
  disabled = false,
  size = 'md',
  className
}) => {
  const sizeClasses = {
    sm: 'w-8 h-5',
    md: 'w-11 h-6',
    lg: 'w-14 h-7'
  };

  const thumbSizeClasses = {
    sm: 'w-4 h-4',
    md: 'w-5 h-5',
    lg: 'w-6 h-6'
  };

  const translateClasses = {
    sm: checked ? 'translate-x-3' : 'translate-x-0',
    md: checked ? 'translate-x-5' : 'translate-x-0',
    lg: checked ? 'translate-x-7' : 'translate-x-0'
  };

  return (
    <label className={clsx('flex items-center cursor-pointer', className)}>
      <div className="relative">
        <input
          type="checkbox"
          checked={checked}
          onChange={(e) => onChange(e.target.checked)}
          disabled={disabled}
          className="sr-only"
        />
        <div
          className={clsx(
            'rounded-full transition-colors duration-200',
            sizeClasses[size],
            checked ? 'bg-blue-600' : 'bg-gray-200',
            disabled && 'opacity-50 cursor-not-allowed'
          )}
        >
          <div
            className={clsx(
              'absolute top-0.5 left-0.5 bg-white rounded-full transition-transform duration-200',
              thumbSizeClasses[size],
              translateClasses[size]
            )}
          />
        </div>
      </div>
      {label && (
        <span className="ml-3 text-sm text-gray-700">{label}</span>
      )}
    </label>
  );
};