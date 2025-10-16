FROM ubuntu:25.10
COPY start.sh /start.sh
COPY env env_set
RUN apt update && apt install -y jq nano xz-utils wget
WORKDIR /
EXPOSE 34197/udp
ENTRYPOINT ["/start.sh"]
