# Bánh mì: A S3 Gateway for storage large objects (Proof of Concept) - Zalora TechTest

## Disclamer
This solution is a POC and shouldn't be used in real environments, PR and
comments are welcome and really appreciate, However you can use this approach
as real production-ready environments base for.

## The Challenge, The Roots
The details of the challenge are in this repository [here](https://github.com/albertmonfa/Banhmi/blob/master/assigment/DevOps%20-%20Coding%20test.pdf).

## Requeriments
* [**VirtualBox** >= 5.2.10](https://www.virtualbox.org/)
* [**Vagrant** >= 2.1.1](https://www.vagrantup.com/)

## Installation for Ubuntu Users based on LTS flavours
For installing Virtualbox you need type in the Linux console the following commands as user with root privileges
```
apt-get update
apt-get install virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso
```

For installing Vagrant you need type in your Linux console the following commands as user with root privileges
```
wget https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.deb
dpkg -i vagrant_2.1.1_x86_64.deb
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
```

## Installation for OSX Users
1. Download the Oracle/Hashicorp required packages:

    - Virtualbox 5.0.40 from http://download.virtualbox.org/virtualbox/5.2.10/VirtualBox-5.2.10-122088-OSX.dmg
    - VirtualBox Extension Package from: http://download.virtualbox.org/virtualbox/5.2.10/Oracle_VM_VirtualBox_Extension_Pack-5.2.10.vbox-extpack
    - Vagrant from Hashicorp: https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.dmg

2. Setup:

    - Install first the virtualbox DMG file following the steps that will appears in the GUI wizard.
    - When the VirtualBox setup ends, the extensions file will be associated directly with the new Virtualbox application and then a double-click over it will be enough to lets start the extension pack installation.
    - Install Vagrant DMG using their wizard.
    - When the Vagrant setup ends, open a Terminal and type the following commands:

          vagrant plugin install vagrant-share
          vagrant plugin install vagrant-vbguest

## Repository overview
I slipt this PoC across two "approaches" to resolve the challenge, using for each
one a different architecture and tools. The first one is the "Development" approach,
it concist in a docker stack ready for be executed in your computer just using
docker-compose. The second one is an approach about one real production-ready
enviroment running in ECS with autoscaling, autohealing and zero-downtime deploys.

Both solutions use Vagrant as base to achieve the maximum compatibility
possible and easy setup. The provisioning for the Dev enviroment is completly
powered by Ansible. Otherwise if you prefer you can run directly by `docker-compose`
using the `docker-compse.yml` file that you can see under the directory called
`env_dev`.

In the production-ready enviroment I use together Vagrant, Ansible and Terraform,
for that case Ansible not just provisioning the Vagrant machine, even created
on-the-fly all the terraform code based in templates.

As I said before this approach isn't applicable in real enviroments, you can apply
the infrastructure design, but not the implentation of the Infrastructure-as-code,
because for this challenge I prefered deliver a fully-automated solution ready
for be tested by everyone.

## Bánh mì Application
The Bánh mì application is a software wrote in python 3.7 asynchronus using some
libs like: asyncio, aiohttp and aiobotocore. Actually this software can act
as a S3 Storage Gateway, some of the features and goals that I tried to achieve
are enumerate above:

  * Modern development using asynchronous patterns are applied.
  * Real Microservice, 100% Docker-friendly. (Signal Handlers, Single Responsability,
  Single Bussiness Unit...)
  * High performance, ultra-fast bootstrap, fully-configurable for tunning by yaml files,
  100% REST and Healthchecking out-the-box.
  * Testing using the suite pytest-aiohttp under the `test` directory.
  * Multi-part Upload(Allow uploads for files bigger than 5GB), Download by chunks.
  * Hashing feature based on the file name, the file name is hashed to improve
  the S3 performance
  * Middleware-friendly. You can add easly middlewares for Authentication,
  RateLimit, Quota or whatever.
  * Multi-bucket support.
  * Small client SDK approach under the `src/client` folder
  * Architecture ready for create whitelabels REST services, you can reuse this
  base for create other microservices like a login system or something like this.
  * [**LocalStack**](https://github.com/localstack/localstack) as S3 Mockup for
  fast development and testing

## Overview about the real Production-Ready enviroment.
In this approach I used AWS as base creating a completely infrastructure from scratch
with the following components:
* VPC and public, private subnets and specialized subnets for DB and caching layers.
* Autoscaling Groups with scale up/down policies with zero-downtime using Lambda and SNS.
* Fully-grained IAM-Roles for Instance, Cluster, Service and Task.
* ECS Cluster and ECR Repository.
* ECS Service with scaling up/down policies and AWS ALB

The main-goals that I liked achieve to using that approach has been:
* **Automation**: I used Ansible for everything in the Vagrant side moreover
Terraform for AWS.
* **Best-practice in Docker**: Small image size, single responsability, fast bootstrap...
Docker is first of all a package system to delivery our applications, likewise docker
is very flexible and sometimes is not used in the correct way, I put all my bests
to ensure some best practice designing Dockers like:
  - Reuse Docker Images for specific purposes.
  - One process per Docker it's must.
  - Reduction the amount of non-useful filesystem layers.
  - Using the ENTRYPOINT as "parameter-watchdog" and sanitizer, likewise the CMD is
  used as executor of our "single process".
  - Unix signals handled by default by the app to prevent the zombies processes.
* **AutoHealing**: ECS bring us some strategies to keep our dockers up and running
permanetly.
* **Scaling UP/DOWN**: Instant service autoscaling and pretty fast ASG autoscaling.
* **Rolling deployments**: To prevent downtimes using in-app health checks as watchdog.


## How to start the enviroments.
After install all the requeriments showed at the top of this document, if you
want start the development enviroment a AWS account is not required, I recommend
to use the Vagrant way because it's fully automated-provisioning with Python 3
and all the libraries used by the application.

You should to change your CWD by `env_dev` as you can see right now:
```
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi  ‹master*›
╰─$ ls
ansible  assigment  demo  docker  env_dev  env_prod  etc  LICENSE.md  README.MD  src  terraform  workspace
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi  ‹master*›
╰─$ cd env_dev
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi/env_dev  ‹master*›
╰─$ ls
docker-compose.yml  Vagrantfile
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi/env_dev  ‹master*›
╰─$
```

For testing in a real production-ready envorioment, you should edit first the
file `ansible/prod_env.yml` and change the `aws_credentials`. After that
you should to change your CWD by `env_prod` as is showed bellow:


```
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi  ‹master*›
╰─$ ls                                                                                                                                                   130 ↵
ansible  assigment  demo  docker  env_dev  env_prod  etc  LICENSE.md  README.MD  src  terraform  workspace
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi  ‹master*›
╰─$  cd env_prod
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi/env_prod  ‹master*›
╰─$ ls
conf  Vagrantfile
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi/env_prod  ‹master*›
╰─$
```
Please read the next section, before execute anything.

## A rubber ring for the busy test-reviewer
I know, this is probably one more of dozens of TechTests that you should to review
during a short period of time. However the whole of the approaches can be executed as
Vagrant VM in a easy way just typing:
```
vagrant up --provision
```
>**Note:** The prod_env needs some configuration parameters for the AWS
credentials in `ansible/prod_env.yml` and also you should to review the
default configuration file in `prod_env/conf/ecs_stack.yml` to prevent
conflicts with your current subneting assignment.

Anywise if you don't have time for it or something was wrong in my code,
I provide you a tty "demo" recorded in my own laptop that might be watched
easily as a movie. :-)

For each "demo" you can found inside the subfolder called `demo` something
like it's showed below:

```
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi  ‹master*›
╰─$ ls -lR demo
demo:
total 8
drwxr-xr-x 2 amonfa amonfa 4096 nov  7 22:11 env_dev
drwxr-xr-x 2 amonfa amonfa 4096 nov  7 22:11 env_prod

demo/env_dev:
total 464
-rw-rw-r-- 1 amonfa amonfa 423124 nov  7 22:00 log_f
-rw-rw-r-- 1 amonfa amonfa  38759 nov  7 22:00 timing_f

demo/env_prod:
total 1584
-rw-rw-r-- 1 amonfa amonfa 1533247 nov  7 22:55 log_f
-rw-rw-r-- 1 amonfa amonfa   76071 nov  7 22:55 timing_f
╭─amonfa@emc2 ~/Development/Personal/TechTests/Zalora/Banhmi  ‹master*›
╰─$
```

These couple of files are the output of the script-scriptreplay execution
you can find more information about script in: [util-linux](https://github.com/karelzak/util-linux/tree/master/term-utils)

This software is included in the util-linux package available for the most famous
Linux distributions. I suggest you use a color terminal like `xterm` or `gnome-terminal`
in maximized mode before launch the next command:
```
╰─$ scriptreplay -d 10 --timing=demo/env_dev/timing_f demo/env_dev/log_f
```
OR
```
╰─$ scriptreplay -d 10 --timing=demo/env_prod/timing_f demo/env_prod/log_l
```
`-d --divisor <num>`: speed up or slow down execution with time divisor.


## TODOs:
* **Architectural Diagrams**: To understand better the different pieces and components for each approach.
* **Extra Doc about Autoscaling EC2 Instance**: In that approach I used ASG Lifecycles, Lambda Functions,
   SNS and ECS API to drain containers form some instance before scale down,
   ensuring the Zero Downtime. This approach is a little tricky and should be explained in detail.
* **Monitoring**: one step beyound in Cloudwatch and other providers like
  Prometheus or NewRelic.
* **Add feature**: Add API Gateway.
* **Add feature**: Add OAuth and Identity microservices for validate requests.
* **Add feature**: Add RateLimit and Quota microservices.
* **Add feature**: Add Cache-Layer for downloads.
* **Add feature**: Add App clustering capabilities.
* **Code Improve**: Add new monitoring endpoints.
* **Code Improve**: Store objects with token+filename, allowing the same filename for different users.
* **Code Improve**: Handle exceptions when the S3 service is down or unstable.


## Authors
* **Albert Monfà** - *Initial work* - [albertmonfa](https://es.linkedin.com/in/albertmonfa)


## License
This project is licensed under the Apache 2 License - see the [LICENSE.md](LICENSE.md) file for details
