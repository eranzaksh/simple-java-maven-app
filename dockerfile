FROM maven:3.8.5-openjdk-17 as build
  
WORKDIR /app
  
COPY pom.xml .
RUN mvn dependency:go-offline
  
COPY ./src ./src
mvn -B clean package --file pom.xml

FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/target/*.jar /app/target/.
CMD ["ls"]
