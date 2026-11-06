<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, blogapi.Blog" %>
<%
    String username = (String) request.getAttribute("username");
    if (username == null) {
        username = (String) request.getSession().getAttribute("username");
        if (username == null) username = "Storyteller";
    }
    List<Blog> blogs = (List<Blog>) request.getAttribute("blogs");
    String role = (String) request.getSession().getAttribute("role"); 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stories & Chronicles | Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,600;0,700;1,400&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #7c3aed;
            --primary-hover: #6d28d9;
            --primary-light: #f5f3ff;
            --lavender-border: rgba(255, 255, 255, 0.45);
            --glass-bg: rgba(255, 255, 255, 0.68);
            --glass-hover: rgba(255, 255, 255, 0.82);
            --text-heading: #2e1065;
            --text-body: #3b2a59;
            --text-muted: #5b4a78;
            --accent-green: #059669;
            --accent-green-hover: #047857;
            --accent-red: #e11d48;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            min-height: 100vh;
            color: var(--text-body);
            background-color: #2b1f3d;
            background-image: 
                linear-gradient(rgba(43, 31, 61, 0.18), rgba(30, 20, 48, 0.35)), 
                url('Dreamy Lavender Reading Nook.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            display: flex;
            flex-direction: column;
        }

        /* Dreamy Frosted Header */
        header {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(18px) saturate(160%);
            -webkit-backdrop-filter: blur(18px) saturate(160%);
            border-bottom: 1px solid var(--lavender-border);
            padding: 14px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            box-shadow: 0 4px 20px rgba(76, 29, 149, 0.08);
        }

        .welcome-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .welcome-wrap .brand-mark {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: linear-gradient(135deg, #8b5cf6, #ec4899);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #ffffff;
            font-size: 19px;
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.35);
        }

        .welcome-text h2 {
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 21px;
            font-weight: 700;
            color: var(--text-heading);
        }

        .welcome-text p {
            font-size: 11.5px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            font-weight: 700;
        }

        .actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 9px 18px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .btn-create {
            background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);
            color: white;
            box-shadow: 0 4px 14px rgba(139, 92, 246, 0.35);
        }

        .btn-create:hover {
            background: linear-gradient(135deg, #7c3aed 0%, #4f46e5 100%);
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(139, 92, 246, 0.45);
        }

        .btn-logout {
            background: rgba(255, 255, 255, 0.7);
            color: var(--text-muted);
            border: 1px solid var(--lavender-border);
            backdrop-filter: blur(8px);
        }

        .btn-logout:hover {
            background: rgba(254, 226, 226, 0.85);
            color: var(--accent-red);
            border-color: rgba(244, 63, 94, 0.3);
        }

        .container {
            max-width: 960px;
            width: 100%;
            margin: 0 auto;
            padding: 40px 24px;
            flex: 1;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 26px;
            flex-wrap: wrap;
            gap: 16px;
        }

        .section-intro h1 {
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 34px;
            font-weight: 700;
            color: var(--text-heading);
            text-shadow: 0 2px 10px rgba(255, 255, 255, 0.6);
            margin-bottom: 4px;
        }

        .section-intro p {
            color: #4a3468;
            font-size: 14.5px;
            font-weight: 600;
            text-shadow: 0 1px 6px rgba(255, 255, 255, 0.5);
        }

        /* Frosted Glass Search Bar */
        .search-box-wrapper {
            position: relative;
            width: 100%;
            max-width: 320px;
        }

        .search-box-wrapper input {
            width: 100%;
            padding: 11px 16px 11px 40px;
            border: 1px solid var(--lavender-border);
            border-radius: 12px;
            font-size: 13.5px;
            background: rgba(255, 255, 255, 0.72);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            color: var(--text-heading);
            outline: none;
            transition: all 0.25s ease;
            box-shadow: 0 4px 14px rgba(76, 29, 149, 0.06);
        }

        .search-box-wrapper input::placeholder {
            color: #7c6899;
        }

        .search-box-wrapper input:focus {
            background: rgba(255, 255, 255, 0.92);
            border-color: #8b5cf6;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.25);
        }

        .search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 16px;
            height: 16px;
            stroke: #7c6899;
            pointer-events: none;
        }

        .blog-grid {
            display: flex;
            flex-direction: column;
            gap: 22px;
        }

        /* Dreamy Lavender Frosted Glass Cards */
        .blog-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid var(--lavender-border);
            border-radius: 20px;
            padding: 28px 32px;
            box-shadow: 
                0 12px 30px rgba(76, 29, 149, 0.10),
                inset 0 1px 1px rgba(255, 255, 255, 0.7);
            transition: transform 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
        }

        .blog-card:hover {
            transform: translateY(-3px);
            background: var(--glass-hover);
            box-shadow: 
                0 18px 40px rgba(76, 29, 149, 0.16),
                inset 0 1px 1px rgba(255, 255, 255, 0.85);
        }

        .blog-meta-top {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 12px;
            font-size: 12.5px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .author-badge {
            background: rgba(139, 92, 246, 0.15);
            color: #6d28d9;
            border: 1px solid rgba(139, 92, 246, 0.25);
            padding: 3px 10px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 12px;
        }

        .blog-card h3 {
            font-family: 'Playfair Display', Georgia, serif;
            font-size: 24px;
            font-weight: 700;
            color: var(--text-heading);
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .blog-card p {
            color: var(--text-body);
            font-size: 15px;
            line-height: 1.75;
            margin-bottom: 20px;
        }

        .card-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            padding-top: 18px;
            border-top: 1px solid rgba(139, 92, 246, 0.15);
        }

        .read-more-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: linear-gradient(135deg, #7c3aed 0%, #6366f1 100%);
            color: #ffffff;
            text-decoration: none;
            padding: 9px 20px;
            border-radius: 10px;
            font-size: 13.5px;
            font-weight: 600;
            box-shadow: 0 4px 14px rgba(124, 58, 237, 0.25);
            transition: all 0.25s ease;
        }

        .read-more-btn:hover {
            background: linear-gradient(135deg, #6d28d9 0%, #4f46e5 100%);
            transform: translateX(2px);
            box-shadow: 0 6px 18px rgba(124, 58, 237, 0.35);
        }

        .delete-btn {
            background: rgba(255, 255, 255, 0.65);
            color: var(--accent-red);
            border: 1px solid rgba(225, 29, 72, 0.25);
            padding: 8px 16px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 12.5px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .delete-btn:hover {
            background: var(--accent-red);
            color: #ffffff;
            border-color: var(--accent-red);
        }

        #noSearchResults {
            display: none;
            text-align: center;
            padding: 50px 20px;
            background: var(--glass-bg);
            border: 1px dashed var(--lavender-border);
            border-radius: 20px;
            color: var(--text-muted);
            backdrop-filter: blur(14px);
        }

        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(14px);
            border: 1px solid #bbf7d0;
            color: #15803d;
            padding: 14px 22px;
            border-radius: 12px;
            box-shadow: 0 10px 25px -5px rgba(76, 29, 149, 0.15);
            font-size: 14px;
            font-weight: 600;
            display: none;
            z-index: 1000;
        }
    </style>
</head>
<body>

    <header>
        <div class="welcome-wrap">
            <div class="brand-mark">B</div>
            <div class="welcome-text">
                <h2>Welcome, <%= username %></h2>
                <p>Role: <%= (role != null ? role : "Reader") %></p>
            </div>
        </div>

        <div class="actions">
            <% if ("admin".equals(role)) { %>
                <a href="/blogapi/createblog.jsp" class="btn btn-create">+ Write Story</a>
            <% } %>
            <form action="/blogapi/logout" method="post" style="display: inline;">
                <button type="submit" class="btn btn-logout">Sign Out</button>
            </form>
        </div>
    </header>

    <div class="container">
        <div class="section-header">
            <div class="section-intro">
                <h1>Recent Stories</h1>
                <p>Explore articles, chronicles, and latest updates.</p>
            </div>

            <!-- Instant Search Input -->
            <div class="search-box-wrapper">
                <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2">
                    <circle cx="11" cy="11" r="7"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-4.35-4.35"/>
                </svg>
                <input type="text" id="storySearch" placeholder="Search stories, titles, or authors..." onkeyup="filterStories()">
            </div>
        </div>

        <div class="blog-grid" id="blogGrid">
            <% if (blogs != null && !blogs.isEmpty()) { %>
                <% boolean canEdit = "admin".equals(role) || "editor".equals(role); %>
                <% for (Blog blog : blogs) { %>
                    <article class="blog-card" data-title="<%= blog.getTitle().toLowerCase() %>" data-author="<%= (blog.getAuthorName() != null ? blog.getAuthorName().toLowerCase() : "") %>" data-content="<%= blog.getContent().toLowerCase() %>">
                        
                        <div class="blog-meta-top">
                            <span class="author-badge"><%= (blog.getAuthorName() != null ? blog.getAuthorName() : "Anonymous") %></span>
                            <span>• Chronicle #<%= blog.getId() %></span>
                        </div>

                        <h3><%= blog.getTitle() %></h3>
                        <p><%= blog.getContent().length() > 160 ? blog.getContent().substring(0, 160) + "..." : blog.getContent() %></p>
                        
                        <div class="card-footer">
                            <a href="/blogapi/details?id=<%= blog.getId() %>" class="read-more-btn">
                                Read Chapter &rarr;
                            </a>
                            
                            <% if (canEdit) { %>
                                <div class="action-buttons">
                                    <% if ("admin".equals(role)) { %>
                                        <form action="/blogapi/blogs" method="post" style="display: inline;" onsubmit="return confirm('Delete this story?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= blog.getId() %>">
                                            <button type="submit" class="delete-btn">Delete</button>
                                        </form>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    </article>
                <% } %>
            <% } else { %>
                <div style="text-align: center; padding: 50px 20px; background: var(--glass-bg); border-radius: 20px; border: 1px dashed var(--lavender-border); backdrop-filter: blur(14px);">
                    <h3 style="color: var(--text-heading);">No entries discovered</h3>
                    <p style="color: var(--text-muted); font-size: 14px; margin-top: 6px;">There are no stories published yet.</p>
                </div>
            <% } %>

            <!-- Feedback when search term finds no matches -->
            <div id="noSearchResults">
                <h3 style="color: var(--text-heading);">No stories found</h3>
                <p style="font-size: 14px; margin-top: 6px;">Try searching for a different keyword or author name.</p>
            </div>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        // Real-time Story Filter Function
        function filterStories() {
            const query = document.getElementById('storySearch').value.toLowerCase().trim();
            const cards = document.querySelectorAll('.blog-card');
            let visibleCount = 0;

            cards.forEach(card => {
                const title = card.getAttribute('data-title') || '';
                const author = card.getAttribute('data-author') || '';
                const content = card.getAttribute('data-content') || '';

                if (title.includes(query) || author.includes(query) || content.includes(query)) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            const noResults = document.getElementById('noSearchResults');
            if (visibleCount === 0 && cards.length > 0) {
                noResults.style.display = 'block';
            } else {
                noResults.style.display = 'none';
            }
        }

        // Toast notifications
        const urlParams = new URLSearchParams(window.location.search);
        const toast = document.getElementById('toast');
        const blogStatus = urlParams.get('blog');

        if (blogStatus === 'deleted') {
            toast.textContent = 'Story deleted successfully.';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        } else if (blogStatus === 'created') {
            toast.textContent = 'New story published on top!';
            toast.style.display = 'block';
            setTimeout(() => toast.style.display = 'none', 3000);
        }
    </script>
</body>
</html>