#!/usr/bin/env node
const webpack = require("webpack")
const WebpackDevServer = require('webpack-dev-server')
import config, { devServerIp } from './webpack.dev.babel.js';
import { argv } from "yargs"
let { p, port, usingDocker } = argv
port = port || p || 8001

const host = usingDocker ? "0.0.0.0" : "localhost"
const devServerHosts = `${devServerIp}:*`

new WebpackDevServer(webpack(config), {
    // disableHostCheck: true,
    public: devServerHosts,
    publicPath: config.output.publicPath,
    inline: true,
    historyApiFallback: true,
    headers: {
        // I wanted to do this, but wildcards are not allowed
        // https://stackoverflow.com/questions/19743396/cors-cannot-use-wildcard-in-access-control-allow-origin-when-credentials-flag-i
        // "Access-Control-Allow-Origin": `http://${devServerIp}:*`,
        "Access-Control-Allow-Origin": "*",
        // "Access-Control-Allow-Origin": argv.port ? "*" : "http://localhost:8000"
    },
    stats: {
        assets: false,
        colors: true,
        version: false,
        hash: false,
        timings: false,
        chunks: false,
        chunkModules: false
    }
})
    .listen(port, host, (err, result) => {
        if (err) {
            console.log(err);
        }
        return console.log(`Listening at ${host}:${port}`)
    })
