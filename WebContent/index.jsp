<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>107 Frogs Main Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: rgb(133, 176, 155);
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            text-align: center;
        }
        .navbar {
            background-color: #343a40;
        }
        .navbar a {
            color: white;
            padding: 14px 16px;
            text-decoration: none;
            display: inline-block;
        }
        .navbar a:hover {
            background-color: #ddd;
            color: black;
        }
        .ml-auto {
            margin-left: auto !important;
        }
        .navbar-text {
            color: white;
        }
		.card {
            background-color: #667a5f;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">107 Frogs</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="listorder.jsp">List All Orders</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="customer.jsp">Customer Info</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="admin.jsp">Administrators</a>
                </li>
				<li class="nav-item">
                    <a class="nav-link" href="showcart.jsp">Cart</a>
                </li>
            </ul>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="login.jsp">Login</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp">Log out</a>
                </li>
            </ul>
            <% String userName = (String) session.getAttribute("authenticatedUser");
               if (userName != null) {
                   out.println("<span class='navbar-text'>Signed in as: " + userName + "</span>");
               }
            %>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="card">
        <img src="img/product_frog.jpg" class="card-img-top" alt="Product Image">
        <div class="card-body">
            <a href="listprod.jsp" class="btn btn-primary">Start Exploring</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>