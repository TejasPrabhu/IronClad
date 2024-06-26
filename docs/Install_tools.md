# Nexus

```docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest```

# SonarQube

```docker run -d --name sonar -p 9000:9000 sonarqube:lts-community```

# Trivy

``` ```

# SSH tunneling

```ssh -L [LOCAL_IP:]LOCAL_PORT:DESTINATION:DESTINATION_PORT [USER@]SSH_SERVER```