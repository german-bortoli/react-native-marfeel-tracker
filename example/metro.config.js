const path = require('path');
const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');

const root = path.resolve(__dirname, '..');

const config = {
  // Make Metro able to resolve required external dependencies
  watchFolders: [root, path.resolve(__dirname, '../src')],
  resolver: {
    extraNodeModules: {
      'react-native': path.resolve(__dirname, 'node_modules/react-native'),
      // Resolve the local workspace library to its source during development
      'react-native-marfeel-tracker': path.resolve(root, 'src'),
    },
    unstable_enableSymlinks: true,
  },
};

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
module.exports = (async () => {
  const { withMetroConfig } = await import('react-native-monorepo-config');

  return mergeConfig(
    withMetroConfig(getDefaultConfig(__dirname), {
      root,
      dirname: __dirname,
    }),
    config
  );
})();
