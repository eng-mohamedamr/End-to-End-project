import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "TaskBoard",
  description: "A tiny task manager deployed on AWS with EKS, CloudFront and Argo CD",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
