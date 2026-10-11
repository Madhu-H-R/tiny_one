import './globals.css';
import React from 'react';

export const metadata = {
  title: 'Genie AI — Your Intelligent Assistant',
  description: 'Genie AI — Chat with local & cloud LLMs, analyze documents with RAG, and store long-term memories.',
};

export const viewport = {
  width: 'device-width',
  initialScale: 1,
  maximumScale: 1,
  viewportFit: 'cover',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className="dark">
      <head>
        {/* Google Sign-In for Web (GSI) — loads the real Google OAuth SDK */}
        <script src="https://accounts.google.com/gsi/client" async defer />
      </head>
      <body className="bg-[#121214] text-[#f3f3f6] min-h-screen flex flex-col antialiased relative">
        {children}
        {/* MADHU HR Bottom-Right Watermark */}
        <div
          className="fixed bottom-3 right-4 z-50 pointer-events-none select-none text-xs font-semibold tracking-widest text-white/30 uppercase drop-shadow-sm"
          aria-hidden="true"
        >
          MADHU HR
        </div>
      </body>
    </html>
  );
}
