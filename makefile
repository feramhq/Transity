.PHONY: help
help: makefile
	@tail -n +4 makefile | grep ".PHONY"


.PHONY: all
all: changelog.md readme.md index.js docs output


.PHONY: build
build: | node_modules
	npx spago build


changelog.md: .git | node_modules
	# git config changelog.format '- %s (%h)'
	# git changelog
	npx conventional-changelog \
		--infile $@ \
		--same-file \
		--output-unreleased


srcFiles := $(shell find src -type f -name "*.purs")
index.js: $(srcFiles) spago.yaml | node_modules
	npx spago bundle \
		--platform node \
		--minify

.PHONY: bundle
bundle: index.js


# The specified target is configured in package.json
docs: output | node_modules
	npx parcel build webapp/index.html \
		--public-url /Transity \
		--no-source-maps \
		--target $@


# Correct paths for assets during local development
# Use e.g. Vercel's "serve" like this: `serve docs-dev`.
# The specified target is configured in package.json.
docs-dev: output index.js | node_modules
	npx parcel build webapp/index.html \
		--no-source-maps \
		--target $@



output: src spago.yaml | node_modules
	npx spago build


node_modules: package.json package-lock.json
	if test ! -d $@; then npm install; fi


readme.md: | node_modules
	npx markdown-toc -i $@


##### TESTING ######

.PHONY: lint-js
lint-js: | node_modules
	npx eslint \
		--max-warnings 0 \
		--ignore-path .gitignore \
		scripts


.PHONY: test-spago
test-spago: | node_modules
	npx spago test


.PHONY: test-cli
test-cli: | node_modules
	npx spago run -- \
		balance examples/journal.yaml \
		> /dev/null

	npx spago run -- \
		balance examples/journal.yaml examples/journal-only-transactions.yaml \
		> /dev/null

	npx spago run -- \
		unused-files examples/receipts examples/journal.yaml \
		2> /dev/null

	npx spago run -- \
		unused-files \
			examples/receipts \
			examples/journal.yaml \
			examples/journal-only-transactions.yaml \
		2> /dev/null


.PHONY: test
test: test-spago test-cli lint-js


.PHONY: test-watch
test-watch: | node_modules
	watchexec \
		--exts purs \
		'npx spago test'


.PHONY: clean
clean:
	-rm -rf \
		.parcel-cache \
		.spago \
		docs \
		docs-dev \
		index.js \
		node_modules \
		output
