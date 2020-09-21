# cvguru-dockerimg

Dockerfile for [pyimagesearch-gurus-course](https://gurus.pyimagesearch.com/courses/pyimagesearch-gurus-course/)
It contains all the dependencies according to [this setup](https://gurus.pyimagesearch.com/setting-up-your-python-opencv-development-environment/)

## Usage with [vscode remote container](https://code.visualstudio.com/docs/remote/containers)

- Build a docker image or use [jonsom/cvguru](https://hub.docker.com/repository/docker/jonsom/cvguru) image. We will consider `jonsom/cvguru` to be the name of the image.
- create a folder named `.devcontainer` at the root of your project directory
- create the file `.devcontainer/Dockerfile` with the following content:
```dockerfile
FROM jonsom/cvguru
```
- create the file `.devcontainer/devcontainer.json` with the following content:
 ```js
{
	"name": "Python 3",
	"build": {
		"dockerfile": "Dockerfile",
		"context": ".."
	},

	"runArgs": [
		"-v", "/tmp/.X11-unix:/tmp/.X11-unix"
	],

	"containerEnv": {
		"DISPLAY": "${localEnv:HOSTNAME}:0"
	},

	"settings": { 
		"terminal.integrated.shell.linux": "/bin/bash",
		"python.pythonPath": "/usr/local/bin/python",
		"python.linting.enabled": true,
		"python.linting.pylintEnabled": true,
		"python.formatting.autopep8Path": "/usr/local/py-utils/bin/autopep8",
		"python.formatting.blackPath": "/usr/local/py-utils/bin/black",
		"python.formatting.yapfPath": "/usr/local/py-utils/bin/yapf",
		"python.linting.banditPath": "/usr/local/py-utils/bin/bandit",
		"python.linting.flake8Path": "/usr/local/py-utils/bin/flake8",
		"python.linting.mypyPath": "/usr/local/py-utils/bin/mypy",
		"python.linting.pycodestylePath": "/usr/local/py-utils/bin/pycodestyle",
		"python.linting.pydocstylePath": "/usr/local/py-utils/bin/pydocstyle",
		"python.linting.pylintPath": "/usr/local/py-utils/bin/pylint"
	},

	"extensions": [
		"ms-python.vscode-pylance"
	],

	"remoteUser": "vscode"
}

 ```
 - Setup X11 forwarding in order to display image and graphs from the container. 
 For Mac users, you can follow [this gist](https://gist.github.com/cschiewek/246a244ba23da8b9f0e7b11a68bf3285)
 
 That's it. You can open your project folder inside remote container with vscode.
