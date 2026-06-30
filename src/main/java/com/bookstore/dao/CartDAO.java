package com.bookstore.dao;

import com.bookstore.model.Book;
import com.bookstore.model.CartItem;
import com.bookstore.util.DBUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车数据访问层
 */
public class CartDAO {
    private static final Logger logger = LoggerFactory.getLogger(CartDAO.class);

    /**
     * 查询用户购物车
     */
    public List<CartItem> findByUserId(Integer userId) {
        String sql = "SELECT c.id, c.user_id, c.book_id, c.quantity, " +
                "b.id as book_id_col, b.title, b.author, b.isbn, b.price, b.description, b.image_url, b.stock " +
                "FROM cart_items c " +
                "LEFT JOIN books b ON c.book_id = b.id " +
                "WHERE c.user_id = ? " +
                "ORDER BY c.id";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CartItem> items = new ArrayList<>();

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                // 使用 getObject 然后转换为 Integer，可以正确处理 null 值
                Object idObj = rs.getObject("id");
                if (idObj != null) {
                    item.setId(((Number) idObj).intValue());
                }
                item.setUserId(rs.getInt("user_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));

                Book book = new Book();
                book.setId(rs.getInt("book_id_col"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setDescription(rs.getString("description"));
                book.setImageUrl(rs.getString("image_url"));
                book.setStock(rs.getInt("stock"));
                item.setBook(book);

                items.add(item);
            }
            logger.debug("查询购物车成功: userId={}, 共{}项", userId, items.size());
        } catch (SQLException e) {
            logger.error("查询购物车失败: userId={}", userId, e);
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return items;
    }

    /**
     * 添加购物车项
     */
    public boolean addItem(Integer userId, Integer bookId, Integer quantity) {
        // 先检查是否已存在
        CartItem existing = findByUserIdAndBookId(userId, bookId);
        if (existing != null) {
            // 更新数量
            return updateQuantity(existing.getId(), existing.getQuantity() + quantity);
        }

        String sql = "INSERT INTO cart_items (user_id, book_id, quantity) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);
            pstmt.setInt(3, quantity);
            int result = pstmt.executeUpdate();
            logger.info("添加购物车项成功: userId={}, bookId={}, quantity={}", userId, bookId, quantity);
            return result > 0;
        } catch (SQLException e) {
            logger.error("添加购物车项失败: userId={}, bookId={}", userId, bookId, e);
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * 根据用户ID和图书ID查询购物车项
     */
    public CartItem findByUserIdAndBookId(Integer userId, Integer bookId) {
        String sql = "SELECT id, user_id, book_id, quantity FROM cart_items WHERE user_id = ? AND book_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, bookId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                return item;
            }
        } catch (SQLException e) {
            logger.error("查询购物车项失败: userId={}, bookId={}", userId, bookId, e);
        } finally {
            closeResources(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 更新购物车项数量
     */
    public boolean updateQuantity(Integer cartItemId, Integer quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartItemId);
            int result = pstmt.executeUpdate();
            logger.info("更新购物车项数量成功: cartItemId={}, quantity={}", cartItemId, quantity);
            return result > 0;
        } catch (SQLException e) {
            logger.error("更新购物车项数量失败: cartItemId={}", cartItemId, e);
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * 删除购物车项
     */
    public boolean deleteItem(Integer cartItemId) {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cartItemId);
            int result = pstmt.executeUpdate();
            logger.info("删除购物车项成功: cartItemId={}", cartItemId);
            return result > 0;
        } catch (SQLException e) {
            logger.error("删除购物车项失败: cartItemId={}", cartItemId, e);
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * 清空用户购物车
     */
    public boolean clearByUserId(Integer userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            int result = pstmt.executeUpdate();
            logger.info("清空购物车成功: userId={}", userId);
            return true;
        } catch (SQLException e) {
            logger.error("清空购物车失败: userId={}", userId, e);
            return false;
        } finally {
            closeResources(conn, pstmt, null);
        }
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
