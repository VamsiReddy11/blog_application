<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="blogapi.Blog" %>
<%
    String role = (String) request.getSession().getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("unauthorized.html");
        return;
    }

    Blog blogToEdit = (Blog) request.getAttribute("blog");
    String successMessage = (String) request.getAttribute("successMessage");

    // Fetch user details from session
    Object userIdObj = request.getSession().getAttribute("user_id");
    String sessionUsername = (String) request.getSession().getAttribute("username");
    String sessionEmail = (String) request.getSession().getAttribute("email");

    String authorId = (userIdObj != null) ? String.valueOf(userIdObj) : "1";
    String defaultAuthorName = (sessionUsername != null) ? sessionUsername : "";
    String defaultAuthorEmail = (sessionEmail != null) ? sessionEmail : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= blogToEdit == null ? "Create Blog" : "Edit Blog" %> | Story Chronicles</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,600;1,400&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #6366f1 0%, #a855f7 50%, #ec4899 100%);
            --btn-hover: linear-gradient(135deg, #4f46e5 0%, #9333ea 50%, #db2777 100%);
            --card-bg: rgba(255, 255, 255, 0.94);
            --card-border: rgba(255, 255, 255, 0.8);
            --text-main: #0f172a;
            --text-muted: #64748b;
            --input-border: #cbd5e1;
            --input-focus: #8b5cf6;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            background-color: #f4f4f9;
            background-image: 
                linear-gradient(rgba(15, 23, 42, 0.45), rgba(15, 23, 42, 0.55)), 
                url('pexels-pixabay-301717.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .container {
            width: 100%;
            max-width: 680px;
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 20px;
            padding: 44px 40px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35), 0 0 0 1px var(--card-border);
            animation: fadeIn 0.4s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header-badge {
            display: inline-block;
            background: rgba(99, 102, 241, 0.12);
            color: #6366f1;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            padding: 4px 14px;
            border-radius: 20px;
            margin-bottom: 10px;
        }

        .form-header h1 {
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 32px;
            font-weight: 700;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 6px;
        }

        .form-header p {
            font-size: 13.5px;
            color: var(--text-muted);
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        /* Two-Column Layout for Author Credentials */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #334155;
            margin-bottom: 6px;
        }

        input[type="text"], 
        input[type="email"], 
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1.5px solid var(--input-border);
            border-radius: 10px;
            font-size: 14.5px;
            color: var(--text-main);
            background: rgba(255, 255, 255, 0.95);
            outline: none;
            transition: all 0.25s ease;
        }

        input[type="text"]:focus, 
        input[type="email"]:focus, 
        textarea:focus {
            border-color: var(--input-focus);
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.2);
        }

        textarea {
            resize: vertical;
            min-height: 180px;
            line-height: 1.6;
        }

        /* Gradient Button */
        button[type="submit"] {
            margin-top: 10px;
            padding: 14px;
            background: var(--primary-gradient);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 6px 18px rgba(168, 85, 247, 0.35);
            transition: all 0.25s ease;
        }

        button[type="submit"]:hover {
            background: var(--btn-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(168, 85, 247, 0.45);
        }

        button[type="submit"]:active {
            transform: translateY(0);
        }

        .back-link {
            display: block;
            margin-top: 16px;
            text-align: center;
            text-decoration: none;
            color: var(--text-muted);
            font-size: 13.5px;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .back-link:hover {
            color: #6366f1;
        }

        /* Toast Notifications */
        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: #ffffff;
            border: 1px solid #bbf7d0;
            color: #15803d;
            padding: 14px 22px;
            border-radius: 10px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.15);
            font-size: 14px;
            font-weight: 600;
            display: none;
            z-index: 1000;
            animation: slideIn 0.3s ease forwards;
        }

        @keyframes slideIn {
            from { transform: translateY(16px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @media (max-width: 600px) {
            .container {
                padding: 30px 22px;
            }
            .form-row {
                grid-template-columns: 1fr;
                gap: 14px;
            }
            .form-header h1 {
                font-size: 26px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="form-header">
            <span class="header-badge">Creator Studio</span>
            <h1><%= blogToEdit == null ? "Publish Story" : "Edit Story" %></h1>
            <p>Compose your thoughts and share them with the reader base.</p>
        </div>

        <form action="/blogapi/blogs" method="POST">
            <% if (blogToEdit != null) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= blogToEdit.getId() %>">
            <% } else { %>
                <input type="hidden" name="action" value="create">
                <input type="hidden" name="author_id" value="<%= authorId %>">
            <% } %>

            <!-- Author Name and Email Fields Row -->
            <div class="form-row">
                <div class="form-group">
                    <label for="author_name">Author Name</label>
                    <input 
                        type="text" 
                        id="author_name" 
                        name="author_name" 
                        placeholder="Your full name" 
                        value="<%= blogToEdit != null ? blogToEdit.getAuthorName() : defaultAuthorName %>" 
                        required
                    >
                </div>

                <div class="form-group">
                    <label for="author_email">Author Email</label>
                    <input 
                        type="email" 
                        id="author_email" 
                        name="author_email" 
                        placeholder="you@domain.com" 
                        value="<%= defaultAuthorEmail %>" 
                        required
                    >
                </div>
            </div>

            <!-- Blog Title -->
            <div class="form-group">
                <label for="title">Story Title</label>
                <input 
                    type="text" 
                    id="title" 
                    name="title" 
                    placeholder="Give your story an intriguing title..." 
                    value="<%= blogToEdit != null ? blogToEdit.getTitle() : "" %>" 
                    required
                >
            </div>

            <!-- Blog Content -->
            <div class="form-group">
                <label for="content">Story Content</label>
                <textarea 
                    id="content" 
                    name="content" 
                    placeholder="Write your chronicle here..." 
                    required
                ><%= blogToEdit != null ? blogToEdit.getContent() : "" %></textarea>
            </div>

            <button type="submit">
                <%= blogToEdit == null ? "✨ Publish Chronicle" : "💾 Update Story" %>
            </button>
        </form>

      <a href="/blogapi/blogs" class="back-link">&larr; Return to Library Dashboard</a>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        const urlParams = new URLSearchParams(window.location.search);
        const toast = document.getElementById('toast');
        const blogStatus = urlParams.get('blog');

        if (blogStatus === 'updated') {
            toast.textContent = 'Story updated successfully!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        } else if (blogStatus === 'created') {
            toast.textContent = 'Story published successfully!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        }
    </script>
    
</body>
</html>