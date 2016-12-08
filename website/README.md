# olympe

## You're a Ptrainer dev ?

1. Setup docker:
 - ![Linux][linux_logo] Install [docker](https://docs.docker.com/installation/):
    I would personnaly recommend installing it from the binaries as it gives you full control over the whole docker process
    With a recent ubuntu, after ensuring `cgroups` are installed (`apt-get install cgroup-bin`), you can simply do:

    ```sh
    curl https://get.docker.com/builds/Linux/x86_64/docker-latest > /usr/local/bin/docker
    chmod +x /usr/local/bin/docker
    ```
    If you do install it manually, you will have to manage the docker daemon yourself by running:

    ```sh
    sudo docker daemon
    ```
    in the background

    Also, to avoid having to sudo every docker command, you can create a group called `docker`. If you are part of it, you will be able to interact with the docker daemon. [Here are more details on how to create a group on Unix systems](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)
 - ![Windows][windows_logo] ![OS X][osx_logo] Install [docker toolbox](https://www.docker.com/toolbox/) then run:

   ```sh
   docker-machine create \
            --driver virtualbox \
            --virtualbox-memory 4096 \
            --virtualbox-disk-size 40000 \
            your-dev-machine-name
   ```
   to create a minimalist linux VM with a docker daemon installed

2. ![Linux][linux_logo] Install [docker-compose](https://docs.docker.com/compose/install/):
   I would once again recommend installing it from the binaries:
   ```sh
   curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
   chmod +x /usr/local/bin/docker-compose
   ```

3. Clone this repository:
 ```sh
  git clone github:Ptrainer/olympe.git some_name_like_nav_or_pony
 ```
 :warning: docker-machine users ![Windows][windows_logo] ![OS X][osx_logo]
 The repository should be cloned within the *Users* directory for it to be easily accessible from your linux machine (`/Users` on ![OS X][osx_logo] and `C:\Users` on ![Windows][windows_logo])

4. Add the `$NAV` variable to your environment.
 It must contain the path to the freshly cloned repository.
 This is usually done by adding the following line to your favourite shell's run command  file:
 ```sh
 export NAV=/path/to/olympe
 ```

5. ![Windows][windows_logo] ![OS X][osx_logo], add the `$NAV_MACHINE_NAME` variable to your environment
 It must contain the name of the machine you created for Ptrainer development
 ```sh
 export NAV_MACHINE_NAME=your_dev_machine_name
 ```
 Since your docker CLIs need to communicate with a non-local docker daemon, you should also put the following alias in your shell's run command file:
 ```sh
 alias docker_env="eval $(docker-machine env $NAV_MACHINE_NAME)"
 ```

6. run `$NAV/dev.sh -i`
 It will:
  - Clone every Ptrainer project into subdirectories of `$NAV`
  - Add local, untracked development configuration files to each subproject
  - Build Ptrainer images

7. Ready to hack ?

 You can now hack on:
  - [app.navendis.dev](http://app.navendis.dev)
  - [chronos.navendis.dev](http://chronos.navendis.dev)
  - [atlas.navendis.dev](http://atlas.navendis.dev)

[linux_logo]: http://forum.audacityteam.org/images/custom_images/logo_linux_32px.png
[windows_logo]: http://res2.windows.microsoft.com/resbox/en/windows/main/eb4f0171-7cb7-428a-afcc-d93a6b84525c_33.png
[osx_logo]: http://wiki.freepascal.org/images/7/7a/Logo_OSX.png
