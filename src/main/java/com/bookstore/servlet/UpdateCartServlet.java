package com.bookstore.servlet;

import com.bookstore.dao.CartDAO;
import com.bookstore.model.CartItem;
import com.bookstore.util.JsonUtil;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 更新购物车Servlet（AJAX）
 */
public class UpdateCartServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(UpdateCartServlet.class);
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
            
            // 详细日志：打印所有请求参数
            logger.info("=== UpdateCartServlet 收到请求 ===");
            logger.info("userId: {}", userId);
            logger.info("所有参数名: {}", request.getParameterMap().keySet());
            request.getParameterMap().forEach((key, values) -> {
                logger.info("参数 {} = {}", key, String.join(", ", values));
            });
            
            String cartItemIdStr = request.getParameter("cartItemId");
            String quantityStr = request.getParameter("quantity");
            
            logger.info("获取的 cartItemId 参数: '{}'", cartItemIdStr);
            logger.info("获取的 quantity 参数: '{}'", quantityStr);

            // 参数校验
            if (cartItemIdStr == null || cartItemIdStr.trim().isEmpty()) {
                logger.error("❌ 购物车项ID为空！cartItemIdStr: '{}'", cartItemIdStr);
                result.put("success", false);
                result.put("message", "购物车项ID不能为空");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            int cartItemId;
            int quantity;
            try {
                cartItemId = Integer.parseInt(cartItemIdStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                result.put("success", false);
                result.put("message", "参数格式错误");
                response.getWriter().write(JsonUtil.toJson(result));
                return;
            }

            if (quantity <= 0) {
                // 数量为0或负数，删除该项
                if (cartDAO.deleteItem(cartItemId)) {
                    result.put("success", true);
                    result.put("message", "已删除");
                    result.put("quantity", 0);
                } else {
                    result.put("success", false);
                    result.put("message", "删除失败");
                }
            } else {
                // 更新数量
                if (cartDAO.updateQuantity(cartItemId, quantity)) {
                    result.put("success", true);
                    result.put("message", "更新成功");
                    result.put("quantity", quantity);
                } else {
                    result.put("success", false);
                    result.put("message", "更新失败");
                }
            }

            // 计算总价
            List<CartItem> cartItems = cartDAO.findByUserId(userId);
            BigDecimal total = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                total = total.add(item.getSubtotal());
            }

            result.put("total", total.toString());
            logger.info("更新购物车成功: userId={}, cartItemId={}, quantity={}", userId, cartItemId, quantity);

        } catch (Exception e) {
            logger.error("更新购物车处理异常", e);
            result.put("success", false);
            result.put("message", "系统错误，请稍后重试");
        }

        response.getWriter().write(JsonUtil.toJson(result));
    }
}
