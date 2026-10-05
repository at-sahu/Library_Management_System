package com.library.model;
import com.library.enums.Role;
public class Admin extends User { private String employeeId; public Admin(long id,String n,String e,String p,String s,String employeeId){super(id,n,e,p,s,Role.ADMIN);this.employeeId=employeeId;} public String getEmployeeId(){return employeeId;} public void setEmployeeId(String v){employeeId=v;} @Override public String getDashboardName(){return "Admin Dashboard";} }
