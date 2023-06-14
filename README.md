# Kubefirst Workshop

Ever hear someone say that Kubernetes is not complicated. It makes Frédéric Harper’s, Principal Developer Advocate at Kubefirst, head spin every time! Getting started is no piece of cake, so this is where kubefirst, a free and open source tool, comes to the rescue. In this workshop, Fred will show you how to use our CLI to deploy a new Kubernetes cluster in minutes, with the most popular cloud native tools. We will deploy a new cluster locally using k3d & Docker (see prerequisites), and we will explore its pieces. Since your new cluster is already fully functional, we will discuss the GitOps principles with your new "source of truth repository”, use Terraform with Atlantis, add a new user using HashiCorp Vault, surf the Argo CD sync waves, and master the magic steps to deploy a new application in the cloud. You can't miss this, we'll have some K8s fun!

- [Prerequisites](#prerequisites)
- [Install the kubefirst CLI](#install-the-kubefirst-cli)
- [Create a new k3d cluster](#create-a-new-k3d-cluster)
- [Add a New Repository](#add-a-new-repository)
- [Add a New User](#add-a-new-user)
- [Add a New Application](#add-a-new-application)

## Prerequisites

Please be sure you are [running Docker Desktop](https://docs.docker.com/desktop/install/mac-install/).

## Install the kubefirst CLI

You need to [use Homebrew](https://docs.kubefirst.io/2.0/kubefirst/overview#install-the-kubefirst-cli). If you don't have it, and want to install it, read [their documentation](https://brew.sh). If you don't want to use it, here are some [alternative ways to install the CLI](https://github.com/kubefirst/kubefirst/blob/main/build/README.md).

```shell
brew install kubefirst/tools/kubefirst
```

If you already have it, be sure you are using the latest version, as we'll need 2.1.3 for this tutorial.

```shell
brew update
brew upgrade kubefirst
```

## Create a new k3d cluster

```shell
kubefirst k3d create --cluster-name kubefirst --github-user fharper --git-provider github
```

## Add a New Repository

We will do this in the browser on [GitHub](https://github.com).

### Using the CLI Instead of the Browser

Alternatively, you can do it on the CLI.

```shell
git clone git@github.com:fharper/gitops.git
vi terraform/github/repos.tf
# copy and paste a entire module, change the module name, and repo_name value for your new repository name. Save, and quit.
git checkout -b new_repo
git add terraform/github/repos.tf
git commit -m "Adding a new repository to GitHub"
git push -u origin
```

If you have the GitHub CLI installed, you can create the PR with the following command:

```shell
gh pr create --assignee @me --title "$(git log --format=%s -n 1)" --body "$(git log --format=%b -n 1)"
```

If not, open the branch in your browser, and create the pull request from the GitHub web UI.

Attention, do not merge directly into `main`, we will use Terraform & Atlantis to apply the changes. You could also use Terraform CLI to apply the changes, but we will explain why we prefer to use Atlantis.

## Add a New User

We will do this in the browser on [GitHub](https://github.com).

### Using the CLI Instead of the Browser

Alternatively, you can do it on the CLI.

```shell
vi terraform/users/developers.tf
# uncomment the developer_one module. Save, and quit.
git checkout -b new_user
git add terraform/users/developers.tf
git commit -m "Adding a new user to my cluster"
git push -u origin
```

If you have the GitHub CLI installed, you can create the PR with the following command:

```shell
gh pr create --assignee @me --title "$(git log --format=%s -n 1)" --body "$(git log --format=%b -n 1)"
```

If not, open the branch in your browser, and create the pull request from the GitHub web UI.

Attention, do not merge directly into `main`, we will use Terraform & Atlantis to apply the changes. You could also use Terraform CLI to apply the changes, but we will explain why we prefer to use Atlantis.

## Add a New Application

Download the [flappy-kray.yml](flappy-kray.yml) file. We will use this to add a new application using GitOps principles. We will do this in the browser on [GitHub](https://github.com).

### Using the CLI Instead of the Browser

Alternatively, you can do it on the CLI.

```shell
vi registry/kubefirst/flappy-kray.yml
# Copy the content from the file you downloaded. Save, and quit.
# Alternatively, you can just move the file you downloaded in the registry/kubefirst/ folder.
git checkout -b new_app
git add registry/kubefirst/flappy-kray.yml
git commit -m "Adding a new app called Flappy Kray"
git push -u origin
```

If you have the GitHub CLI installed, you can create the PR with the following command:

```shell
gh pr create --assignee @me --title "$(git log --format=%s -n 1)" --body "$(git log --format=%b -n 1)"
```

If not, open the branch in your browser, and create the pull request from the GitHub web UI.

### How to access your new application

Once we applied the changes, and the application is synced in Argo CD, run the following command to create the certificates, and prevent some browser security issues.

```shell
kubefirst k3d mkcert --application flappy-kray --namespace kubefirst
```

You can now access it at <https://flappy-kray.kubefirst.dev>.
