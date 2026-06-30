package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import com.bookstore.util.JsonUtil;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户登录Servlet
 */
public class LoginServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Object> result = new HashMap<>();
        try {
            response.setContentType("application/json;charset=UTF-8");
        } catch (Throwable t) {
            logger.warn("设置 Content-Type 失败（响应可能已提交）", t);
        }

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            // 参数校验
            if (username == null || username.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "用户名不能为空");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            if (password == null || password.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "密码不能为空");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            // 查询用户
            User user = userDAO.findByUsername(username.trim());
            if (user == null) {
                result.put("success", false);
                result.put("message", "用户名或密码错误");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            // 验证密码（简单比较，实际应该使用加密）
            String storedPassword = user.getPassword();
            if (storedPassword == null || !storedPassword.equals(password.trim())) {
                result.put("success", false);
                result.put("message", "用户名或密码错误");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            // 登录成功，设置Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());

            result.put("success", true);
            result.put("message", "登录成功");
            Map<String, Object> userMap = new HashMap<>();
            userMap.put("id", user.getId());
            userMap.put("username", user.getUsername());
            result.put("user", userMap);
            logger.info("用户登录成功: {}", username);

        } catch (Throwable e) {
            try {
                logger.error("登录处理异常", e);
            } catch (Throwable ignored) {
                // 避免日志记录时再次抛错导致 500
            }
            result.put("success", false);
            result.put("message", "系统错误，请稍后重试");
        }

        try {
            response.getWriter().write(JsonUtil.toJson(result));
        } catch (Throwable t) {
            logger.error("写入登录响应失败", t);
        }
    }
}
