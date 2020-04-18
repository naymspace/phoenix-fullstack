*Replace all examples and italic texts with project specific explanations**

# _Project Title_

_One Paragraph of project description goes here. Describe briefly the project and its goal to give a rough understanding about it. Please mention the main programming language (PHP, Elixir, Ruby). This should also include a rough overview of the context (i.e. dependent projects and production environment)_

## Quickstart – Docker
_If your project has docker-compose support, mention it in this paragraph._

### Configuration/Setup
_Describe necessary preparations to run the application with docker-compose. This includes file renaming or executing a migration in the application container before usage_

### Start
_List the command to start the application. It is enough to only say `docker-compose up` if this is enough. Do not take it for granted that everyone has previously used docker-compose! Most setups have already a running app after docker-compose up, but there can be some environment like Java were a manual start is necessary._

## Start – manual way

**You can skip this part if you are using Docker.**

_Describe the necessary steps to setup the app without Docker. This can be tedious but can improve the understandment about the application. The knowledge can help to fix problems with the docker setup._

### Prerequisites

_What things you need to install the software and how to install them. Add the version to the dependency instead of only the name (Python 3.6 instead of Python). Also mention possible running software like databases or cache server._

- _1 @ 3.6_
- _2 @ 0.0.1_
- _..._
- _n @ version_

### Installing

_A step by step series of examples that tell you how to get a development env running. Start with a completely unconfigured environment and do not assume anything else than described in **Prerequisites**!_

_Example:_

```
sh install_requirements.txt
```

### Configuration

_The same as Quickstart – Docker/Configuration. You can link the this paragraph if the steps are the same_

### Start

_The commands to start and stop the application. Describe every command line parameter and if it is required._

_Start:_

```
java -jar server.jar -p 8080
```

_Parameter:_

- -p[INT] The port of the server. Required.

## Access application

_List the steps to access the application, like the default URL:_

```
http://localhost:8082
```

## Environment variables

_List necessary environment variables and their meaning. If there is a `.env` file, give a hint._

- **API_KEY** [String] - The key for the API. Only have a placeholder in the repository.

## Building and Deployment

_Explain the steps (build docker for example) for deployment. If there is a CI process (like `.gitlab-ci.yml`), you can reference that. If there is none and the deployment is manually, you must describe it here._

## Automatic tests

_Explain how the tests can be started and if they need additional configuration based on the installation process_

## Major dependencies

_Mention and link the main dependencies of the project. These are frameworks, depedency manager, project management tools and bigger libraries. No need to list every little dependency._

- [JQuery](https://jquery.com/) - Javascript library
- [Maven](https://maven.apache.org/) - Dependency Management

_List guides and documentation useful for this project, like the used code convention._

## Useful hints

_List and describe useful information about the code in sub headings. For example, a central hack and why it is used. This list is intended to be short._
