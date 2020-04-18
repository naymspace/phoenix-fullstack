// vue.config.js
module.exports = {
    outputDir: '../priv/static',
    filenameHashing: false,
    chainWebpack: config => {
        // Disable generating the vue index.html - the Phoenix Live template generate its one
        config.plugins.delete('html');
        config.plugins.delete('preload');
        config.plugins.delete('prefetch');
    }
};
