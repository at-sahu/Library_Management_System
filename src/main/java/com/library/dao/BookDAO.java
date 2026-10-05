package com.library.dao;

import com.library.model.Book;
import com.library.util.DBConnection;
import java.sql.*;
import java.util.*;

public class BookDAO {
    private static final String BASE = "SELECT b.*,c.category_name FROM books b JOIN categories c ON c.category_id=b.category_id ";

    public List<Book> findAll(String term) {
        String sql = BASE
                + "WHERE b.book_name LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? OR c.category_name LIKE ? ORDER BY b.book_name";
        List<Book> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            for (int i = 1; i <= 4; i++)
                p.setString(i, "%" + term + "%");
            try (ResultSet r = p.executeQuery()) {
                while (r.next())
                    list.add(map(r));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Unable to load books.", e);
        }
        return list;
    }

    public Book findById(long id) {
        try (Connection c = DBConnection.getConnection();
                PreparedStatement p = c.prepareStatement(BASE + "WHERE b.book_id=?")) {
            p.setLong(1, id);
            try (ResultSet r = p.executeQuery()) {
                return r.next() ? map(r) : null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Unable to load book.", e);
        }
    }

    public void insert(Book b) {
        String sql = "INSERT INTO books(isbn,book_name,author,category_id,publisher,publication_year,quantity,available_quantity,shelf_number) VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            set(p, b, false);
            p.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to add book. ISBN may already exist.", e);
        }
    }

    public void update(Book b) {
        String sql = "UPDATE books SET isbn=?,book_name=?,author=?,category_id=?,publisher=?,publication_year=?,quantity=?,available_quantity=?,shelf_number=? WHERE book_id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            set(p, b, true);
            if (p.executeUpdate() == 0)
                throw new RuntimeException("Book not found.");
        } catch (SQLException e) {
            throw new RuntimeException("Unable to update book. ISBN may already exist.", e);
        }
    }

    public void deactivate(long id) {
        try (Connection c = DBConnection.getConnection();
                PreparedStatement p = c.prepareStatement("UPDATE books SET status='INACTIVE' WHERE book_id=?")) {
            p.setLong(1, id);
            p.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Unable to deactivate book.", e);
        }
    }

    public void changeAvailability(Connection c, long id, int delta) throws SQLException {
        try (PreparedStatement p = c.prepareStatement(
                "UPDATE books SET available_quantity=available_quantity+? WHERE book_id=? AND available_quantity+? BETWEEN 0 AND quantity")) {
            p.setInt(1, delta);
            p.setLong(2, id);
            p.setInt(3, delta);
            if (p.executeUpdate() == 0)
                throw new SQLException("Book availability could not be updated.");
        }
    }

    private void set(PreparedStatement p, Book b, boolean id) throws SQLException {
        p.setString(1, b.getIsbn());
        p.setString(2, b.getBookName());
        p.setString(3, b.getAuthor());
        p.setLong(4, b.getCategoryId());
        p.setString(5, b.getPublisher());
        p.setInt(6, b.getPublicationYear());
        p.setInt(7, b.getQuantity());
        p.setInt(8, b.getAvailableQuantity());
        p.setString(9, b.getShelfNumber());
        if (id)
            p.setLong(10, b.getBookId());
    }

    private Book map(ResultSet r) throws SQLException {
        Book b = new Book();
        b.setBookId(r.getLong("book_id"));
        b.setIsbn(r.getString("isbn"));
        b.setBookName(r.getString("book_name"));
        b.setAuthor(r.getString("author"));
        b.setCategoryId(r.getLong("category_id"));
        b.setCategoryName(r.getString("category_name"));
        b.setPublisher(r.getString("publisher"));
        b.setPublicationYear(r.getInt("publication_year"));
        b.setQuantity(r.getInt("quantity"));
        b.setAvailableQuantity(r.getInt("available_quantity"));
        b.setShelfNumber(r.getString("shelf_number"));
        b.setStatus(r.getString("status"));
        return b;
    }
}
