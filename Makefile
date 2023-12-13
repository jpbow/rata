MAKEFLAGS += --no-print-directory

SOURCES = packages

.PHONY: help bootstrap init pkgs-build pkgs-publish clean-all storybook storybook-build storybook-deploy deploy-all

########################################################################################################################
#
# HELP
#
########################################################################################################################

# COLORS
RED    = $(shell printf "\33[31m")
GREEN  = $(shell printf "\33[32m")
WHITE  = $(shell printf "\33[37m")
YELLOW = $(shell printf "\33[33m")
RESET  = $(shell printf "\33[0m")

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_HELPER = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-\%]+)\s*:.*\#\#(?:@([0-9]+\s[a-zA-Z\-\%_]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

help: ##prints help
	@perl -e '$(HELP_HELPER)' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

########################################################################################################################
#
# 0. GLOBAL
#
########################################################################################################################

install: ##@0 global install
	@pnpm install

init: ##@0 global cleanup/install/bootstrap
	@$(MAKE) clean-all
	@$(MAKE) install
	@$(MAKE) pkgs-build

fmt: ##@0 global format code using prettier (js, css, md)
	@pnpm prettier --color --write \
		"packages/*/{src,tests}/**/*.{js,ts,tsx}" \
		"packages/*/index.d.ts" \
		"packages/*/README.md" \
		"storybook/.storybook/*.{js,ts,tsx}" \
		"storybook/stories/**/*.{js,ts,tsx}" \
		"README.md"

fmt-check: ##@0 global check if files were all formatted using prettier
	@echo "${YELLOW}Checking formatting${RESET}"
	@pnpm prettier --color --list-different \
        "packages/*/{src,tests}/**/*.{js,ts,tsx}" \
        "packages/*/index.d.ts" \
        "packages/*/README.md" \
		"storybook/.storybook/*.{js,ts,tsx}" \
		"storybook/stories/**/*.{js,ts,tsx}" \
        "README.md"

test: ##@0 global run all checks/tests (packages, website)
	@$(MAKE) fmt-check
	@$(MAKE) lint
	@$(MAKE) pkgs-test

vercel-build: ##@0 global Build Storybook to vercel
	@$(MAKE) storybook-build
	@cp -a storybook/storybook-static 

clean-all: ##@0 global uninstall node modules, remove transpiled code & lock files
	@rm -rf node_modules
	@rm -rf package-lock.json
	@$(foreach source, $(SOURCES), $(call clean-source-all, $(source)))

define clean-source-lib
	rm -rf $(1)/*/cjs
endef

define clean-source-all
	rm -rf $(1)/*/cjs
	rm -rf $(1)/*/node_modules
	rm -rf $(1)/*/package-lock.json
endef

########################################################################################################################
#
# 1. PACKAGES
#
########################################################################################################################

pkg-new-%: ##@1 packages create new package
	@echo "${YELLOW}Running Plop ${WHITE}@rata/${*}${RESET}"
	@pnpm plop package "${*}"
	@pnpm install

pkg-lint-%: ##@1 packages run eslint on package
	@echo "${YELLOW}Running eslint on package ${WHITE}@rata/${*}${RESET}"
	@pnpm eslint ./packages/${*}/{src,tests}/**/*.{js,ts,tsx}

pkgs-lint: ##@1 packages run eslint on all packages
	@echo "${YELLOW}Running eslint on all packages${RESET}"
	@pnpm eslint "./packages/*/{src,tests}/**/*.{js,ts,tsx}"

pkgs-lint-fix: ##@1 packages run eslint on all packages with a fix option
	@echo "${YELLOW}Running eslint on all packages${RESET}"
	@pnpm eslint "./packages/*/{src,tests}/**/*.{js,ts,tsx}" --fix

pkg-test-cover-%: ##@1 packages run tests for a package with code coverage
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . --coverage ./packages/${*}/tests

pkg-test-%: ##@1 packages run tests for a package
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . ./packages/${*}/tests

pkg-watch-test-%: ##@1 packages run tests for a package and watch for changes
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . ./packages/${*}/tests --watch

pkg-update-test-%: ##@1 packages run tests for a package and update its snapshots
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . ./packages/${*}/tests -u

pkg-watch-test-%: ##@1 packages run tests for a package and watch for changes
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . ./packages/${*}/tests --watch

pkgs-test: ##@1 packages run tests for all packages
	@echo "${YELLOW}Running test suites for all packages${RESET}"
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --workerThreads --rootDir . ./packages/*/tests

pkgs-watch-test: ##@1 packages run tests for all packages and watch for changes
	@echo "${YELLOW}Running test suites watcher for all packages${RESET}"
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . ./packages/*/tests --watch

pkgs-test-cover: ##@1 packages run tests for all packages with code coverage
	@echo "${YELLOW}Running test suites coverage for all packages${RESET}"
	@export BABEL_ENV=development; pnpm jest -c ./packages/jest.config.js --rootDir . --coverage ./packages/*/tests

pkgs-build: pkgs-types ##@1 packages build all packages
	@# Using exit code 255 in case of error as it'll make xargs stop immediately.
	@export SKIP_TYPES=TRUE;find ./packages -type d -maxdepth 1 ! -path ./packages \
        | sed 's|^./packages/||' \
        | xargs -P 8 -I '{}' sh -c '$(MAKE) pkg-build-{} || exit 255'

pkgs-types: ##@1 packages build all package types
	@pnpm tsc --build ./tsconfig.monorepo.json

pkgs-types-clean: ##@1 packages clean all package types
	@pnpm tsc --build --clean ./tsconfig.monorepo.json

pkg-types-%: ##@1 packages generate types for a specific package
	@if [ "$${SKIP_TYPES}" != "TRUE" ]; \
    then \
        if [ -f "./packages/${*}/tsconfig.json" ]; \
		then \
			echo "${YELLOW}Building TypeScript types for package ${WHITE}@rata/${*}${RESET}"; \
			rm -rf ./packages/${*}/dist/types; \
			rm -rf ./packages/${*}/dist/tsconfig.tsbuildinfo; \
			pnpm tsc --build ./packages/${*}; \
        fi \
	fi;

pkg-build-%: pkg-types-% ##@1 packages build a package
	@-rm -rf ./packages/${*}/dist/rata-${*}*
	@export PACKAGE=${*}; NODE_ENV=production BABEL_ENV=production ./node_modules/.bin/rollup -c rollup.config.mjs

pkgs-publish-dry-run: ##@1 packages dry run for packages publication
	#@$(MAKE) pkgs-build
	@pnpm lerna publish \
        --exact \
        --no-git-tag-version \
        --no-push \
        --force-publish \
        --registry "http://localhost:4873" \
        --loglevel verbose

pkgs-publish: ##@1 packages publish all packages
	@$(MAKE) pkgs-build

	@echo "${YELLOW}Publishing packages${RESET}"
	@pnpm lerna publish --exact

pkgs-publish-next: ##@1 packages publish all packages for @next npm tag
	@$(MAKE) pkgs-build

	@echo "${YELLOW}Publishing packages${RESET}"
	@pnpm lerna publish --exact --npm-tag=next

pkg-dev-%: ##@1 packages build package (es flavor) on change, eg. `package-watch-button`
	@echo "${YELLOW}Running build watcher for package ${WHITE}@rata/${*}${RESET}"
	@rm -rf ./packages/${*}/cjs
	@export PACKAGE=${*}; NODE_ENV=development BABEL_ENV=development ./node_modules/.bin/rollup -c rollup.config.mjs -w

########################################################################################################################
#
# 2. STORYBOOK
#
########################################################################################################################

storybook: ##@2 storybook start storybook in dev mode on port 6006
	@pnpm --filter storybook dev

storybook-build: ##@2 storybook build storybook
	@echo "${YELLOW}Building storybook${RESET}"
	@pnpm --filter storybook build

storybook-deploy: ##@2 storybook build and deploy storybook
	@$(MAKE) storybook-build

	@echo "${YELLOW}Deploying storybook${RESET}"
	@pnpm gh-pages -d storybook/storybook-static -r git@github.com:jpbow/rata.git -b gh-pages -e storybook
