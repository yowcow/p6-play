.PHONY: build-moar build-panda test

all: build-moar build-panda

build-moar:
	rakudobrew build moar

build-panda:
	rakudobrew build-panda

test:
	prove -e perl6 -r t
