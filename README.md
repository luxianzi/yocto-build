# Docker Environment for Yocto build

Prerequirement:
We need to have docker installed on build machine and also need a docker user\
name.
```
sudo apt install docker.io
sudo usermod -aG docker ${USER}
reboot
...
docker login
```

See https://www.nxp.com/docs/en/user-guide/IMX_LINUX_USERS_GUIDE.pdf for \
detailed getting started instructions.

To create and start the docker environment, run:
```
./create_docker_image.sh
```

This process will take approximately 15 minutes depending upon your internet\
connection speed.

Once completed successfully, you will be dropped into a command prompt where\
you can start downloading the actual BSP.

The docker environment is just the Ubuntu 18.04 build environment.  All data is\
stored on your host file system in the imx-yocto-bsp folder allowing you to use\
your development tools in your host environment.

To resume the docker instance after exiting, run:
```
./resume_docker.sh
```

About proxy:
Some times the download will be blocked by GFW, we need to use a tool like\
V2Ray, and set the proxy configuration to ~/.docker/config.json.
```
{
	"proxies": {
		"default": {
			"httpProxy": "http://127.0.0.1:3001",
			"httpsProxy": "http://127.0.0.1:3001",
			"ftpProxy": "http://127.0.0.1:3001",
			"noProxy": "*.test.example.com,.example2.com,127.0.0.0/8"
		}
	}
}
```
And mount the host ~/.docker directory as a volume to client ~/.docker.
```
docker run --name "$DOCKER_IMAGE_TAG"-instance \
	--volume $(pwd)/imx-yocto-bsp:/home/builder/imx-yocto-bsp \
	--volume ${HOME}/.ssh:/home/builder/.ssh \
	--volume ${HOME}/.docker:/home/builder/.docker \
	--volume /lib/modules:/lib/modules \
	--volume /usr/src:/usr/src \
	--rm \
	-it "$DOCKER_IMAGE_TAG" \
	/bin/bash
```
