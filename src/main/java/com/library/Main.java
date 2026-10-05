package com.library; import com.library.ui.RoleSelectionFrame; import javax.swing.SwingUtilities;
public class Main { public static void main(String[] args){SwingUtilities.invokeLater(()->new RoleSelectionFrame().setVisible(true));} }
