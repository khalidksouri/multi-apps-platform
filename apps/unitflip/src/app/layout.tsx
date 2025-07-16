import { I18nLayout } from '../components/I18nLayout';
import './globals.css';

export const metadata = {
  title: 'UnitFlip Pro',
  description: 'Application multilingue UnitFlip Pro',
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
