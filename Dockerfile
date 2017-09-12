FROM openjdk:8-jdk as builder
COPY . /project
WORKDIR /project
RUN ./gradlew build -x test

FROM openjdk:8-jre-alpine
COPY --from=builder /project/build/libs/*.jar /ase.jar
RUN mkdir -p /var/log/openbaton
COPY --from=builder /project/etc/ase.properties /etc/openbaton/ase.properties
ENTRYPOINT ["java", "-jar", "/ase.jar", "--spring.config.location=file:/etc/openbaton/ase.properties"]
EXPOSE 9998
EXPOSE 9999
