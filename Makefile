PREFIX?=/usr/local

TEMPORARY_FOLDER=./tmp_portable_localizable
OS := $(shell uname)

build:
	swift build --disable-sandbox -c release -Xswiftc -static-stdlib

test:
	swift test

lint:
	swiftlint

clean:
	swift package clean

xcode:
	swift package generate-xcodeproj

install: build
	mkdir -p "$(PREFIX)/bin"
	cp -f ".build/release/Localizable" "$(PREFIX)/bin/localizable"

portable_zip: build
	mkdir -p "$(TEMPORARY_FOLDER)"
	cp -f ".build/release/Localizable" "$(TEMPORARY_FOLDER)/localizable"
	cp -f "LICENSE" "$(TEMPORARY_FOLDER)"
	(cd $(TEMPORARY_FOLDER); zip -r - LICENSE test-summaries) > "./portable_localizable.zip"
	rm -r "$(TEMPORARY_FOLDER)"

