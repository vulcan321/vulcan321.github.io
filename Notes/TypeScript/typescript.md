# # Typescript Tutorial

## # Get Started

Within your npm project,  run the following command to install the compiler:

```shell
npm install typescript --save-dev
```

then, the compiler is installed in the `node_modules`  directory and can be run with:

```shell
npx tsc
```

we can use the following command and configured the compiler by using a tsconfig.json

```shell
npx tsc --init
```

the config example it may be:

```json
{
  "include": ["src"],
  "compilerOptions": {
    "outDir": "./build"
  }
}
```

Typescript files located in the `src/` directory of your project, into JS files in `build/` directory