package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;
import com.bookstore.util.JsonUtil;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户注册Servlet
 */
public class RegisterServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(RegisterServlet.class);
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

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

            // 检查用户名是否已存在
            if (userDAO.existsByUsername(username)) {
                result.put("success", false);
                result.put("message", "用户名已存在");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            // 创建用户
            User user = new User(username.trim(), password.trim(), 
                    email != null ? email.trim() : "", 
                    phone != null ? phone.trim() : "");
            
            if (userDAO.save(user)) {
                result.put("success", true);
                result.put("message", "注册成功");
                logger.info("用户注册成功: {}", username);
            } else {
                result.put("success", false);
                result.put("message", "注册失败，请稍后重试");
                logger.error("用户注册失败: {}", username);
            }
        } catch (Exception e) {
            logger.error("注册处理异常", e);
            result.put("success", false);
            result.put("message", "系统错误，请稍后重试");
        }

        response.getWriter().write(JsonUtil.toJson(result));
    }
}
