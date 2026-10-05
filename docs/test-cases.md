# Test Cases

| ID | Description | Input | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|
| TC01 | Valid Admin Login | admin@library.com / Admin@123 | Admin dashboard opens | Requires local run | Pending |
| TC02 | Valid Member Login | aarav@student.com / Member@123 | Member dashboard opens | Requires local run | Pending |
| TC03 | Invalid Login | Wrong password | Friendly authentication error | Requires local run | Pending |
| TC04 | Inactive Login | Inactive account | Account-inactive message | Requires local run | Pending |
| TC05 | Add Book | Valid unique ISBN | Book saved with available copies | Requires local run | Pending |
| TC06 | Update Book | Changed book values | Record updates | Requires local run | Pending |
| TC07 | Duplicate ISBN | Existing ISBN | Validation/database error | Requires local run | Pending |
| TC08 | Add Member | Valid unique email | Member saved | Requires local run | Pending |
| TC09 | Duplicate Email | Existing email | Validation/database error | Requires local run | Pending |
| TC10 | Issue Available Book | Active member + book | Transaction and reduced copy count | Requires local run | Pending |
| TC11 | Issue Unavailable Book | Zero-copy book | Availability error | Requires local run | Pending |
| TC12 | Invalid Member | Unknown member ID | Member-not-found error | Requires local run | Pending |
| TC13 | Borrowing Limit | Fourth active loan | Limit error | Requires local run | Pending |
| TC14 | Duplicate Active Issue | Same member and book | Duplicate-issue error | Requires local run | Pending |
| TC15 | Return Book | Active transaction | Copy restored and return saved | Requires local run | Pending |
| TC16 | Overdue Return | Return after due date | Fine is calculated | Requires local run | Pending |
| TC17 | Fine Calculation | 3 late days | Fine = ₹15 | Requires local run | Pending |
| TC18 | Book Search | Title, author, ISBN, category | Matching records shown | Requires local run | Pending |
| TC19 | Member Access Restriction | Member invokes admin service | Authorization exception | Requires local run | Pending |
| TC20 | Admin Access Restriction | Member reads another history | Authorization exception | Requires local run | Pending |
