#
# BUILD
#
FROM gradle:8.0.2-jdk17-alpine AS build
USER root
WORKDIR /hexagon

ADD . .
RUN gradle --quiet compileRocker
RUN gradle --quiet -x test

#
# RUNTIME
#
FROM eclipse-temurin:17-jre-alpine
ENV POSTGRESQL_DB_HOST tfb-database
ENV PROJECT hexagon_nettyepoll_postgresql
ENV JDK_JAVA_OPTIONS -XX:+AlwaysPreTouch -XX:+UseParallelGC -XX:+UseNUMA

COPY --from=build /hexagon/$PROJECT/build/install/$PROJECT /opt/$PROJECT

EXPOSE 9090

ENTRYPOINT /opt/$PROJECT/bin/$PROJECT
