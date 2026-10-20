ARG JAVA_IMAGE=eclipse-temurin:21-jre-jammy
FROM ${JAVA_IMAGE}

# 系统备份功能需要 Linux mysql/mysqldump；curl 用于健康检查。
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl mysql-client-8.0 \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --gid 10001 lightning \
    && useradd --uid 10001 --gid lightning --no-create-home lightning

WORKDIR /opt/lightning
COPY --chown=lightning:lightning payload/app/ ./
COPY --chown=lightning:lightning backend/application-docker.yml ./config/application-docker.yml
COPY --chown=lightning:lightning backend/logback-spring.xml ./config/logback-spring.xml
RUN mkdir -p data/upload logs backup/temp plugins \
    && chown -R lightning:lightning /opt/lightning

USER lightning
EXPOSE 8080
# Logback 可能早于 Spring 读取 YAML；两个初始化阶段均显式使用外部日志配置。
ENTRYPOINT ["java", "-Dapp.home=/opt/lightning", "-Dlogback.configurationFile=/opt/lightning/config/logback-spring.xml", "-Dlogging.config=file:/opt/lightning/config/logback-spring.xml", "-jar", "lightning-server.jar", "--spring.profiles.active=docker", "--spring.config.additional-location=file:/opt/lightning/config/"]
