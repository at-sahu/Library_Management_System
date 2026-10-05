package com.library.ui;

import com.library.enums.Role;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;

/** First screen shown by the application so each role uses its own login flow. */
public class RoleSelectionFrame extends JFrame {
    public RoleSelectionFrame() {
        super("Smart Library System"); UI.style(); setDefaultCloseOperation(EXIT_ON_CLOSE); setSize(620, 390); setResizable(false); setLocationRelativeTo(null);
        JPanel root = new JPanel(new BorderLayout(12, 22)); root.setBackground(UI.BG); root.setBorder(new EmptyBorder(42, 58, 42, 58));
        JLabel heading = new JLabel("SMART LIBRARY SYSTEM", SwingConstants.CENTER); heading.setFont(new Font("Segoe UI", Font.BOLD, 28)); heading.setForeground(UI.NAVY);
        JLabel subheading = new JLabel("Choose how you want to sign in", SwingConstants.CENTER); subheading.setForeground(new Color(71, 85, 105));
        JPanel top = new JPanel(new GridLayout(2, 1, 0, 6)); top.setOpaque(false); top.add(heading); top.add(subheading); root.add(top, BorderLayout.NORTH);
        JPanel options = new JPanel(new GridLayout(1, 2, 20, 0)); options.setOpaque(false); options.add(option("STUDENT LOGIN", "Use your enrollment number and password", Role.MEMBER)); options.add(option("ADMIN LOGIN", "Manage books, students and transactions", Role.ADMIN)); root.add(options, BorderLayout.CENTER); add(root);
    }
    private JButton option(String title, String description, Role role) { JButton button = UI.button("<html><center>" + title + "<br><br><span style='font-weight:normal'>" + description + "</span></center></html>"); button.setFont(new Font("Segoe UI", Font.BOLD, 16)); button.addActionListener(event -> { dispose(); new LoginFrame(role).setVisible(true); }); return button; }
}
