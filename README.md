# Bioinformatics Zen Eleventy Blog

## Updating packages

Packages are installed in the separate directory in the Docker image, but the
package.json file is maintained in the project root. New packages can be added
with the command:

```
make shell
npm add ...
```

## Stylesheets

The stylesheets are kept in the `scss` directory. When they are changed the
`sass:watch` command in the `package.json` will compile it to the `css`
directory. This is the file used in the `link` tag in the template. The
`addWatchTarget` in the elventy config will rebuild the site when this file
changes.
