# deploy docker-compose to an on-prem server using scp and ssh

## Important

- this is designed for servers that have only one docker-compose project running on it
- the DOCKER_COMPOSE_DEPLOY_FILE should not have a build step in it
- the project servers must already have docker and docker-compose installed on them and configured correctly

## Example calling workflow

```yaml
name: build-and-deploy workflow
on:
  workflow_dispatch:
  push:
    branches:
      - main

# https://docs.github.com/en/actions/using-jobs/using-concurrency#example-only-cancel-in-progress-jobs-or-runs-for-the-current-workflow
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  Build-and-push-project-images:
    name: do a build and push the project images to a docker repository
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v3
      - name: build and push docker images pseudo-code
        run: |
          echo "docker-compose build . <add settings and args here>"
          echo "docker tag <tag1 as it was built> <tag1 to use for the image repository>"
          echo "docker tag <tag2 as it was built> <tag2 to use for the image repository>"
          echo "docker tag <tag3... as it was built> <tag3... to use for the image repository>"
          echo "docker login stuff"
          echo "docker push <tag1>"
          echo "docker push <tag2>"
          echo "docker push <tag3...>"
          echo "docker logout"
          echo "clean up after the work using 'docker container prune -f' or something like that"


  #  GitHub Actions reusable workflows https://docs.github.com/en/actions/using-workflows/reusing-workflows#example-caller-workflow
  deploy-to-dev:
    name: dev servers build and deploy
    needs:
      - Build-and-push-project-images
      - clone-reusable-workflow-library
    uses: ./.github/workflows/build-and-deploy.yml
    with:
      RUNS_ON: self-hosted
      GITHUB_ENVIRONMENT: dev
      DEPLOY_HOSTS: dtnaacvdl238.us164.corpintra.net,dtnaacvdl239.us164.corpintra.net
      SERVICE_ACCOUNT_USERNAME: DTNA_CVD_s_HCVSS
      DOCKER_COMPOSE_DEPLOY_FILE: docker-compose.dev.deploy.yml
    secrets:
      SERVICE_ACCOUNT_PASSWORD: ${{ secrets.SERVICE_ACCOUNT_PASSWORD }}
      HTTP_PROXY: ${{ secrets.HTTP_PROXY }}
      HTTPS_PROXY: ${{ secrets.HTTPS_PROXY }}
      CA_BASE64: ${{ secrets.CA_BASE64 }}

```

## Future Plans

Might be nice to move from using bash to using something like ansible for the deployment script

- <https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_module.html>
- <https://github.com/marketplace/actions/run-ansible-playbook>
