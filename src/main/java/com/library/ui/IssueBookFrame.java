package com.library.ui;

import com.library.model.Book;
import com.library.model.Member;
import com.library.service.BookService;
import com.library.service.LibraryService;
import com.library.service.MemberService;
import com.library.util.DateUtil;

import javax.swing.*;
import java.awt.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Admin screen to issue a book to a student. */
public class IssueBookFrame extends JFrame {

    private final MemberService memberService = new MemberService();
    private final BookService bookService = new BookService();
    private final LibraryService libraryService = new LibraryService();

    private final JTextField studentSearch = new JTextField();
    private final JTextField bookSearch = new JTextField();
    private final JComboBox<Member> members = new JComboBox<>();
    private final JComboBox<Book> books = new JComboBox<>();
    private final JSpinner duration = new JSpinner(new SpinnerNumberModel(DateUtil.LOAN_DAYS, 1, 30, 1));
    private final JLabel status = new JLabel(" ");
    private final JButton issueButton = UI.button("Issue Selected Book");

    private List<Member> allMembers = List.of();

    public IssueBookFrame() {
        super("Issue Book");
        setSize(760, 540);
        setMinimumSize(new Dimension(650, 480));
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        JPanel root = new JPanel(new BorderLayout());
        root.add(UI.header(this, "Issue Book",
                "Search student/book and enter any loan duration from 1 to 30 days"), BorderLayout.NORTH);
        root.add(buildForm(), BorderLayout.CENTER);
        add(root);

        books.setRenderer(new DefaultListCellRenderer() {
            @Override
            public Component getListCellRendererComponent(JList<?> list, Object value, int index,
                                                          boolean selected, boolean focus) {
                super.getListCellRendererComponent(list, value, index, selected, focus);
                if (value instanceof Book b) {
                    setText(b.getBookName() + " (" + b.getIsbn() + ") - " + b.getAvailableQuantity() + " available");
                }
                return this;
            }
        });

        // Pressing Enter in a search box works like clicking "Find".
        studentSearch.addActionListener(e -> filterMembers());
        bookSearch.addActionListener(e -> filterBooks());
        getRootPane().setDefaultButton(issueButton);

        loadData();
    }

    // ---------- UI building ----------

    private JPanel buildForm() {
        JPanel p = new JPanel(new GridBagLayout());
        p.setBackground(Color.WHITE);
        p.setBorder(BorderFactory.createEmptyBorder(24, 32, 24, 32));
        GridBagConstraints c = new GridBagConstraints();
        c.insets = new Insets(8, 8, 8, 8);
        c.fill = GridBagConstraints.HORIZONTAL;

        addRow(p, c, 0, "Search student (enrollment, email, phone or name)", studentSearch,
                searchButton("Find student", this::filterMembers));
        addRow(p, c, 1, "Select student", members, null);
        addRow(p, c, 2, "Search book (name, author, ISBN or ID)", bookSearch,
                searchButton("Find book", this::filterBooks));
        addRow(p, c, 3, "Select available book", books, null);
        addRow(p, c, 4, "Loan duration (days, 1-30)", duration, null);

        status.setForeground(new Color(71, 85, 105));
        c.gridx = 0; c.gridy = 5; c.gridwidth = 3; c.weightx = 1;
        p.add(status, c);

        issueButton.addActionListener(e -> issue());
        c.gridx = 1; c.gridy = 6; c.gridwidth = 2;
        p.add(issueButton, c);
        return p;
    }

    private JButton searchButton(String text, Runnable action) {
        JButton b = UI.button(text);
        b.addActionListener(e -> action.run());
        return b;
    }

    private void addRow(JPanel p, GridBagConstraints c, int row, String label,
                        JComponent field, JButton button) {
        c.gridy = row; c.gridwidth = 1;
        c.gridx = 0; c.weightx = 0;
        p.add(new JLabel(label), c);
        c.gridx = 1; c.weightx = 1;
        p.add(field, c);
        if (button != null) {
            c.gridx = 2; c.weightx = 0;
            p.add(button, c);
        }
    }

    // ---------- Data loading and filtering ----------

    private void loadData() {
        try {
            allMembers = memberService.activeMembers();
            filterMembers();
            filterBooks();
        } catch (Exception e) {
            UI.error(this, e);
        }
    }

    private void filterMembers() {
        members.removeAllItems();
        String q = studentSearch.getText().trim().toLowerCase();
        for (Member m : allMembers) {
            if (q.isEmpty()
                    || String.valueOf(m.getMemberId()).contains(q)
                    || m.getName().toLowerCase().contains(q)
                    || m.getEmail().toLowerCase().contains(q)
                    || m.getPhone().contains(q)) {
                members.addItem(m);
            }
        }
        updateStatus();
    }

    private void filterBooks() {
        books.removeAllItems();
        try {
            String term = bookSearch.getText().trim();
            List<Book> found = new ArrayList<>(bookService.search(term));

            // Also allow searching by numeric book ID.
            if (term.matches("\\d+")) {
                Book byId = bookService.get(Long.parseLong(term));
                if (byId != null && found.stream().noneMatch(b -> b.getBookId() == byId.getBookId())) {
                    found.add(0, byId);
                }
            }
            for (Book b : found) {
                if ("ACTIVE".equals(b.getStatus()) && b.getAvailableQuantity() > 0) {
                    books.addItem(b);
                }
            }
        } catch (Exception e) {
            UI.error(this, e);
        }
        updateStatus();
    }

    private void updateStatus() {
        status.setText(members.getItemCount() + " student(s) and " + books.getItemCount() + " book(s) found");
        issueButton.setEnabled(members.getItemCount() > 0 && books.getItemCount() > 0);
    }

    // ---------- Issue action ----------

    private void issue() {
        try {
            Member m = (Member) members.getSelectedItem();
            Book b = (Book) books.getSelectedItem();
            if (m == null || b == null) {
                throw new IllegalArgumentException("Find and select a student and book.");
            }
            int days = (Integer) duration.getValue();
            LocalDate due = DateUtil.dueDate(LocalDate.now(), days);

            int ok = JOptionPane.showConfirmDialog(this,
                    "Issue \"" + b.getBookName() + "\" to " + m.getName() + "?\nDue date: " + due,
                    "Confirm Issue", JOptionPane.YES_NO_OPTION);
            if (ok != JOptionPane.YES_OPTION) return;

            libraryService.issue(m.getMemberId(), b.getBookId(), days);
            UI.info(this, "Book issued successfully. Due date: " + due);

            studentSearch.setText("");
            bookSearch.setText("");
            loadData();
        } catch (Exception e) {
            UI.error(this, e);
        }
    }
}
