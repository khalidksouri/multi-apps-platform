import { I18nLayout } from '../components/I18nLayout';
import './globals.css';

export const metadata = {
  title: 'MultiAI',
  description: 'Application multilingue MultiAI',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html>
      <body>
        <I18nLayout showLanguageSelector={true}>
          {children}
        </I18nLayout>
      </body>
    </html>
  );
}
