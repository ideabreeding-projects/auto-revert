FROM ubuntu:latest

LABEL repository="https://github.com/ideabreeding-projects/auto-revert"
LABEL homepage="https://github.com/ideabreeding-projects/auto-revert"
LABEL "com.github.actions.name"="Automatic Revert"
LABEL "com.github.actions.description"="Automatically revert a direct commit"
LABEL "com.github.actions.color"="red"

RUN apt update; apt install -y jq bash curl git

ADD entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
