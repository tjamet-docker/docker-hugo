FROM golang:alpine AS build
RUN  apk add --no-cache git
RUN  go get github.com/gohugoio/hugo

FROM alpine
COPY --from=build /go/bin/hugo /bin/hugo
# Create working directory
RUN mkdir /usr/share/blog
WORKDIR /usr/share/blog

# Expose default hugo port
EXPOSE 1313

# By default, serve site
ENV HUGO_BASE_URL http://localhost:1313
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0

# Automatically build site
ONBUILD ADD site/ /usr/share/blog
ONBUILD RUN hugo -d /usr/share/nginx/html/
