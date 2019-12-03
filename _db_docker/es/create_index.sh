#!/bin/sh

# URL="https://search-lupin-y3kqpowxx3engbalv3hy7cqemy.ap-northeast-1.es.amazonaws.com";
#Windows\System32\drivers\etc\hosts\hosts(127.0.0.1 elasticsearch)
URL="http://elasticsearch:9200/";
INDEX="repaircase_article";
TYPE="rc_type";
HEAD="\"Content-Type: application/json\"";
SETTING_FILE="\"@setting.json\"";
MAPPING_FILE="\"@mapping.json\"";
IMPORT_FILE="\"@import_data.json\"";

# index delete
echo =================
echo ==  delete index
echo =================
cmd="curl -H $HEAD -XDELETE $URL$INDEX"
echo '> '$cmd
eval $cmd
read -p "press continue: "

# create index and setting
echo =================
echo ==  create index
echo =================
SETTING_URL=$URL$INDEX
cmd="curl -H $HEAD -XPUT $SETTING_URL -d $SETTING_FILE"
echo '> '$cmd
eval $cmd
read -p "press continue: "

# mapping
echo =================
echo ==  mapping
echo =================
MAPPING_URL=$URL$INDEX'/_mapping/'$TYPE
cmd="curl -H $HEAD -XPUT $MAPPING_URL -d $MAPPING_FILE"
echo '> '$cmd
eval $cmd
read -p "press continue: "

# data import
echo =================
echo ==  import
echo =================
IMPORT_URL=$URL$INDEX'/'$TYPE'/_bulk'
cmd="curl -H $HEAD -XPOST $IMPORT_URL --data-binary $IMPORT_FILE"
echo '> '$cmd
eval $cmd
read -p "press continue: "

echo =================
echo ==  END
echo =================

