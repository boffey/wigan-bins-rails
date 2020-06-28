module.exports = {
  purge: [
    './app/views/**/*.html.erb',
    './app/javascript/components/**/*.vue',
  ],
  theme: {
    extend: {
      colors: {
        'modal-backdrop': "rgba(34, 41, 47, 0.8)"
      }
    },
  },
  variants: {},
  plugins: [],
}
