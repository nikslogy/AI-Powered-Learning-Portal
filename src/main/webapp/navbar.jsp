<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="index.jsp">Learning Portal</a>
        <!-- Hamburger menu icon for smaller screens -->
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <!-- Use Bootstrap's 'mr-auto' class to push the nav item to the left -->
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <span class="navbar-text">Welcome, <%= session.getAttribute("name") %></span>
                </li>
            </ul>
            <!-- Navbar links -->
            <ul class="navbar-nav ml-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-user"></i> My Profile
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                        
                        <a class="dropdown-item" href="performance.jsp"><i class="fas fa-chart-line"></i> My Performance</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item" href="Logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </li>
            </ul>
        </div>
    </nav>
</body>
</html>