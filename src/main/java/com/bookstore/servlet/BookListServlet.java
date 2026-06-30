package com.bookstore.servlet;

import com.bookstore.dao.BookDAO;
import com.bookstore.model.Book;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

/**
 * 图书列表Servlet
 */
public class BookListServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(BookListServlet.class);
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置响应字符编码为UTF-8
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try {
            List<Book> books = bookDAO.findAll();
            request.setAttribute("books", books);
            request.getRequestDispatcher("/jsp/book-list.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("获取图书列表失败", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取图书列表失败");
        }
    }
}
