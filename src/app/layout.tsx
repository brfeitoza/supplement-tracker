import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Supplement Tracker Web',
  description: 'An app to track your supplements',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
