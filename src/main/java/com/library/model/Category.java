package com.library.model;
public class Category { private long categoryId; private String categoryName; public Category(long id,String name){categoryId=id;categoryName=name;} public long getCategoryId(){return categoryId;} public String getCategoryName(){return categoryName;} @Override public String toString(){return categoryName;} }
