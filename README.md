# Smart Library Management System

A desktop library management system for a B.Tech semester project, built with Java 17, Swing, JDBC, MySQL 8, Maven, and BCrypt. The application follows MVC-style UI separation with DAO and service layers.

## Included features

- Role-select login: administrators use their ID/password and students use enrollment number/password
- Admin and member dashboards with live database statistics
- Book CRUD, search, availability, and safe deactivation
- Member registration, editing, search, and safe deactivation
- Issue and return workflows with a 3-book limit, 14-day loans, automatic overdue detection, and ₹5/day fines
- Transaction search, administrator reports, and member-only borrowing history
- MVC-style Swing UI with DAO, service, model, security, session, validation, and exception layers

## Prerequisites

- JDK 17+
- Maven 3.9+
- MySQL 8+

## Database setup

1. Run `database/library.sql` in MySQL Workbench or using the MySQL CLI.
2. Copy `src/main/resources/config.properties` to `src/main/resources/config.local.properties`.
3. Replace `CHANGE_ME` in the local file with your MySQL password. The local file is ignored by Git.

The SQL script creates `library_db`, all required tables, indexes, categories, two administrators, sample students, books, and transactions.

## Demo credentials

| Role | ID / enrollment number | Password |
| --- | --- | --- |
| Admin | anshu@admin | anshu@13 |
| Admin | krrish@admin | krrish@11 |
| Student | Existing enrollment number | Existing student password |

Passwords are stored only as BCrypt hashes in the database. They are documented here solely for the local academic demonstration data.

## Build

```powershell
mvn clean package
java -jar target/smart-library-management-system-1.0.0.jar
```

The Maven Shade plugin creates an executable JAR containing the required JDBC and BCrypt libraries.

## Project structure

```text
database/                         MySQL setup script and sample data
docs/                             Test cases and viva preparation notes
src/main/java/com/library/        Application code by architecture layer
src/main/resources/               Safe configuration template
```
