# Spring Boot EC2 Docker CI/CD

This repository demonstrates deploying a Spring Boot application to an AWS EC2 instance using Docker and GitHub Actions for a CI/CD pipeline.

---

## Prerequisites

1. **AWS EC2 Instance**:
   - Ensure you have an EC2 instance set up with Docker installed.
   - Configure security group rules to allow necessary ports (e.g., 8080 for the application).

2. **GitHub Secrets**:
   Add the following secrets to your GitHub repository:
   - `AWS_EC2_HOST`: Public IP or domain of the EC2 instance.
   - `AWS_EC2_USER`: Username for SSH access (e.g., `ec2-user` or `ubuntu`).
   - `AWS_EC2_KEY`: Private SSH key for accessing the EC2 instance.

3. **Docker Installed Locally**: For testing Docker images before deployment.

---

## Repository Structure

```plaintext
.
├── Dockerfile            # Defines the Docker image for the Spring Boot app
├── src/                  # Source code of the Spring Boot application
├── .github/workflows/
│   └── deploy.yml        # GitHub Actions workflow for CI/CD
├── README.md             # Project documentation
```

---

## Dockerfile

A simple `Dockerfile` for building the Spring Boot app:

```dockerfile
# Use an OpenJDK base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the application JAR file
COPY target/springboot-app.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## GitHub Actions Workflow

A basic `deploy.yml` file for deploying the app:

```yaml
name: Deploy Spring Boot App

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Code
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Build Docker Image
      run: |
        docker build -t springboot-app .

    - name: Push Docker Image to EC2
      env:
        HOST: ${{ secrets.AWS_EC2_HOST }}
        USER: ${{ secrets.AWS_EC2_USER }}
        KEY: ${{ secrets.AWS_EC2_KEY }}
      run: |
        scp -o StrictHostKeyChecking=no -i "$KEY" springboot-app.tar.gz $USER@$HOST:/home/$USER/

    - name: Deploy on EC2
      env:
        HOST: ${{ secrets.AWS_EC2_HOST }}
        USER: ${{ secrets.AWS_EC2_USER }}
        KEY: ${{ secrets.AWS_EC2_KEY }}
      run: |
        ssh -o StrictHostKeyChecking=no -i "$KEY" $USER@$HOST "docker load < springboot-app.tar.gz && docker run -d -p 8080:8080 springboot-app"
```

---

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/springboot-ec2-docker-ci-cd.git
   cd springboot-ec2-docker-ci-cd
   ```

2. Build the application locally:
   ```bash
   mvn package
   ```

3. Build and run the Docker image locally:
   ```bash
   docker build -t springboot-app .
   docker run -p 8080:8080 springboot-app
   ```

4. Push changes to the `main` branch to trigger the GitHub Actions workflow and deploy to EC2.

---

## Notes

- Ensure the EC2 instance has sufficient resources to run the application.
- Monitor the application's logs using Docker:
  ```bash
  docker logs <container-id>
  ```
- Update security group rules to allow traffic to port `8080` if necessary.

---

## License

This project is licensed under the MIT License.

---

Pull requests are welcomed. For major changes, please open an issue first to discuss what you would like to change. Thanks!

Happy Coding!!!

## Copyright
© KAVINDU™

