# Use a base image with Java runtime
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the application JAR file into the container
COPY app.jar .

# Expose the required port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
