testbuild: build-elasticsearch-ci
	docker run --cap-add=IPC_LOCK --ulimit memlock=-1:-1 --ulimit nofile=65536:65536 elasticsearch-ci:master /bin/bash -c "ulimit -l unlimited && \
	su - elasticsearch -s /bin/bash -c '\
	export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/gradle/bin\" && \
	export JAVA_HOME=\"/usr/lib/jvm/java-1.8-openjdk\" && \
	git clone https://github.com/elastic/elasticsearch.git && \
	cd elasticsearch && \
	echo \"ulimit is:\" && \
	ulimit -l && \
	gradle --stacktrace clean && \
	gradle --info build'"

testbuild-interactive: build-elasticsearch-ci
	RAND_ID=$$RANDOM
	docker run -d --name elasticsearch-ci-$$RAND_ID --cap-add=IPC_LOCK --ulimit memlock=-1:-1 --ulimit nofile=65536:65536 elasticsearch-ci:master tail -f /dev/null
	docker exec -ti elasticsearch-ci-$$RAND_ID /bin/bash -c "ulimit -l unlimited && \
	su - elasticsearch -s /bin/bash -c '\
	export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/gradle/bin\" && \
	export JAVA_HOME=\"/usr/lib/jvm/java-1.8-openjdk\" && \
	git clone https://github.com/elastic/elasticsearch.git && \
	cd elasticsearch && \
	echo \"ulimit is:\" && \
	ulimit -l && \
	gradle --stacktrace clean && \
	gradle --info build'"

build-elasticsearch-ci:
	docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t elasticsearch-ci:master .
