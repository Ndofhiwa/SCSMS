<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>SCSMS - Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .register-box {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 350px;
        }
        h2 { text-align: center; margin-bottom: 24px; color: #333; }
        label { font-weight: bold; display: block; margin-bottom: 4px; }
        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover { background-color: #0056b3; }
        .error { color: red; text-align: center; margin-bottom: 12px; }
        .login-link { text-align: center; margin-top: 12px; }
        .login-link a { color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
    <div class="register-box">
        <h2>Create Account</h2>
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        <form action="register" method="post">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="Enter your full name" required />

            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required />

            <label>Password</label>
            <input type="password" name="password" placeholder="Create a password" required />

            <button type="submit">Register</button>
            
            
            
            <label>Register As</label>
            <select name="role" id="roleSelect" onchange="toggleDepartment()">
                <option value="STUDENT">Student</option>
                <option value="STAFF">Staff</option>
            </select>

            <div id="departmentDiv" style="display:none;">
                <label>Department</label>
                <select name="department">
                    <option value="">-- Select Department --</option>
                    <option value="Maintenance">Maintenance</option>
                    <option value="IT Support">IT Support</option>
                    <option value="Classroom Equipment">Classroom Equipment</option>
                    <option value="General Inquiry">General Inquiry</option>
                </select>
            </div>
            
            
        </form>
        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>
        
<script>
    function toggleDepartment() {
        const role = document.getElementById('roleSelect').value;
        const dept = document.getElementById('departmentDiv');
        dept.style.display = role === 'STAFF' ? 'block' : 'none';
    }
</script>


</body>
</html>