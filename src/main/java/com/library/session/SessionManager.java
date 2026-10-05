package com.library.session;
import com.library.enums.Role; import com.library.model.User;
public final class SessionManager { private static User currentUser; private SessionManager(){} public static void login(User user){currentUser=user;} public static User getCurrentUser(){return currentUser;} public static boolean isLoggedIn(){return currentUser!=null;} public static boolean hasRole(Role role){return currentUser!=null&&currentUser.getRole()==role;} public static void logout(){currentUser=null;} }
