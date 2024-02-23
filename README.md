# Todo Bites

This PWA app serves as a prototype for the TodoBites project, a "To-Do" app designed to help people with ADHD be more productive.

## Technologies

- [Vite JS](https://vitejs.dev/)
- [React JS](https://reactjs.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Jest](https://jestjs.io/)
- [Terraform](https://www.terraform.io/)

## Installation

To set up and run the project locally, follow these steps:

1. Clone this repository.

   ```bash
   
   git clone git@github.com:ryanencoded/todobites.git
   cd todobites

    ```

2. Install dependencies.

    `yarn install`

3. Start the local development server.

    `yarn dev`

### Usage

The use this repo, you will need to run node v20+.

## View

To interact with the application, follow these steps:

1. Open your web browser and navigate to [http://localhost:5173/](http://localhost:5173/).
2. Explore the features of the "To-Do" app, including creating, viewing, and completing tasks.

## Scripts

The main scripts to consider are:

- `yarn dev`: Start the local development server.
- `yarn test`: Run the testing suite.
- `yarn deploy:init`: Setup terraform on your machine.
- `yarn deploy:plan` : Plan a terraform deployment for production.
- `yarn deploy:production` : Apply a terraform deployment in production.

## Outcome Goal

The primary objective of this codebase is to showcase proficiency in the following technologies: Vite, React, Jest, Tailwind CSS, Terraform, and AWS Serverless. The end goal is to have a demo todo app with 100% test coverage and fully automated deployment.

## Folder Structure

The project follows a specific folder structure for better organization:

```bash
todobites/
|-- src/
|-- public/
|-- terraform/
```

## Configuration

The project utilizes configuration files and environment variables for various settings. Please refer to the documentation for details on configuration.

### AWS Credentials

You will need to create a set of AWS CLI access credentials and then generate a profile using the AWS CLI tool. The profile name should match the .env variable for `TF_VAR_aws_profile` to work correctly.

### AWS Route 53

You will need to provide a Route 53 hosted zone in an AWS account to fully automate the deployment. This is by design to ensure our scripts only alter your hosted zone for certificate and cloudfront DNS records.

### Enviornment Variables

In order for the deploy scripts to run properly with Terraform, you will need to create the following ENV variables in a .env file.

```bash
TF_VAR_project_name="The project name used to split AWS resources"
TF_VAR_domain_name="The domain name to deploy the app to"
TF_VAR_environment="The environement to deploy for, usually production"
TF_VAR_client_name="The client name tag for billing resources"
TF_VAR_aws_zone_id="The Zone ID of the Route 53 hosted zone to add records to"
TF_VAR_aws_profile="The AWS Profile to use for deployment"
TF_VAR_aws_region="The AWS region to deploy resources within"

```

## Contribution Guidelines

We welcome contributions to improve the starter template, reach out to me on [LinkedIn](https://www.linkedin.com/in/ryanencoded/).

## License

This project is not licensed for sale, distribution or any other usage at this time.

## Demo

Coming Soon!
