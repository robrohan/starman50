
GAME=Starman
LOVE_BIN=love-11.3-win32
VERSION=$(shell git log --pretty=format:'%h' -n 1)

build: bundle download_win fuse

bundle:
	mkdir -p dist
	zip -9 -r $(GAME).love . -x \*.git\* -x \*design\* -x \*dist\*
	mv $(GAME).love ./dist

download_win:
	mkdir -p dist
	wget --output-document=./dist/$(LOVE_BIN).zip https://github.com/love2d/love/releases/download/11.3/$(LOVE_BIN).zip

fuse:
	cd dist; \
		unzip $(LOVE_BIN).zip; \
		mv $(GAME).love $(LOVE_BIN); \
		cd $(LOVE_BIN); \
		cat love.exe $(GAME).love > $(GAME).exe; \
		rm $(GAME).love; \
		rm love.exe;
	cd dist; \
		cd $(LOVE_BIN); \
			zip -9 ../$(GAME)-$(VERSION).zip ./*

clean:
	rm -rf dist

