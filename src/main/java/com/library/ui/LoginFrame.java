package com.library.ui;

import com.library.enums.Role;
import com.library.model.*;
import com.library.service.AuthService;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

public class LoginFrame extends JFrame {
    private final Role role;
    private final JTextField identity = new JTextField();
    private final JPasswordField password = new JPasswordField();
    public LoginFrame(Role role) {
        super("Smart Library System - " + (role == Role.ADMIN ? "Admin" : "Student") + " Login"); this.role = role; UI.style(); setDefaultCloseOperation(EXIT_ON_CLOSE); setSize(520, 470); setResizable(false); setLocationRelativeTo(null);
        JPanel panel = new JPanel(new GridBagLayout()); panel.setBorder(new EmptyBorder(38, 62, 32, 62)); panel.setBackground(UI.BG); GridBagConstraints c = new GridBagConstraints(); c.fill = GridBagConstraints.HORIZONTAL; c.weightx = 1; c.insets = new Insets(8, 0, 8, 0);
        JLabel title = new JLabel(role == Role.ADMIN ? "ADMIN LOGIN" : "STUDENT LOGIN", SwingConstants.CENTER); title.setForeground(UI.NAVY); title.setFont(new Font("Segoe UI", Font.BOLD, 26)); c.gridy = 0; panel.add(title, c);
        JLabel subtitle = new JLabel(role == Role.ADMIN ? "Manage the library" : "View your library details and borrowing history", SwingConstants.CENTER); subtitle.setForeground(new Color(71, 85, 105)); c.gridy = 1; panel.add(subtitle, c);
        c.gridy = 2; panel.add(new JLabel(role == Role.ADMIN ? "Admin ID / Email" : "Enrollment Number"), c); identity.setPreferredSize(new Dimension(1, 40)); c.gridy = 3; panel.add(identity, c);
        c.gridy = 4; panel.add(new JLabel("Password"), c); password.setPreferredSize(new Dimension(1, 40)); c.gridy = 5; panel.add(password, c);
        JButton login = UI.button("LOGIN"); login.setPreferredSize(new Dimension(1, 46)); login.addActionListener(e -> login()); c.gridy = 6; c.insets = new Insets(18, 0, 6, 0); panel.add(login, c);
        JButton changeRole = new JButton("← Choose another login type"); changeRole.setBorderPainted(false); changeRole.setContentAreaFilled(false); changeRole.setForeground(UI.NAVY); changeRole.addActionListener(e -> { dispose(); new RoleSelectionFrame().setVisible(true); }); c.gridy = 7; c.insets = new Insets(3, 0, 0, 0); panel.add(changeRole, c);
        getRootPane().setDefaultButton(login); add(panel);
    }
    private void login() { try { AuthService auth = new AuthService(); String enteredPassword = new String(password.getPassword()); User user = role == Role.ADMIN ? auth.loginAdmin(identity.getText(), enteredPassword) : auth.loginStudent(identity.getText(), enteredPassword); dispose(); if (user instanceof Admin) new AdminDashboard().setVisible(true); else new MemberDashboard((Member) user).setVisible(true); } catch (Exception exception) { UI.error(this, exception); } }
}
