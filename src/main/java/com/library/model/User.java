package com.library.model;

import com.library.enums.Role;

public abstract class User {
    private long userId; private String name; private String email; private String passwordHash; private String status; private Role role;
    protected User(long userId, String name, String email, String passwordHash, String status, Role role) { this.userId=userId; this.name=name; this.email=email; this.passwordHash=passwordHash; this.status=status; this.role=role; }
    public long getUserId(){return userId;} public void setUserId(long v){userId=v;} public String getName(){return name;} public void setName(String v){name=v;} public String getEmail(){return email;} public void setEmail(String v){email=v;} public String getPasswordHash(){return passwordHash;} public void setPasswordHash(String v){passwordHash=v;} public String getStatus(){return status;} public void setStatus(String v){status=v;} public Role getRole(){return role;} public void setRole(Role v){role=v;}
    public abstract String getDashboardName();
}
