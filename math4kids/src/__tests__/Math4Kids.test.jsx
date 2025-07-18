import { describe, it, expect, beforeEach, vi } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import Math4Kids from '../App';

const localStorageMock = {
  getItem: vi.fn(),
  setItem: vi.fn(),
  removeItem: vi.fn(),
  clear: vi.fn(),
};
Object.defineProperty(window, 'localStorage', {
  value: localStorageMock
});

describe('Math4Kids App', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    localStorageMock.getItem.mockReturnValue(null);
  });

  it('renders the app correctly', () => {
    render(<Math4Kids />);
    expect(screen.getByText('Math4Kids')).toBeInTheDocument();
    expect(screen.getByText(/Question 1/)).toBeInTheDocument();
  });

  it('allows input and shows validation button', async () => {
    const user = userEvent.setup();
    render(<Math4Kids />);
    
    const input = screen.getByRole('spinbutton');
    const validateButton = screen.getByText('Validate');
    
    await user.type(input, '5');
    
    expect(input.value).toBe('5');
    expect(validateButton).not.toBeDisabled();
  });

  it('changes language correctly', async () => {
    const user = userEvent.setup();
    render(<Math4Kids />);
    
    const select = screen.getByRole('combobox');
    await user.selectOptions(select, 'fr');
    
    await waitFor(() => {
      expect(screen.getByText('Question')).toBeInTheDocument();
    });
  });
});
