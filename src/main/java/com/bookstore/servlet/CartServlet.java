package com.bookstore.servlet;

import com.bookstore.dao.CartDAO;
import com.bookstore.model.CartItem;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

/**
 * 购物车查询Servlet
 */
public class CartServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CartServlet.class);
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 检查登录状态
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/html/login.html");
                return;
            }

            Integer userId = (Integer) session.getAttribute("userId");
            List<CartItem> cartItems = cartDAO.findByUserId(userId);
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/jsp/cart.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("获取购物车失败", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取购物车失败");
        }
    }
}
