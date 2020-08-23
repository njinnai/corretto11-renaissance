FROM alpine:3.12

# bash
RUN apk add --no-cache bash

# wget
RUN apk add --no-cache --virtual=build-dependencies wget ca-certificates

RUN ( \
 wget -O /etc/apk/keys/amazoncorretto.rsa.pub  https://apk.corretto.aws/amazoncorretto.rsa.pub \
 && echo "https://apk.corretto.aws/" >> /etc/apk/repositories \
 && apk update \
 && apk add amazon-corretto-11 \
 )

RUN ( \
 mkdir /app \
 && cd /app \
 && wget https://github.com/renaissance-benchmarks/renaissance/releases/download/v0.11.0/renaissance-gpl-0.11.0.jar \
 )

RUN ( \
 mkdir /bench \
 && cd /bench \
 && echo "#! /bin/sh" > bench.sh \
 && echo "java -jar /app/renaissance-gpl-0.11.0.jar --csv=bench.csv actors apache-spark jdk-concurrent jdk-streams neo4j rx scala-dotty scala-sat scala-stdlib scala-stm" >> bench.sh \
 && chmod +x bench.sh \
 )
