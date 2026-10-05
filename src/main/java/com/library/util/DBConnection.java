package com.library.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Creates JDBC connections from configuration files in the application classpath.
 * Local credentials belong in config.local.properties, which overrides config.properties.
 */
public final class DBConnection {
    private static final String DEFAULT_CONFIG = "config.properties";
    private static final String LOCAL_CONFIG = "config.local.properties";
    private static final Properties PROPERTIES = loadProperties();

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        String url = requiredProperty("db.url");
        String username = requiredProperty("db.username");
        String password = requiredProperty("db.password");

        if ("CHANGE_ME".equals(password)) {
            throw new SQLException("Database password is not configured. Create config.local.properties from config.properties.");
        }
        return DriverManager.getConnection(url, username, password);
    }

    private static Properties loadProperties() {
        Properties properties = new Properties();
        loadInto(properties, DEFAULT_CONFIG, true);
        loadInto(properties, LOCAL_CONFIG, false);
        return properties;
    }

    private static void loadInto(Properties properties, String resourceName, boolean required) {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream(resourceName)) {
            if (input == null) {
                if (required) {
                    throw new IllegalStateException("Missing required resource: " + resourceName);
                }
                return;
            }
            properties.load(input);
        } catch (IOException exception) {
            throw new IllegalStateException("Unable to read " + resourceName, exception);
        }
    }

    private static String requiredProperty(String key) {
        String value = PROPERTIES.getProperty(key);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException("Missing database configuration property: " + key);
        }
        return value.trim();
    }
}
