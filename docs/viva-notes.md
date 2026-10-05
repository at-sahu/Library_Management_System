# Viva Notes

## Architecture

Swing renders the user interface. Services enforce validation, authorization, and library rules. DAOs contain prepared JDBC statements. MySQL stores all permanent data.

## OOP

- **Encapsulation:** model fields are private and exposed through accessors.
- **Abstraction:** `User` is abstract and requires a dashboard name.
- **Inheritance and polymorphism:** `Admin` and `Member` extend `User` and override the abstract method.
- **Composition:** `Transaction` references a book and a member; `Book` references a category.

## Security and rules

The single login form uses `AuthService` to determine a database role. BCrypt protects passwords, prepared statements protect SQL values, and `SessionManager` stores the authenticated user. Admin services independently check authorization. Members may have three active loans; the loan period is 14 days; late fees are ₹5 per day. Issue and return operations use database transactions.
