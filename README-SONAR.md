# Sonar — TP Analyse de code

## Option A — SonarCloud (recommandé pour le rendu EPSI)

1. Créez un projet sur [SonarCloud](https://sonarcloud.io) (organisation `guilafont1`).
2. Générez un token : **My Account → Security → Generate Token**.
3. Définissez la variable d'environnement :
   ```powershell
   $env:SONAR_TOKEN = "votre_token_sonarcloud"
   ```
4. Lancez le scan :
   ```powershell
   docker run --rm `
     -e SONAR_HOST_URL="https://sonarcloud.io" `
     -e SONAR_TOKEN=$env:SONAR_TOKEN `
     -v "${PWD}:/usr/src" -w /usr/src `
     sonarsource/sonar-scanner-cli:latest
   ```
5. Consultez les issues sur le tableau de bord SonarCloud.

Le fichier `sonar-project.properties` à la racine contient `sonar.projectKey` et `sonar.organization`.

## Option B — SonarQube local (Docker)

```powershell
.\scripts\run-sonar-local.ps1
```

Suivez les instructions pour créer le token admin, puis relancez avec `$env:SONAR_TOKEN`.

## Option C — Gradle (nécessite JDK + Android SDK)

```powershell
$env:SONAR_TOKEN = "votre_token"
.\gradlew sonar -Dsonar.token=$env:SONAR_TOKEN
```

## CI GitHub Actions

Le workflow `.github/workflows/sonar.yml` envoie l'analyse vers SonarCloud si le secret `SONAR_TOKEN` est configuré dans le dépôt.
