FROM ubuntu:14.10
MAINTAINER Pawel Pikula <pawel.pikula@erlang-solutions.com>

ENV HOME /opt/mongooseim
ENV MONGOOSEIM_VERSION stable
ENV MONGOOSEIM_REL_DIR /opt/mongooseim/rel/mongooseim
ENV PATH /opt/mongooseim/rel/mongooseim/bin/:$PATH

# install required packages
RUN apt-get update && apt-get install -y   wget \
                                           git \
                                           make \
                                           gcc \
                                           libc6-dev \
                                           libncurses5-dev \
                                           libssl-dev \
                                           libexpat1-dev \
                                           libpam0g-dev

# add esl packages
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc\
    && apt-key add erlang_solutions.asc \
    && apt-get update \
    && apt-get install -y erlang-base \
                          erlang-dev \
                          erlang-nox \
                          erlang-dialyzer \
                          erlang-reltool

# install mim from source
RUN git clone https://github.com/esl/MongooseIM.git -b $MONGOOSEIM_VERSION /opt/mongooseim \
    && cd /opt/mongooseim \
    && make rel

COPY ./start.sh start.sh

# expose xmpp, rest, s2s, epmd, distributed erlang
EXPOSE 5222 5280 5269 4369 9100 


# TODO: expose cfg/vmargs/mnesia db/

ENTRYPOINT ["./start.sh"]

