FROM python:3.7
RUN pip install flask
RUN pip install mysql-connector-python-rf
RUN pip install requests
RUN pip install flask_mysqldb
VOLUME /flask
copy flask/ /flask
EXPOSE 8080
WORKDIR /flask
CMD ["python","./app_script.py]
