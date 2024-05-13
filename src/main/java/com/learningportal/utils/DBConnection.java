package com.learningportal.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Example for PostgreSQL
    private static final String URL = "jdbc:postgresql://localhost/lp";
    private static final String USER = "postgres";
    private static final String PASSWORD = "nikit";
    private static final String DRIVER_CLASS = "org.postgresql.Driver";

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the JDBC driver class
            Class.forName(DRIVER_CLASS);
            // Establish the connection to the database
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("PostgreSQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
        }
        return connection;
    }
}
