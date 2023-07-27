/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        flify: "#206AC4",
      },
      fontFamily: {
        flify: [
          "ArialRoundedBold",
          "system-ui",
          "-apple-system",
          "BlinkMacSystemFont",
          "Segoe UI",
          "Roboto",
          "Oxygen",
          "Ubuntu",
          "Cantarell",
          "Open Sans",
          "Helvetica Neue",
          "sans-serif",
        ],
      },
      animation: {
        update: "pulse 0.2s linear",
      },
    },
  },
  plugins: [],
};
