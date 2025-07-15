export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validateWeight = (weight: number): boolean => {
  return weight > 0 && weight <= 30;
};
