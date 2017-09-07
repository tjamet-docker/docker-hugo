# docker-hugo
small docker image to run hugo https://gohugo.io

This image has the same interface as the great https://hub.docker.com/r/publysher/hugo/

It differs in 3 ways:
- The latest version of hugo is installed through go get
- The output image is as small as possible thanks to an alpine base image (22MB versus 240 when based on debian)
- It does not include the pygments syntax highlight tool

Prerequisites
-------------

The image is based on the following directory structure:

    .
    ├── Dockerfile
    └── site
        ├── config.toml
        ├── content
        │   └── ...
        ├── layouts
        │   └── ...
        └── static
        └── ...

In other words, your Hugo site resides in the `site` directory, and you have a simple Dockerfile:

    FROM tjamet/hugo 


Building your site
------------------

Based on this structure, you can easily build an image for your site:

    docker build -t my/image .

Your site is automatically generated during this build. 


Using your site
---------------

There are two options for using the image you generated: 

- as a stand-alone image
- as a volume image for your webserver

Using your image as a stand-alone image is the easiest:

    docker run -p 1313:1313 my/image

This will automatically start `hugo server`, and your blog is now available on http://localhost:1313. 

If you are using `boot2docker`, you need to adjust the base URL: 

    docker run -p 1313:1313 -e HUGO_BASE_URL=http://YOUR_DOCKER_IP:1313 my/image

The image is also suitable for use as a volume image for a web server, such as [nginx](https://registry.hub.docker.com/_/nginx/)

    docker run -d -v /usr/share/nginx/html --name site-data my/image
    docker run -d --volumes-from site-data --name site-server -p 80:80 nginx

Packaging your site in an nginx container
-----------------------------------------

Add the following Dockerfile to the root of your project (you can replace tjamet/hugo by publysher/hugo to use pygments)

    FROM tjamet/hugo as build
    FROM nginx:alpine
    COPY --from=build /usr/share/nginx/html/* /usr/share/nginx/html/

Then build and run your image:

    docker build -t my/website .
    docker run -p 80:80 my/website
