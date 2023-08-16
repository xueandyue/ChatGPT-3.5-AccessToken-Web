# 使用 Python 3.9 的官方镜像作为基础镜像
FROM python:3.9-buster

# 设置工作目录为 /app
WORKDIR /app

#复制脚本
COPY myscript.sh /app/myscript.sh

# 更新系统并安装 curl，bash和 git,cron
RUN apt-get update && apt-get install -y curl bash git cron lsof


# 安装 Node.js 和 yarn
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn




RUN yarn config set registry https://registry.npm.taobao.org

# 安装 pandora 项目
RUN git clone https://github.com/pengzhile/pandora.git \
    && cd pandora \
    && pip install .

# 下载和安装项目
RUN git clone https://github.com/xueandyue/ChatGPT-3.5-AccessToken-Web.git \
    && cd ChatGPT-3.5-AccessToken-Web \
    && git pull origin advertisement \
    && yarn install \
    && yarn build 

#设置定时任务
RUN crontab -l | { cat; echo "0 0 */10 * * bash /app/myscript.sh"; } | crontab -

# 开放端口3000
EXPOSE 3000
# 开放端口8008
EXPOSE 8008

# 环境变量
ENV username=Youruser password=Yourpassowrd CODE=YourCode

CMD sh -c 'echo "${username},${password}" > /app/ChatGPT-3.5-AccessToken-Web/user.txt && cron && sh myscript.sh && cd /app/ChatGPT-3.5-AccessToken-Web && git pull origin advertisement && yarn build && yarn start'


