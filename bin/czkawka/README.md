# `czkawka`

**GitHub:** [https://github.com/qarmin/czkawka](https://github.com/qarmin/czkawka)

**Description:** Czkawka (tch•kav•ka (IPA: [ʈ͡ʂkafka]), "hiccup" in Polish) is a simple, fast and free app to remove
unnecessary files from your computer.

## Installation

Run the `./install.sh` script.

## Running on Synology NAS

1. Launch Docker Container
    ```shell
    sudo docker stop czkawka && sudo docker rm czkawka && sudo docker run -d \
        --name=czkawka \
        -p 5800:5800 \
        -e USER_ID=0 \
        -e GROUP_ID=0 \
        -v /volume1/docker/czkawka:/config:rw \
        -v /volume1:/storage:ro \
        jlesage/czkawka
    ```
   _**Note:** The `USER_ID` and `GROUP_ID` environment variables are set to 0 since `/volume1` is owned by `root`. Change as necessary._
2. Visit `http://<synology_hostname>:5800`