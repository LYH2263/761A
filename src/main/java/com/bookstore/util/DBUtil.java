package com.bookstore.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 数据库工具类
 */
public class DBUtil {
    private static final Logger logger = LoggerFactory.getLogger(DBUtil.class);
    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is != null) {
                props.load(is);
                driver = props.getProperty("db.driver");
                url = props.getProperty("db.url");
                username = props.getProperty("db.username");
                password = props.getProperty("db.password");
                Class.forName(driver);
                logger.info("数据库配置加载成功: {}", url);
            } else {
                logger.error("无法加载数据库配置文件 db.properties");
            }
        } catch (Exception e) {
            logger.error("数据库初始化失败", e);
            throw new RuntimeException("数据库初始化失败", e);
        }
    }

    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        try {
            // 字符集已在连接URL中配置（characterEncoding=UTF-8, connectionCollation=utf8mb4_unicode_ci），确保正确读取UTF-8编码的中文字符
            Connection conn = DriverManager.getConnection(url, username, password);
            // 显式设置连接的字符集，确保正确读取UTF-8数据
            try (java.sql.Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci'");
                stmt.execute("SET CHARACTER SET utf8mb4");
                stmt.execute("SET character_set_client = utf8mb4");
                stmt.execute("SET character_set_connection = utf8mb4");
                stmt.execute("SET character_set_results = utf8mb4");
            }
            logger.debug("获取数据库连接成功");
            return conn;
        } catch (SQLException e) {
            logger.error("获取数据库连接失败", e);
            throw e;
        }
    }

    /**
     * 关闭数据库连接
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.debug("数据库连接已关闭");
            } catch (SQLException e) {
                logger.error("关闭数据库连接失败", e);
            }
        }
    }
}
