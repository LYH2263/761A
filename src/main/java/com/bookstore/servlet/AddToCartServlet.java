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
 * 加入购物车Servlet（AJAX）
 */
public class AddToCartServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AddToCartServlet.class);
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
            String bookIdStr = request.getParameter("bookId");
            String quantityStr = request.getParameter("quantity");

            // 参数校验
            if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "图书ID不能为空");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            int bookId;
            int quantity = 1;
            try {
                bookId = Integer.parseInt(bookIdStr);
                if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                    quantity = Integer.parseInt(quantityStr);
                }
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "参数格式错误");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            if (quantity <= 0) {
                result.put("success", false);
                result.put("message", "数量必须大于0");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            // 添加购物车
            if (cartDAO.addItem(userId, bookId, quantity)) {
                result.put("success", true);
                result.put("message", "已加入购物车");
                logger.info("添加购物车成功: userId={}, bookId={}, quantity={}", userId, bookId, quantity);
            } else {
                result.put("success", false);
                result.put("message", "加入购物车失败，请稍后重试");
                logger.error("添加购物车失败: userId={}, bookId={}", userId, bookId);
            }
        } catch (Exception e) {
            logger.error("加入购物车处理异常", e);
            result.put("success", false);
            result.put("message", "系统错误，请稍后重试");
        }

        response.getWriter().write(JsonUtil.toJson(result));
    }
}
