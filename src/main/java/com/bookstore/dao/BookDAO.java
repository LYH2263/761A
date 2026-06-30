package com.bookstore.dao;

import com.bookstore.model.Book;
import com.bookstore.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 图书数据访问层
 */
public class BookDAO {
    private static final Logger logger = LoggerFactory.getLogger(BookDAO.class);

    /**
     * 查询所有图书
     */
    public List<Book> findAll() {
        String sql = "SELECT id, title, author, isbn, price, description, image_url, stock FROM books ORDER BY id";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Book> books = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setDescription(rs.getString("description"));
                book.setImageUrl(rs.getString("image_url"));
                book.setStock(rs.getInt("stock"));
                books.add(book);
            }
            logger.debug("查询所有图书成功，共{}本", books.size());
        } catch (SQLException e) {
            logger.error("查询所有图书失败", e);
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return books;
    }

    /**
     * 根据ID查询图书
     */
    public Book findById(Integer id) {
        String sql = "SELECT id, title, author, isbn, price, description, image_url, stock FROM books WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setDescription(rs.getString("description"));
                book.setImageUrl(rs.getString("image_url"));
                book.setStock(rs.getInt("stock"));
                logger.debug("查询图书成功: id={}", id);
                return book;
            }
        } catch (SQLException e) {
            logger.error("查询图书失败: id={}", id, e);
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    private void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                logger.error("关闭ResultSet失败", e);
            }
        }
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                logger.error("关闭PreparedStatement失败", e);
            }
        }
        DBUtil.closeConnection(conn);
    }
}
