module.exports = {
  plugins: [
    // Inline @import'ed CSS (the @fontsource files) while preserving each
    // declaration's source path so postcss-url can locate the font files.
    require('postcss-import'),
    // Copy referenced font files into app/assets/builds/fonts and rewrite the
    // url() to point there, so Propshaft can digest and serve them.
    require('postcss-url')({ url: 'copy', assetsPath: 'fonts', useHash: true, hashOptions: { append: true } }),
    require('@tailwindcss/postcss'),
    require('autoprefixer'),
    require('postcss-nesting'),
    require('postcss-flexbugs-fixes')
  ]
}
