<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="blogapi.Blog" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Blog</title>
    <style type="text/css">
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            /* A deep, modern dark slate background to contrast the white form card */
            background-color: #0f172a !important; 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            box-sizing: border-box;
        }

        .container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            /* Enhanced modern shadow to pop against the dark background */
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 650px;
            box-sizing: border-box;
        }

        h1 {
            margin-top: 0;
            margin-bottom: 28px;
            font-size: 26px;
            font-weight: 700;
            color: #1e293b;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 16px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 14px;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            font-size: 15px;
            color: #334155;
            box-sizing: border-box;
            transition: all 0.2s ease-in-out;
            font-family: inherit;
            line-height: 1.6;
        }

        input[type="text"]:focus,
        textarea:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
            background-color: #f8fafc;
        }

        textarea {
            min-height: 220px;
            resize: vertical;
        }

        .btn-submit {
            background-color: #6366f1;
            color: #ffffff;
            border: none;
            padding: 14px 20px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            box-shadow: 0 4px 6px -1px rgba(99, 102, 241, 0.4);
            transition: all 0.2s ease-in-out;
        }

        .btn-submit:hover {
            background-color: #4f46e5;
            box-shadow: 0 6px 12px -1px rgba(79, 70, 229, 0.5);
            transform: translateY(-1px);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }

        .error-message {
            background-color: #fee2e2;
            color: #ef4444;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #fca5a5;
            text-align: center;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <div class="container">
        <% 
            Blog blog = (Blog) request.getAttribute("blog"); 
            if (blog != null) { 
        %>
            <h1>Edit Blog</h1>
            
            <form action="updateblog" method="post">
                <input type="hidden" name="id" value="<%= blog.getId() %>">
                
                <div class="form-group">
                    <label for="title">Title</label>
                    <input type="text" name="title" id="title" value="<%= blog.getTitle() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="content">Content</label>
                    <textarea name="content" id="content" required><%= blog.getContent() %></textarea>
                </div>
                
                <button type="submit" class="btn-submit">Update Blog</button>
            </form>
        <% 
            } else { 
        %>
            <div class="error-message">
                <strong>Error:</strong> Blog post data could not be retrieved from the server.
            </div>
        <% 
            } 
        %>
    </div>

</body>
</html>