FROM azul/zulu-openjdk-alpine:17-jre-latest AS dep
RUN apk add --no-cache curl \
  && curl -L "https://github.com/karatelabs/karate/releases/download/v1.4.1/karate-1.4.1.jar" -o /opt/karate.jar

FROM azul/zulu-openjdk-alpine:17-jre-latest AS final
WORKDIR /tests
COPY src/test/resources /tests
COPY --from=dep /opt/karate.jar /opt/karate.jar
ENTRYPOINT ["java", "-jar", "/opt/karate.jar", "."]
