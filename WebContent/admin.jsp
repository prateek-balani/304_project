<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Administrator Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Include Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%@ include file="header.jsp" %>

    <%
        // TODO: Include files auth.jsp and jdbc.jsp
    %>

    <%@ include file="auth.jsp" %>
    <%@ include file="jdbc.jsp" %>

    <div class="container mt-4">
        <a href="customer.jsp" class="btn btn-primary">Customer Info</a>
        <a href="listorder.jsp" class="btn btn-primary">List Orders</a>
        <br></br><br>
        <h2>Sales Report by Day:</h2>

        <canvas id="salesChart" width="400" height="200"></canvas>

        <%
            // TODO: Write SQL query that prints out total order amount by day
            String sql = "";
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try (Connection con = DriverManager.getConnection(url, uid, pw);
                    PreparedStatement pstmt = con.prepareStatement("SELECT CONVERT(VARCHAR, orderDate, 23) AS orderDay, SUM(totalAmount) AS totalAmount " +
                                                                    "FROM ordersummary " +
                                                                    "GROUP BY CONVERT(VARCHAR, orderDate, 23)")) {

                ResultSet rst = pstmt.executeQuery();
                List<String> orderDates = new ArrayList<>();
                List<Double> totalAmounts = new ArrayList<>();

                while (rst.next()) {
                    orderDates.add(rst.getString("orderDay"));
                    totalAmounts.add(rst.getDouble("totalAmount"));
                }
        %>

        <script>
            var ctx = document.getElementById('salesChart').getContext('2d');
            
            var formattedDates = [<% 
                for (String date : orderDates) { 
                    out.print("'" + date + "',"); 
                } 
            %>];
            
            var salesChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: formattedDates,
                    datasets: [{
                        label: 'Total Order Amount',
                        data: <%= totalAmounts %>,
                        backgroundColor: 'rgba(255, 105, 180, 0.5)', 
                        borderColor: 'rgba(255, 105, 180, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    },
                    plugins: {
                        title: {
                            display: true,
                            color: 'white' 
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                color: 'white' 
                            }
                        },
                        y: {
                            ticks: {
                                color: 'white'
                            }
                        }
                    }
                }
            });
        </script>

        <%
            } catch (SQLException e) {
                out.println("SQLException: " + e);
            }
        %>
    <br></br>
    <a href="addprod.jsp" class="btn btn-success">Add New Product</a>
    </div>
</body>
</html>


