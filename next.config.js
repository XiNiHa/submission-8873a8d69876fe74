const UnoCSS = require("@unocss/webpack").default;
const { presetUno, presetIcons } = require("unocss");

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  webpack: (config) => ({
    ...config,
    plugins: [
      ...config?.plugins,
      UnoCSS({
        include: ["src/**/*.mjs"],
        presets: [presetUno(), presetIcons()],
      }),
    ],
  }),
};

module.exports = nextConfig;
