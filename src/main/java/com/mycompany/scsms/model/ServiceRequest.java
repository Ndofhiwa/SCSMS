package com.mycompany.scsms.model;

public class ServiceRequest {
    
    private int id;
    private int userId;
    private String location;
    private String category;
    private String description;
    private String priority;
    private String status;
    private String createdAt;
    private int assignedTo;
    
    public ServiceRequest() {}
    
    public ServiceRequest(int id, int userId, String location, String category,
                          String description, String priority, String status, 
                          String createdAt, int assignedTo) {
        this.id = id;
        this.userId = userId;
        this.location = location;
        this.category = category;
        this.description = description;
        this.priority = priority;
        this.status = status;
        this.createdAt = createdAt;
        this.assignedTo = assignedTo;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public int getAssignedTo() { return assignedTo; }
    public void setAssignedTo(int assignedTo) { this.assignedTo = assignedTo; }
}