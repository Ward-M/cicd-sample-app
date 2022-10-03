#!/bin/bash
set -euo pipefail

if [[ ! -d "tempdir" ]]
then
    if [ -L tempdir]
then
    echo "Folder doesn't exist. Creating now"
    mkdir tempdir
    echo "tempdir created"
    else
        echo "tempdir exists"
    fi
fi

if [[ ! -d "tempdir/templates" ]]
then
    if [ -L tempdir/templates]
then
    echo "Folder doesn't exist. Creating now"
    mkdir tempdir/templates
    echo "tempdir/templates created"
    else
        echo "tempdir/templates exists"
    fi
fi

if [[ ! -d "tempdir/static" ]]
then
    if [ -L tempdir/static]
then
    echo "Folder doesn't exist. Creating now"
    mkdir tempdir/static
    echo "tempdir/static created"
    else
        echo "tempdir/static exists"
    fi
fi


cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
