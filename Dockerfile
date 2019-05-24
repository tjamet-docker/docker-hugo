FROM golang:alpine AS build
RUN  apk add --no-cache git
RUN  go get github.com/gohugoio/hugo


FROM alpine
COPY --from=build /go/bin/hugo /bin/hugo
ENTRYPOINT ["hugo"]
LABEL io.whalebrew.config.ports '["1313:1313"]'

