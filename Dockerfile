FROM node
ENV WORKDIR /usr/local/app
ADD . $WORKDIR
WORKDIR $WORKDIR
RUN npm install
