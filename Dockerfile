FROM golang:1.6-alpine

RUN apk --update-cache add git mercurial wget

RUN go get github.com/tools/godep github.com/jonog/redalert \
  && cd /go/src/github.com/jonog/redalert \
  && godep restore \
  && go build -ldflags="-s -w" github.com/jonog/redalert

RUN curl -L -o /usr/bin/validatejson \
  https://github.com/ubergesundheit/jsonschema/releases/download/0.0.1/validatejson-musl-x64 \
  && chmod +x /usr/bin/validatejson

# download schemata for json schema validation
RUN wget -P /schemata -i http://codeformuenster.org/status.codeformuenster.org/schemaList

# put in the config..
COPY config.json /config.json

CMD ["redalert", "-config_file", "/config.json"]

