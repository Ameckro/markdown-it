PATH        := ./node_modules/.bin:${PATH}

NPM_PACKAGE := $(shell node -e 'process.stdout.write(require("./package.json").name)')
NPM_VERSION := $(shell node -e 'process.stdout.write(require("./package.json").version)')

GITHUB_PROJ := https://github.com//markdown-it/${NPM_PACKAGE}


demo:
	npm run demo

gh-demo:
	npm run gh-demo

lint:
	npm run lint

test:
	npm test

coverage:
	npm run coverage

doc:
	npm run doc

gh-doc:
	npm run gh-doc

publish:
	@if test 0 -ne `git status --porcelain | wc -l` ; then \
		echo "Unclean working tree. Commit or stash changes first." >&2 ; \
		exit 128 ; \
		fi
	@if test 0 -ne `git fetch ; git status | grep '^# Your branch' | wc -l` ; then \
		echo "Local/Remote history differs. Please push/pull changes." >&2 ; \
		exit 128 ; \
		fi
	@if test 0 -ne `git tag -l ${NPM_VERSION} | wc -l` ; then \
		echo "Tag ${NPM_VERSION} exists. Update package.json" >&2 ; \
		exit 128 ; \
		fi
	git tag ${NPM_VERSION} && git push origin ${NPM_VERSION}
	npm publish ${GITHUB_PROJ}/tarball/${NPM_VERSION}

browserify:
	npm run browserify

benchmark-deps:
	npm run benchmark-deps

specsplit:
	npm run specsplit

todo:
	grep 'TODO' -n -r ./lib 2>/dev/null || test true


.PHONY: publish lint test todo demo coverage doc
.SILENT: help lint test todo
