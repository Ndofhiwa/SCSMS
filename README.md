
<div align="center">

```
███████╗███╗   ███╗ █████╗ ██████╗ ████████╗      ██████╗ █████╗ ███╗   ███╗██████╗ 
██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝     ██╔════╝██╔══██╗████╗ ████║██╔══██╗
███████╗██╔████╔██║███████║██████╔╝   ██║        ██║     ███████║██╔████╔██║██████╔╝
╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║        ██║     ██╔══██║██║╚██╔╝██║██╔═══╝ 
███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║        ╚██████╗██║  ██║██║ ╚═╝ ██║██║     
╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝         ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝     
```

# Smart-Camp — Smart Campus Service Management System

**A full-stack Jakarta EE web application for managing campus service requests, navigating the UMP Mbombela campus, and connecting students, staff, and administrators.**

[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10.0.0-blue?style=for-the-badge&logo=eclipseide)](https://jakarta.ee/)
[![GlassFish](https://img.shields.io/badge/GlassFish-7.0.25-orange?style=for-the-badge)](https://glassfish.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql)](https://mysql.com/)
[![Java](https://img.shields.io/badge/Java-17-red?style=for-the-badge&logo=java)](https://java.com/)
[![License](https://img.shields.io/badge/License-Academic-green?style=for-the-badge)](LICENSE)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [System Architecture](#-system-architecture)
- [Database Design](#-database-design)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Database Setup](#database-setup)
  - [Configuration](#configuration)
  - [Running the App](#running-the-app)
- [User Roles](#-user-roles)
- [Screenshots](#-screenshots)
- [API Endpoints](#-api-endpoints)
- [Security](#-security)
- [Known Limitations](#-known-limitations)
- [Future Improvements](#-future-improvements)
- [Authors](#-authors)

---

## 🎯 Overview

**Smart-Camp** is a web-based campus service management system built for the **University of Mpumalanga (UMP) Mbombela Campus**. It replaces traditional paper-based and email-driven service request processes with a real-time digital platform, while also providing an interactive campus map to help students navigate the campus.

> Built as a final-year BICT group project for the **BICT331 — Programming Techniques** module under the supervision of **Dr. Femi Elegbeleye**.

---

## ✨ Features

### 🎓 Student
- Register and log in securely
- Submit service requests with category, location, priority and description
- Track request history and status updates in real time
- Navigate the **Mbombela campus** using an interactive **Google Maps** integration with accurate building markers
- Search the campus building directory by name or number
- View campus-wide announcements from admin

### 🔧 Staff
- Department-specific dashboard — only sees requests matching their specialization
- Update request status (Pending → In Progress → Completed)
- Receive **email notifications** when assigned to a request
- Submit their own service requests
- View campus announcements

### 🛡️ Admin
- Full overview dashboard with **summary analytics cards**
- Filter requests by status
- **Assign requests** to specific staff members by department
- Update request statuses
- Post **campus-wide announcements**
- Access **Reports & Analytics** with interactive Chart.js visualizations:
  - Requests by Status (Pie chart)
  - Requests by Priority (Doughnut chart)
  - Requests by Category (Bar chart)
- Trigger **email notifications** on status updates and assignments

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Java 17, Jakarta EE 10, Servlets, JSP |
| **Server** | Eclipse GlassFish 7.0.25 |
| **Database** | MySQL 8.0 via JDBC (MySQL Connector/J) |
| **Frontend** | HTML5, CSS3, Bootstrap, JavaScript |
| **Maps** | Google Maps JavaScript API |
| **Charts** | Chart.js |
| **Icons** | Font Awesome 6.5 |
| **Email** | JavaMail API (Jakarta Mail 2.0.1) |
| **Build Tool** | Apache Maven |
| **IDE** | NetBeans |
| **Version Control** | Git & GitHub |

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                             │
│              Web Browser (HTML, CSS, JS, Bootstrap)             │
└──────────────────────────┬──────────────────────────────────────┘
                           │ HTTP Requests
┌──────────────────────────▼──────────────────────────────────────┐
│                         WEB LAYER                               │
│         GlassFish 7 — Jakarta Servlets + JSP Pages              │
│              Role-based routing & session management            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────────┐
│                    BUSINESS LOGIC LAYER                         │
│   EmailService (JavaMail)  │  Google Maps API  │  RBAC Logic    │
│         Request Assignment Logic & Announcements                │
└──────────────────────────┬──────────────────────────────────────┘
                           │ JDBC
┌──────────────────────────▼──────────────────────────────────────┐
│                        DATA LAYER                               │
│              MySQL 8.0 — 3 Tables                               │
│         users │ service_requests │ announcements                │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Database Design

### Tables

**`users`**
```sql
id          INT AUTO_INCREMENT PRIMARY KEY
name        VARCHAR(100)
email       VARCHAR(100) UNIQUE
password    VARCHAR(255)
role        ENUM('STUDENT', 'STAFF', 'ADMIN')
department  VARCHAR(50)
```

**`service_requests`**
```sql
id           INT AUTO_INCREMENT PRIMARY KEY
user_id      INT (FK → users.id)
location     VARCHAR(100)
category     VARCHAR(50)
description  TEXT
priority     ENUM('LOW', 'MEDIUM', 'HIGH')
status       ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED')
assigned_to  INT (FK → users.id)
created_at   TIMESTAMP
```

**`announcements`**
```sql
id          INT AUTO_INCREMENT PRIMARY KEY
title       VARCHAR(100)
message     TEXT
created_by  INT (FK → users.id)
created_at  TIMESTAMP
```

### Relationships
```
users ──(1:N)──► service_requests   [via user_id]
users ──(1:N)──► service_requests   [via assigned_to]
users ──(1:N)──► announcements      [via created_by]
```

---

## 📁 Project Structure

```
SCSMS/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/mycompany/scsms/
│       │       ├── db/
│       │       │   └── DBConnection.java          # Database connection
│       │       ├── model/
│       │       │   ├── User.java                  # User model
│       │       │   ├── ServiceRequest.java        # Request model
│       │       │   └── Announcement.java          # Announcement model
│       │       ├── servlet/
│       │       │   ├── LoginServlet.java          # Handles login
│       │       │   ├── LogoutServlet.java         # Handles logout
│       │       │   ├── RegisterServlet.java       # Handles registration
│       │       │   ├── RequestServlet.java        # Handles request submission
│       │       │   ├── UpdateStatusServlet.java   # Handles status updates
│       │       │   ├── AssignServlet.java         # Handles staff assignment
│       │       │   └── AnnouncementServlet.java   # Handles announcements
│       │       └── util/
│       │           └── EmailService.java          # JavaMail email service
│       └── webapp/
│           ├── login.jsp                          # Login page
│           ├── register.jsp                       # Registration page
│           ├── dashboard.jsp                      # Admin dashboard
│           ├── student.jsp                        # Student dashboard
│           ├── staff.jsp                          # Staff dashboard
│           ├── submit.jsp                         # Request submission form
│           ├── reports.jsp                        # Reports & analytics
│           └── sidebar.jsp                        # Reusable sidebar component
├── pom.xml                                        # Maven dependencies
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Java JDK 17+
- Apache NetBeans IDE
- Eclipse GlassFish 7.0.25
- MySQL 8.0
- MySQL Workbench
- Maven (bundled with NetBeans)

### Database Setup

1. Open **MySQL Workbench** and connect to your local instance
2. Open a new SQL query tab
3. Run the following script:

```sql
CREATE DATABASE IF NOT EXISTS scsms;
USE scsms;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('STUDENT', 'STAFF', 'ADMIN') NOT NULL,
    department VARCHAR(50) NULL
);

CREATE TABLE service_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    location VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH') NOT NULL,
    status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_to INT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id)
);

CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Default admin account
INSERT INTO users (name, email, password, role)
VALUES ('Admin User', 'admin@campus.ac.za', 'admin123', 'ADMIN');
```

### Configuration

1. Open `src/main/java/com/mycompany/scsms/db/DBConnection.java`
2. Update your MySQL credentials:

```java
private static final String URL = "jdbc:mysql://localhost:3306/scsms?useSSL=false&allowPublicKeyRetrieval=true";
private static final String USER = "root";
private static final String PASSWORD = "your_mysql_password";
```

3. Open `src/main/java/com/mycompany/scsms/util/EmailService.java`
4. Update the Gmail credentials:

```java
private static final String FROM_EMAIL = "your_gmail@gmail.com";
private static final String FROM_PASSWORD = "your_app_password"; // Gmail App Password
```

> **Note:** To generate a Gmail App Password, go to Google Account → Security → 2-Step Verification → App Passwords.

### Running the App

1. Open the project in **NetBeans**
2. Right-click the project → **Clean and Build**
3. Right-click the project → **Run**
4. GlassFish will start and deploy automatically
5. Navigate to:

```
http://localhost:8080/SCSMS/login.jsp
```

6. Log in with the default admin account:

```
Email:    admin@campus.ac.za
Password: admin123
```

---

## 👥 User Roles

| Role | Access | Default Redirect |
|---|---|---|
| **STUDENT** | Campus map, submit requests, view own history, announcements | `student.jsp` |
| **STAFF** | Department requests, update status, submit requests, announcements | `staff.jsp` |
| **ADMIN** | All requests, assign staff, reports, announcements, status updates | `dashboard.jsp` |

> Staff members select their department (Maintenance, IT Support, Classroom Equipment, General Inquiry) during registration. They will only see requests matching their department.

---

## 🔌 API Endpoints

| Endpoint | Method | Description | Access |
|---|---|---|---|
| `/login` | POST | Authenticate user | Public |
| `/logout` | GET | Invalidate session | Authenticated |
| `/register` | POST | Register new user | Public |
| `/submitRequest` | POST | Submit service request | Student, Staff |
| `/updateStatus` | POST | Update request status | Admin, Staff |
| `/assignRequest` | POST | Assign request to staff | Admin |
| `/announcement` | POST | Post announcement | Admin |

---

## 🔒 Security

| Feature | Status |
|---|---|
| Session-based authentication | ✅ Implemented |
| Role-based access control (RBAC) | ✅ Implemented |
| SQL injection prevention (PreparedStatements) | ✅ Implemented |
| Server-side role validation | ✅ Implemented |
| Password hashing (BCrypt) | ❌ Not yet implemented |
| HTTPS / SSL | ❌ Not yet implemented |
| CSRF protection | ❌ Not yet implemented |
| XSS input sanitization | ❌ Not yet implemented |

---

## ⚠️ Known Limitations

- Passwords are stored as **plain text** — not suitable for production
- Google Maps API key is hardcoded — should be stored in environment variables
- Gmail credentials are hardcoded — should use environment variables or a config file
- No pagination on the requests table for large datasets
- No mobile-responsive optimization

---

## 🔮 Future Improvements

- [ ] Password hashing with BCrypt
- [ ] Mobile application (Android/iOS)
- [ ] QR code scanner for building identification
- [ ] Push notifications
- [ ] Request comments and attachments
- [ ] Average resolution time analytics
- [ ] HTTPS deployment
- [ ] Environment variable configuration
- [ ] Pagination and search on request tables

---

## 👨‍💻 Authors

> **Smart-camp**
>

---

<div align="center">

**Smart-Camp** — Built with ☕ Java and 🌍 Jakarta EE

*University of Mpumalanga, Mbombela Campus*

</div>
