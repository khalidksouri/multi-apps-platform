"use client"

import { LanguageProvider as Provider } from "@/hooks/useLanguage"

export function LanguageProvider({ children }: { children: React.ReactNode }) {
  return <Provider>{children}</Provider>
}
