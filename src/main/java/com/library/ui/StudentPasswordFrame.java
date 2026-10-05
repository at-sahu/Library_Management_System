package com.library.ui;

import com.library.model.Member;
import com.library.service.MemberService;
import javax.swing.*;
import java.awt.*;
import java.util.List;

/** Lets an administrator find a student, then set a new password for that student. */
public class StudentPasswordFrame extends JFrame {
    private final MemberService service = new MemberService();
    private final JTextField search = new JTextField();
    private final JComboBox<Member> students = new JComboBox<>();
    private final JPasswordField password = new JPasswordField();

    public StudentPasswordFrame() {
        super("Change Student Password");
        setSize(620, 330); setMinimumSize(new Dimension(520, 300)); setLocationRelativeTo(null); setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        JPanel panel = new JPanel(new GridBagLayout()); panel.setBackground(Color.WHITE); panel.setBorder(BorderFactory.createEmptyBorder(28, 28, 28, 28));
        GridBagConstraints c = new GridBagConstraints(); c.insets = new Insets(8, 8, 8, 8); c.fill = GridBagConstraints.HORIZONTAL;
        add(panel, c, 0, "Search (enrollment, name, email or phone)", search);
        JButton find = UI.button("Search"); find.addActionListener(e -> findStudents()); c.gridx = 2; c.gridy = 0; c.weightx = 0; panel.add(find, c);
        add(panel, c, 1, "Select student", students);
        add(panel, c, 2, "New password", password);
        JButton save = UI.button("Change Student Password"); save.addActionListener(e -> resetPassword()); c.gridx = 1; c.gridy = 3; c.gridwidth = 2; panel.add(save, c);
        add(panel); findStudents();
    }

    private void add(JPanel panel, GridBagConstraints c, int row, String label, JComponent field) {
        c.gridwidth = 1; c.gridx = 0; c.gridy = row; c.weightx = 0; panel.add(new JLabel(label), c);
        c.gridx = 1; c.weightx = 1; panel.add(field, c);
    }

    private void findStudents() {
        try {
            List<Member> matches = service.search(search.getText());
            students.removeAllItems();
            for (Member member : matches) students.addItem(member);
            if (matches.isEmpty()) UI.info(this, "No student found for this search.");
        } catch (Exception exception) { UI.error(this, exception); }
    }

    private void resetPassword() {
        try {
            Member selected = (Member) students.getSelectedItem();
            if (selected == null) throw new IllegalArgumentException("Search and select a student first.");
            service.resetPassword(selected.getMemberId(), new String(password.getPassword()));
            password.setText("");
            UI.info(this, "Password changed for " + selected.getName() + " (Enrollment: " + selected.getMemberId() + ").");
        } catch (Exception exception) { UI.error(this, exception); }
    }
}
