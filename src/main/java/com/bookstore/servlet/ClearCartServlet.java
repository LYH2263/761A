package com.bookstore.servlet;

import com.bookstore.dao.CartDAO;
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
 * 清空购物车Servlet
 */
public class ClearCartServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ClearCartServlet.class);
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        try {
            // 检查登录状态
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                result.put("success", false);
                result.put("message", "请先登录");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            Integer userId = (Integer) session.getAttribute("userId");

            if (cartDAO.clearByUserId(userId)) {
                result.put("success", true);
                result.put("message", "购物车已清空");
                logger.info("清空购物车成功: userId={}", userId);
            } else {
                result.put("success", false);
                result.put("message", "清空购物车失败");
                logger.error("清空购物车失败: userId={}", userId);
            }
        } catch (Exception e) {
            logger.error("清空购物车处理异常", e);
            result.put("success", false);
            result.put("message", "系统错误，请稍后重试");
        }

        response.getWriter().write(JsonUtil.toJson(result));
    }
}
