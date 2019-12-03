FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4

# elasticsearch root
ENV ES_ROOT /usr/share/elasticsearch
ENV ES_JAVA_OPTS "-DproxyHost=10.74.169.139 -DproxyPort=8080 -Dhttps.proxyHost=10.74.169.139 -Dhttps.proxyPort=8080"


# install smartcn
RUN elasticsearch-plugin install analysis-smartcn

# ユーザー追加.
ARG USER_NAME
RUN useradd ${USER_NAME}

RUN chown -R ${USER_NAME}:${USER_NAME} /usr/share/elasticsearch/.

USER ${USER_NAME}

