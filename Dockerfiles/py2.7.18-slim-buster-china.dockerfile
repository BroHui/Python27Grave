FROM python:2.7.18-slim-buster
ENV PYTHONUNBUFFERED 1
RUN sed -i s@/deb.debian.org/@/mirrors.163.com/@g /etc/apt/sources.list \
    && sed -i s@/security.debian.org/@/mirrors.163.com/@g /etc/apt/sources.list \
    && apt-get clean
RUN apt-get update \
    && apt-get install -y gcc \
        git \
        default-libmysqlclient-dev libmariadb3 python-mysqldb 
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple/ \
    && pip config set install.trusted-host pypi.tuna.tsinghua.edu.cn 
COPY ./requirements.txt .
RUN easy_install rsa==3.1.1 \
    && pip install -U pip \
    && pip install --no-cache-dir -r requirements.txt
WORKDIR /opt/
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]