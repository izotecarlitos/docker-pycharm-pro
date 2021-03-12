Docker container to run PyCharm Professional Edition (https://www.jetbrains.com/pycharm/)

### Usage

```
docker run \
    -e DISPLAY=${DISPLAY} \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/PycharmProjects:/home/developer/PycharmProjects \
    -v ~/PycharmSettings/config:/home/developer/PycharmSettings/config \
    -v ~/PycharmSettings/debugeggs:/home/developer/PycharmSettings/debugeggs \
    -v ~/PycharmSettings/log:/home/developer/PycharmSettings/log \
    -v ~/PycharmSettings/plugins:/home/developer/PycharmSettings/plugins \
    -v ~/PycharmSettings/system:/home/developer/PycharmSettings/system \
    --privileged \
    --net=host \
    --name pycharm-2020.3.3 \
izotecarlitos/pycharm-pro:2020.3.3
```
#### For Windows hosts (simplified):
```
docker.exe run --rm -d ^
    --name pycharm-pro ^
    -e DISPLAY=YOUR_IP_ADDRESS:0.0 ^
    -v %TEMP%\.X11-unix:/tmp/.X11-unix ^
    -v %USERPROFILE%\pycharm-docker:/home/developer ^
    -v %USERPROFILE%\pycharm-docker\python2.7:/usr/local/lib/python2.7 ^
    -v %USERPROFILE%\pycharm-docker\python3.7:/usr/local/lib/python3.7 ^
izotecarlitos/pycharm-pro:2020.3.3
```

Docker Hub Page: https://hub.docker.com/r/rycus86/pycharm-pro/

### Notes

You'll still need a license to use the application!

The IDE will have access to Python 2 and 3 both and to Git as well.
Project folders need to be mounted like `-v ~/Project:/home/developer/Project`.
The actual name can be anything - I used something random to be able to start multiple instances if needed.

To use `pip` (or `pip3`) either use the terminal in PyCharm or install from the terminal from inside the container like `docker exec -it pycharm-running bash` then install using **pip**.

To run container on Windows hosted machines you will need to have some X server installed and launched (e.g. Xming)

The icon was taken from here: https://yuruli.info/django3-on-docker-in-pycharm/ 

