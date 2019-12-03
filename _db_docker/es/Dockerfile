FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4

# elasticsearch root
ENV ES_ROOT /usr/share/elasticsearch

# kuromojiをインストール
# RUN elasticsearch-plugin install analysis-kuromoji

# install smartcn
RUN elasticsearch-plugin install analysis-smartcn

# ユーザー追加.
ARG USER_NAME
RUN useradd ${USER_NAME}

# install IK Analysis
# RUN elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.5.4/elasticsearch-analysis-ik-6.5.4.zip

# manual install IK Analysis
# ENV IK_PLUGIN ${ES_ROOT}/plugins/analysis-ik
# ENV IK_CONFIG ${ES_ROOT}/config/analysis-ik

# COPY ./elasticsearch-analysis-ik-6.5.4.zip ${ES_ROOT}
# RUN unzip -o -d ${IK_PLUGIN}/ /usr/share/elasticsearch/elasticsearch-analysis-ik-6.5.4.zip
# RUN mkdir ${IK_CONFIG}
# RUN mv ${IK_PLUGIN}/config/* ${IK_CONFIG}/.

# copy config file
COPY ./elasticsearch.yml ${ES_ROOT}/config/
RUN chmod 660 ${ES_ROOT}/config/elasticsearch.yml

# COPY ./log4j2.properties /usr/share/elasticsearch/config/
# RUN chmod 660 /usr/share/elasticsearch/config/log4j2.properties

RUN chown -R ${USER_NAME}:${USER_NAME} /usr/share/elasticsearch/.

USER ${USER_NAME}

