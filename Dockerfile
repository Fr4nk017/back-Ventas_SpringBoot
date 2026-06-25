# STAGE 1: Compilar el proyecto con Maven
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B

# STAGE 2: Imagen final liviana solo con el JAR
FROM eclipse-temurin:17-jre-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

USER appuser

# back-Ventas usa el puerto por defecto de Spring Boot (8080)
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
