package com.library.security;

import org.mindrot.jbcrypt.BCrypt;

/** Password hashing helper. Supports legacy $2b$ database hashes with jBCrypt's $2a$ parser. */
public final class PasswordUtil {
    private PasswordUtil() { }

    public static String hash(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean matches(String password, String hash) {
        if (password == null || hash == null || hash.isBlank()) return false;
        // jBCrypt 0.4 accepts $2a$; $2a$ and $2b$ use the same bcrypt calculation here.
        String compatibleHash = hash.startsWith("$2b$") ? "$2a$" + hash.substring(4) : hash;
        try {
            return BCrypt.checkpw(password, compatibleHash);
        } catch (IllegalArgumentException exception) {
            return false;
        }
    }
}
