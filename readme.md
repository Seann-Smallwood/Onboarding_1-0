# Onboard1_0

> node.js api with feathers for tests and git actions

## About

This project uses [Feathers](http://feathersjs.com). An open source framework for building APIs and real-time applications.

## Getting Started

1. Make sure you have [NodeJS](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed.
2. Install your dependencies

    ```
    cd path/to/Onboard1_0
    npm install
    ```

3. Start your app

    ```
    npm run compile # Compile TypeScript source
    npm run migrate # Run migrations to set up the database
    npm start
    ```

## Testing

Run `npm test` and all your tests in the `test/` directory will be run.

## Scaffolding

This app comes with a powerful command line interface for Feathers. Here are a few things it can do:

```
$ npx feathers help                           # Show all commands
$ npx feathers generate service               # Generate a new Service
```

## Docker

This application can be containerized and deployed to cloud platforms.

### Local Docker Development

1. Build the Docker image:
   ```bash
   docker build -t my-api .
   ```

2. Run the container locally:
   ```bash
   docker run -p 8080:8080 my-api
   ```

3. Test the health endpoint:
   ```bash
   curl http://localhost:8080/health
   ```

## Cloud Deployment

This application is configured for deployment to Google Cloud Run using Terraform and GitHub Actions.

### Prerequisites

1. **Google Cloud Project**: Create a GCP project with billing enabled
2. **Enable APIs**: Enable the following APIs in your GCP project:
   - Cloud Run API
   - Artifact Registry API
   - Cloud Build API
   - IAM API

3. **Service Account**: Create a service account with the following roles:
   - Cloud Run Admin
   - Artifact Registry Administrator
   - Service Account User
   - Storage Admin (for Terraform state)

### Manual Deployment with Terraform

1. **Setup Terraform**:
   ```bash
   cd terraform
   terraform init
   ```

2. **Configure variables**:
   - Copy `terraform-local.tf` to `override.tf`
   - Update the credentials path and variables as needed
   - Or create a `terraform.tfvars` file with your project details

3. **Deploy infrastructure**:
   ```bash
   terraform plan
   terraform apply
   ```

### Automated Deployment with GitHub Actions

The repository includes a GitHub Actions workflow (`.github/workflows/deploy.yml`) that automatically:
1. Tests the application
2. Builds and pushes Docker images to Artifact Registry
3. Deploys to Cloud Run using Terraform

#### Required GitHub Secrets

Set up the following secrets in your GitHub repository (Settings → Secrets and variables → Actions):

| Secret Name | Description | How to get it |
|-------------|-------------|---------------|
| `GCP_PROJECT_ID` | Your Google Cloud Project ID | Found in GCP Console dashboard |
| `GCP_SERVICE_ACCOUNT_KEY` | Base64 encoded service account key JSON | Download key from IAM → Service Accounts, then base64 encode it |

#### Getting the Service Account Key

1. Go to GCP Console → IAM & Admin → Service Accounts
2. Select your service account
3. Go to "Keys" tab → "Add Key" → "Create new key" → JSON
4. Download the JSON file
5. Base64 encode it: `base64 -i path/to/key.json` (macOS/Linux) or use online tool
6. Copy the base64 output to the `GCP_SERVICE_ACCOUNT_KEY` secret

#### Deployment Triggers

The workflow triggers on:
- Push to `main` branch
- Manual trigger via GitHub Actions UI

### Environment Variables

The application supports the following environment variables (configured automatically in Cloud Run):

- `PORT`: Server port (default: 8080)
- `NODE_ENV`: Environment (production, development, test)
- `DATABASE_URL`: PostgreSQL connection string
- `HOSTNAME`: Host binding address

### Monitoring

Once deployed, you can:
- View logs in GCP Console → Cloud Run → [service-name] → Logs
- Monitor performance in the Metrics tab
- Set up alerting policies for errors or performance issues

### Health Check

The application includes a health check endpoint at `/health` that returns:
```json
{
  "status": "ok",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Help

For more information on all the things you can do with Feathers visit [docs.feathersjs.com](http://docs.feathersjs.com).
