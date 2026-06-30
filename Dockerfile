# 构建阶段
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app

# 复制Maven配置（使用阿里云镜像加速）
COPY settings.xml /usr/share/maven/ref/settings.xml

# 复制pom.xml并预下载依赖
COPY pom.xml .
RUN mvn -s /usr/share/maven/ref/settings.xml dependency:go-offline

# 复制源代码并打包
COPY src ./src
RUN mvn -s /usr/share/maven/ref/settings.xml package -DskipTests && \
    cd /app/target && mkdir ROOT && cd ROOT && jar -xf ../bookstore.war

# 运行阶段
FROM tomcat:9.0-jre8
WORKDIR /usr/local/tomcat

# 设置UTF-8环境变量
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=Asia/Shanghai"

# 删除默认应用并部署已解压的 ROOT 应用（避免 WAR 未及时展开导致 404）
RUN rm -rf webapps/*

COPY --from=build /app/target/ROOT webapps/ROOT

# 显式配置 ROOT 上下文，确保根路径应用被加载（解决 404）
RUN mkdir -p conf/Catalina/localhost
COPY tomcat-context/ROOT.xml conf/Catalina/localhost/ROOT.xml

# 暴露端口
EXPOSE 8080

# 启动Tomcat
CMD ["catalina.sh", "run"]
