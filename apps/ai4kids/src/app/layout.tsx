import { I18nLayout } from '../components/I18nLayout';
import './globals.css';

export const metadata = {
  title: 'AI4Kids',
  description: 'Application multilingue AI4Kids',
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
