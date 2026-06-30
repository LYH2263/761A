package com.bookstore.util;

import javax.servlet.*;
import java.io.IOException;

/**
 * 字符编码过滤器（不依赖 SLF4J，避免与 Tomcat 类加载冲突导致 Filter 启动失败）
 */
public class CharacterEncodingFilter implements Filter {
    private static final String DEFAULT_ENCODING = "UTF-8";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 不在此处使用 Logger，避免 Tomcat 下 SLF4J/Logback 初始化顺序导致 Filter 启动失败
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding(DEFAULT_ENCODING);
        response.setCharacterEncoding(DEFAULT_ENCODING);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
