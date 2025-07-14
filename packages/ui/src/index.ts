// =============================================
// 📄 packages/ui/src/index.ts - Export principal
// =============================================

// Composants de base
export { Button } from './components/Button';
export { Input } from './components/Input';
export { Card, CardHeader, CardTitle, CardContent } from './components/Card';
export { Select } from './components/Select';
export { Modal } from './components/Modal';

// Composants de feedback
export { Spinner } from './components/Spinner';
export { Alert } from './components/Alert';
export { Badge } from './components/Badge';
export { Tooltip } from './components/Tooltip';
export { Progress } from './components/Progress';

// Composants d'interface
export { Tabs } from './components/Tabs';
export { Switch } from './components/Switch';
export { Table } from './components/Table';

// Utilitaires
export { cn } from './utils/cn';

// Types
export type {
  ButtonProps,
  InputProps,
  CardProps,
  SelectProps,
  ModalProps,
  SpinnerProps,
  AlertProps,
  BadgeProps,
  TooltipProps,
  ProgressProps,
  TabsProps,
  SwitchProps,
  TableProps
} from './types';

// Constantes et configurations
export const UI_CONFIG = {
  themes: {
    light: 'light',
    dark: 'dark'
  },
  sizes: {
    sm: 'sm',
    md: 'md',
    lg: 'lg'
  },
  variants: {
    primary: 'primary',
    secondary: 'secondary',
    success: 'success',
    warning: 'warning',
    error: 'error',
    info: 'info'
  }
} as const;