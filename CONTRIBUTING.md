# Contributing

-   [requirements](#requirements)
-   [setup](#setup)
-   [development](#development)
    -   [storybook](#storybook)
    -   [demo/doc website](#demodoc-website)
    -   [testing](#testing)
    -   [formatting](#formatting)
    -   [linting](#linting)
    -   [screenshots](#screenshots)
-   [website](#website)
-   [deploy](#deploy)

## Requirements

-   **Node.js >= 18**
-   **pnpm**
-   **Make** (you also have the option to run the commands manually though)

## Setup

Rata is structured into multiple packages thanks to workspaces.
In order to install all the required dependencies and to establish links between
the various packages, please execute the following:

```
make init
```

> please note that it will take a while as this project uses a lot of dependencies…

## Development

### Storybook

The easiest way to work on Rata, is to use our [storybook](https://storybook.js.org/).
The storybook development mode can be started via:

```
make storybook
```

Stories are located in a different folder: `storybook/stories/` so you should also
run the package in dev mode:

```
make pkg-dev-button
```

Where `button` is the name of the package.

### New Package

Quickly scaffold a new component by running:

```
# Substitute your component name for mycomponent
make pkg-new-mycomponent
```

### Testing

To run unit tests on all packages, run the following command:

```
make pkgs-test
```

If you only made modifications on a specific package,
you can use the scoped form to speed up the process:

```
make pkg-test-button
```

where `button` is the name of the targeted rata package.

### Formatting

Rata uses prettier in order to provide a consistent code style.
If you made some modification to the existing code base, please run the formatting
command before submitting your modifications:

```
make fmt
```

### Linting

Rata code base also uses eslint to enforce consistent code style.
eslint is only enabled on packages for now, if you want to run eslint
against all packages, please run:

```
make pkgs-lint
```

If you only made modifications on a specific package,
you can use the scoped form to speed up the process:

```
make pkg-lint-button
```

where `button` is the name of the targeted rata package.

## Deploy

Storybook is hosted on GitHub pages.
In order to deploy Sorybook, you need to have access to the rata github repository.
There's a convenient command to deploy Storybook:

```
make deploy-all
```
