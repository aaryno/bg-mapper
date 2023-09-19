FROM kartoza/postgis

RUN apt-get update && apt-get upgrade -y && apt-get install -y vim jq unzip curl && apt-get autoremove -y 

ADD scripts /scripts
