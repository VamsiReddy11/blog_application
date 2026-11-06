<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="blogapi.Blog" %>
<%
    Blog blog = (Blog) request.getAttribute("blog");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blog Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
        }

        header {
            background-color: #007BFF;
            color: white;
            padding: 20px;
            text-align: center;
        }

        header h1 {
            margin: 0;
            font-size: 2.5rem;
        }

        header p {
            margin: 5px 0 0;
            font-size: 1rem;
            font-style: italic;
        }

        .content {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .content p {
            font-size: 1.2rem;
            line-height: 1.6;
            color: #333;
        }

        .back-link {
            display: block;
            margin: 20px auto;
            text-align: center;
            text-decoration: none;
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 1rem;
            max-width: 200px;
        }

        .back-link:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <header>
        <h1><%= blog.getTitle() %></h1>
        <p>By <%= blog.getAuthorName() %></p>
    </header>
    <div class="content">
        <p><%= blog.getContent() %></p>
    </div>
    <a href="/blogapi" class="back-link">Back to Home</a>
</body>
</html>
