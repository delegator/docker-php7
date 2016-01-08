.PHONY: all force test stamp

all:
	docker build -t delegator/php7 .

force: stamp
	docker build --no-cache=true -t delegator/php7 .

test:
	docker run --rm -p 3000:80 delegator/php7

stamp:
	date -Ru >build-stamp
