# Estágio 1: Build da aplicação com Maven e JDK completo
FROM eclipse-temurin:17-jdk-jammy as build

WORKDIR /app

# Copia o wrapper do Maven para aproveitar o cache de layers do Docker
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Baixa as dependências. Se o pom.xml não mudar, esta camada será reutilizada.
RUN ./mvnw dependency:go-offline

# Copia o código-fonte e compila a aplicação
COPY src ./src
RUN ./mvnw package -DskipTests

# Estágio 2: Criação da imagem final com JRE (menor que o JDK)
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copia apenas o JAR gerado do estágio de build
COPY --from=build /app/target/*.jar app.jar

# Expõe a porta que a aplicação Spring vai usar
EXPOSE 8080

# Comando para executar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]