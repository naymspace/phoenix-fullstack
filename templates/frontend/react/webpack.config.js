const path = require('path');
const glob = require('glob');
const TerserPlugin = require('terser-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebPackPlugin = require('html-webpack-plugin');
const webpack = require('webpack');
const CompressionPlugin = require('compression-webpack-plugin');

const isDevelopment = process.env.NODE_ENV === 'development';

module.exports = (env, options) => ({
  optimization: {
    minimizer: [new TerserPlugin({ cache: true, parallel: true, sourceMap: false }), new OptimizeCSSAssetsPlugin({})],
  },
  devServer: {
    compress: true,
    host: '0.0.0.0',
    sockHost: "localhost",
    sockPort: 80,
    port: 4001,
    contentBase: path.join(__dirname, 'static'),
    historyApiFallback: true,
    disableHostCheck: true
  },
  entry: {
    './src/app.tsx': glob.sync('./vendor/**/*.js').concat(['./src/app.tsx']),
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'webclient-[chunkhash].js',
    publicPath: '/'
  },
  module: {
    rules: [
      {
        test: /\.(j|t)sx?$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
          },
          {
            loader: 'ts-loader',
          },
        ],
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader'],
      },
      {
        test: /\.module\.s(a|c)ss$/,
        loader: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              modules: true,
              sourceMap: isDevelopment,
            },
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: isDevelopment,
            },
          },
        ],
      },
      {
        test: /\.s(a|c)ss$/,
        exclude: /\.module.(s(a|c)ss)$/,
        loader: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          {
            loader: 'sass-loader',
            options: {
              sourceMap: isDevelopment,
            },
          },
        ],
      },
      {
        test: /\.(woff(2)?|ttf|eot|png|svg)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: '../fonts/',
            },
          },
        ],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: isDevelopment ? 'dist/css/app.css' : 'css/app-[contenthash].css',
      chunkFilename: isDevelopment ? '[id].css' : '[id]-[contenthash].css',
    }),
    new CopyWebpackPlugin({ patterns: [{ from: 'static/', to: './' }] }),
    new HtmlWebPackPlugin({
      template: path.resolve(__dirname, 'public/index.html')
    }),
    new CompressionPlugin(),
    new webpack.DefinePlugin({
      'process.env.PAYPAL_MODE': JSON.stringify(process.env.PAYPAL_MODE),
    })
  ],
  resolve: {
    extensions: ['.ts', '.js', '.tsx', '.jsx', '.sass'],
  },
  node: {
    fs: 'empty',
  },
});
