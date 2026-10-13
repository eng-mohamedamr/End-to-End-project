import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Static export: `next build` writes plain HTML/JS/CSS to ./out, which is uploaded to S3
  output: "export",
  images: { unoptimized: true },
};

export default nextConfig;
