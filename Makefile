.PHONY: all clean install dev copy-assets package-source

# The current git tag is used as the version number
GITTAG=$(shell git describe --always --tag)
BIN=$(shell npm bin)

build: install copy-assets
	mkdir -p build
	NODE_ENV=production ./node_modules/.bin/rollup -c
	mkdir -p dist
	(cd build && zip -r ../dist/NewsFeedEradicator_$(GITTAG).zip .)

build-safari: install copy-assets-safari
	mkdir -p build-safari
	NODE_ENV=production ./node_modules/.bin/rollup -c --environment BUILD:safari
	mkdir -p dist
	(cd build-safari && zip -r ../dist/NewsFeedEradicator_Safari_$(GITTAG).zip .)

create-ios-app: build-safari
	mkdir -p apple-app
	cd apple-app && xcrun safari-web-extension-converter ../build-safari --project-location . --app-name "News Feed Eradicator" --bundle-identifier com.htalat.News-Feed-Eradicator --swift --force

build-ios: create-ios-app
	cd apple-app && chmod +x build-ios.sh && ./build-ios.sh

# Typecheck only
check:
	npm run check

# Firefox Add-on store requires source to be submitted as a zip, so this command builds that zip
package-source:
	mkdir -p dist
	git archive --output=dist/NewsFeedEradicator_source_$(GITTAG).zip HEAD

copy-assets:
	mkdir -p build
	mkdir -p build/icons
	cp src/icons/* build/icons/
	cp src/manifest-chrome.json build/manifest.json
	cp src/options/options.html build/options.html
	cp assets/icon16.png build/icon16.png
	cp assets/icon32.png build/icon32.png
	cp assets/icon48.png build/icon48.png
	cp assets/icon64.png build/icon64.png
	cp assets/icon128.png build/icon128.png

copy-assets-safari:
	mkdir -p build-safari
	mkdir -p build-safari/icons
	cp src/icons/* build-safari/icons/
	cp src/manifest-safari.json build-safari/manifest.json
	cp src/options/options.html build-safari/options.html
	cp src/background/background.html build-safari/background.html
	cp assets/icon16.png build-safari/icon16.png
	cp assets/icon32.png build-safari/icon32.png
	cp assets/icon48.png build-safari/icon48.png
	cp assets/icon64.png build-safari/icon64.png
	cp assets/icon128.png build-safari/icon128.png

dev: install copy-assets
	mkdir -p build
	./node_modules/.bin/rollup -c --watch

install:
	npm install

clean:
	rm -rf dist
	rm -rf build
	rm -rf node_modules
