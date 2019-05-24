# docker-hugo
small docker image to run hugo https://gohugo.io

This image provides a [whalebrew](https://github.com/whalebrew/whalebrew) package to run [hugo](https://gohugo.io)

Running through whalebrew
-------------------------

To install it through whalebrew, just run `whalebrew install tjamet/hugo` to benefit the plain `hugo` command.

Running directly through docker
-------------------------------
`docker run --rm -v $PWD:/src -w /src -p 1313:1313 tjamet/hugo server -b http://localhost:1313 --bind=0.0.0.0`

Building a static docker image
------------------------------

Create a Dockerfile like this one

```Dockerfile

FROM tjamet/hugo as build

RUN mkdir -p /src
WORKDIR /src
COPY . /src/
RUN hugo

FROM nginx:alpine
COPY --from=build /src/public/ /usr/share/nginx/html/
```

Run a `docker build`

And enjoy your static website
