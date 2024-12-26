# Use a base image with Java 17 runtime
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the application JAR file into the container
COPY app.jar .

# Expose the required port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
