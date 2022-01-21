# Integrating Typescript into frontend Codebase

*This will have to be re-worked, I don't have time to shave these Yaks*

Stages
 * Remove all flow types from all parts of the code, and remove flow plugins from babel
 * Convert CoffeeScript to Javascript and update all referenes. Remove Coffeescript loader from webpack.
 * Fix anything that would be a syntax error in Babel v7.0.0.
 * Upgrade Babel to v7.0.0
 * Add typescript to build process with the typescript preset. Add the typescript type chcker to pre-commit checks and CI.

## Potential Issues
 * Lots of coffeescript files, and coffeescript calling coffeescript
 * Sudden error in operator spreading: `SyntaxError: rest element may not have a trailing comma`
	 * This is appearantly, invalid javascript but was allowed by babel for some reason