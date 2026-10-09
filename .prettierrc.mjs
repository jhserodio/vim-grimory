/** @type {import("prettier").Config} */

export default {
  plugins: [
    "prettier-plugin-astro",
    "prettier-plugin-tailwindcss",
  ],

  // Tailwind CSS v4:
  // Adjust this path to your actual stylesheet.
  tailwindStylesheet: "./src/styles/global.css",

  overrides: [
    {
      files: "*.astro",
      options: {
        parser: "astro",
      },
    },
  ],
};
;
