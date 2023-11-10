import * as assets from "hanami-assets";
import {sassPlugin} from 'esbuild-sass-plugin'

await assets.run({
  esbuildOptionsFn: (args, esbuildOptions) => {
    const plugins = [...esbuildOptions.plugins, sassPlugin()];

    return {
      ...esbuildOptions,
      plugins,
    };
  },
});
