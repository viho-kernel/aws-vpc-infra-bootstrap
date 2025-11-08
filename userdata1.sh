#!/bin/bash
# Update system packages
apt update -y
apt upgrade -y

# Install Apache HTTP Server
apt install -y apache2

# Enable and start Apache service
systemctl enable apache2
systemctl start apache2

# Create a custom HTML page using EOF
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Welcome to Apache on Ubuntu EC2</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #e0f7fa;
      color: #333;
      text-align: center;
      padding-top: 50px;
    }
    h1 {
      color: #00796b;
    }
    p {
      font-size: 18px;
    }
    footer {
      margin-top: 40px;
      font-size: 14px;
      color: #777;
    }
  </style>
</head>
<body>
  <h1>Hello from your Ubuntu EC2 instance2</h1>
  <p>This page is served by Apache2 installed via User Data script.</p>
  <p>Customize this page to deploy your own web app.</p>
  <footer>
    &copy; 2025 Ubuntu Apache Demo
  </footer>
</body>
</html>