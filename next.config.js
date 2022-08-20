const UnoCSS = require("@unocss/webpack").default;
const { presetUno, presetIcons } = require("unocss");

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  webpack: (config, options) => {
    config.plugins.push(
        UnoCSS({
          include: ["src/**/*.cjs"],
          presets: [presetUno(), presetIcons()],
        })
      );

    config.module.rules.push({
      test: /\.(c|m)?js$/,
      use: options.defaultLoaders.babel,
      exclude: /node_modules/,
      type: "javascript/auto",
      resolve: {
        fullySpecified: false,
      },
    })

    return config
  },
};

module.exports = nextConfig;
