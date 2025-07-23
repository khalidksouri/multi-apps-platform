// Exemple d'utilisation du système de langues
import { LanguageProvider } from './contexts/LanguageContext'
import AdvancedLanguageDropdown from './components/language/LanguageDropdown'

export default function ExampleLayout({ children }: { children: React.ReactNode }) {
  return (
    <LanguageProvider>
      <header className="flex justify-between items-center p-4">
        <h1>Math4Child</h1>
        <AdvancedLanguageDropdown />
      </header>
      {children}
    </LanguageProvider>
  )
}
