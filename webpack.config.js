var path = require('path');
var webpack = require('webpack');

module.exports = {
  cache: true,
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" }
    ],
    preLoaders: [
      { test: /\.coffee$/, exclude: /node_modules/, loader: "coffeelint" }
    ]
  },
  resolve: {
    extensions: ["", ".coffee", ".js"],
  },
  entry: './src/index',
  output: {
    library: 'moment',
    libraryTarget: 'umd',
    path: path.join(__dirname,"dist"),
    filename: "moment-timezone-micro.js",
  },
  plugins: [
          new webpack.optimize.UglifyJsPlugin()
      ]
}
