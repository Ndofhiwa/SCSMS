<%@ page import="com.mycompany.scsms.model.Announcement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.scsms.model.User" %>
<%@ page import="com.mycompany.scsms.model.ServiceRequest" %>
<%@ page import="com.mycompany.scsms.db.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>SCSMS - Student Dashboard</title>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBLuOTIfwtpB_mgBrz4JYNBj8XYMiporic&callback=initMap" async defer></script>
<style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background-color: #f2f2f2; }
        
        .navbar {
            background-color: #007bff;
            color: white;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            background-color: #0056b3;
            padding: 8px 16px;
            border-radius: 4px;
            margin-left: 8px;
        }
        .navbar a:hover { background-color: #003d82; }

        .container { padding: 24px; max-width: 1200px; margin: 0 auto; }

        h2 { color: #333; margin-bottom: 16px; }
        h3 { color: #555; margin-bottom: 12px; }

        .section {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 24px;
            margin-bottom: 24px;
        }

        .category-title {
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            margin-bottom: 12px;
            font-weight: bold;
        }

        .building-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 12px;
            margin-bottom: 20px;
        }

        .building-card {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
            background-color: #f9f9f9;
        }
        .building-card .number {
            font-size: 20px;
            font-weight: bold;
            color: #007bff;
        }
        .building-card .name {
            font-size: 14px;
            color: #333;
            margin-top: 4px;
        }

        table { width: 100%; border-collapse: collapse; }
        th { background-color: #007bff; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:last-child td { border-bottom: none; }
        tr:hover { background-color: #f9f9f9; }

        .badge { padding: 4px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .PENDING { background-color: #fff3cd; color: #856404; }
        .IN_PROGRESS { background-color: #cce5ff; color: #004085; }
        .COMPLETED { background-color: #d4edda; color: #155724; }
        .HIGH { color: red; font-weight: bold; }
        .MEDIUM { color: orange; font-weight: bold; }
        .LOW { color: green; font-weight: bold; }

        .empty { text-align: center; padding: 24px; color: #999; }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<ServiceRequest> requests = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM service_requests WHERE user_id = ? ORDER BY created_at DESC"
            );
            stmt.setInt(1, user.getId());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                requests.add(new ServiceRequest(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getString("location"),
                    rs.getString("category"),
                    rs.getString("description"),
                    rs.getString("priority"),
                    rs.getString("status"),
                    rs.getString("created_at"),
                    rs.getInt("assigned_to")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

<%@ include file="sidebar.jsp" %>

<div id="mainContent" class="main-content">
<div class="container">

        
        
    
     <!-- CAMPUS DIRECTORY -->
        <div class="section">
            <h2>📍 Mbombela Campus Directory</h2>
            
            
            
            <!-- Google Maps -->

<div id="campusMap" style="height:500px; width:100%; border-radius:8px; margin-bottom:20px;"></div>
<script>
    function initMap() {
        const campus = { lat: -25.4358, lng: 30.9824 };
        const map = new google.maps.Map(document.getElementById('campusMap'), {
            zoom: 17,
            center: campus,
            mapTypeId: 'satellite'
        });

        const buildings = [
            { number: "2",   name: "Library and Lecture Venue",                                                        lat: -25.435532280745516,   lng: 30.982779599534847 },
            { number: "7",     name: "Multi-Purpose Teaching Block",                                                   lat: -25.43630878961925,    lng: 30.984693754809882 },
            { number: "8",     name: "Hospitality & Tourism / Wellness and Conference Centre",                         lat: -25.43618649645753,    lng: 30.98565369329116  },
            { number: "9",     name: "Wellness and Conference Centre",                                                 lat: -25.436646594335883,   lng: 30.98587120370147  },
            { number: "10",    name: "Archive Building ",                                                              lat: -25.43465934547468,    lng: 30.980315329428805 },
            { number: "3",     name: "ICT Labs",                                                                       lat: -25.435540885879355,   lng: 30.982364260219363 },
            { number: "35",    name: "Health and Wellness, Clinic and Gym",                                            lat: -25.434720685392175,   lng: 30.980524557013158 },
            { number: "13",    name: "Library",                                                                        lat: -25.436887814759263,   lng: 30.982360664069525 },
            { number: "4",     name: "Administration Block",                                                           lat: -25.43598782542453,    lng: 30.983152957083913 },
            { number: "26-33", name: "Student Residences ",                                                            lat: -25.435759111049038,   lng: 30.98052422380456  },
            { number: "37-38", name: "Sports & Recreation (Multi Purpose Hall, Squash Court, Gym)",                    lat: -25.43438181819322,    lng: 30.98002398806447 },
            { number: "34",    name: "Dining Hall",                                                                    lat: -25.43591865723786,    lng: 30.98242926343278  },
            {number:"39",      name:"multipurpose hall",                                                               lat: -25.43475444278633,    lng: 30.979911456058264},
            {number:"12",      name: "Multi Purpose Admin Block West",                                                 lat: -25.437089549754564,   lng: 30.983996302415584},
            {number: "11",     name: "Multi Purpose Admin Block East",                                                 lat: -25.436930967826424,   lng: 30.98467344771805},
            {number:"5",       name:"University Hall and Dining Hall",                                                 lat: -25.435975738020815,   lng: 30.982487693334292},
            {number:"1",       name:"Office Block",                                                                    lat: -25.435415298095204,   lng: 30.982862345621317},
            {number:"6",       name:"Auditorium",                                                                      lat: -25.436258746221597,   lng: 30.983046668951292},
            {number: "7",      name: "Multi-Purpose Teaching Block",                                                   lat: -25.436353890842685,   lng: 30.98358620662674 },
            {number:"21",      name:"Undergraduate Science Laboratories and Teaching Venues",                          lat:-25.434767495942307,    lng:30.977512151268456 },
            {number:"15",      name:"Library, IT Platform and Auditorium",                                             lat:-25.43583314467284,     lng:30.978209155882436},
            {number:"16",      name:"Student Centre",                                                                  lat:-25.43562967852342 ,    lng:30.9783057154036},
            {number:"17",      name:"Physics Laboratory",                                                              lat: -25.435309945308617,   lng:30.97842373259612},
            {number:"18",      name:"Engineering Laboratory",                                                          lat: -25.434980522320984 ,  lng:30.978289622150076},
            {number:"19",      name:"Chemistry Laboratory",                                                            lat: -25.43509678936065 ,   lng:30.97798385033308},
            {number:"20",      name:"Lecture Venue and Offices",                                                       lat:-25.435460123136405 ,   lng:30.97753860365219},
            {number:"22",      name:"Offices and Research Laboratories",                                               lat:-25.43529541196051 ,    lng:30.97708262813562},
            {number:"23",      name:"Irrigation Laboratory",                                                           lat:-25.439690437034844 ,   lng:30.980620832565837},
            {number:"24",      name:"Offices",                                                                         lat:-25.44025281635609 ,    lng:30.98217257384538},
            {number:"25",      name:"Operational Support and Facilities Management",                                   lat:-25.440662681556677 ,   lng:30.9819769373726},
            /*{number:"", name:"", lat: , lng:},*/
            
        ]; 
         
 
        buildings.forEach(b => {
            const marker = new google.maps.Marker({
                position: { lat: b.lat, lng: b.lng },
                map: map,
                title: b.name,
                label: {
                    text: String(b.number),
                    color: 'white',
                    fontWeight: 'bold',
                    fontSize: '11px'
                },
                icon: {
                    path: google.maps.SymbolPath.CIRCLE,
                    scale: 18,
                    fillColor: '#007bff',
                    fillOpacity: 1,
                    strokeColor: 'white',
                    strokeWeight: 2
                }
            });

            const infoWindow = new google.maps.InfoWindow({
                content: `<strong>Building ${b.number}</strong><br>${b.name}`
            });

            marker.addListener('click', () => {
                infoWindow.open(map, marker);
            });
        });
    }


</script>
            
            
            <input 
                type="text" 
                id="searchInput" 
                placeholder="Search for a building..." 
                onkeyup="filterBuildings()"
                style="width:100%; padding:10px; margin-bottom:16px; border:1px solid #ccc; border-radius:4px; font-size:14px; box-sizing:border-box;"
            />

            <div class="category-title">🎓 Academic & Administration</div>
            <div class="building-grid">
                <div class="building-card"><div class="number">1</div><div class="name">Office Block</div></div>
                <div class="building-card"><div class="number">2</div><div class="name">Library and Lecture Venue</div></div>
                <div class="building-card"><div class="number">3</div><div class="name">ICT Building</div></div>
                <div class="building-card"><div class="number">4</div><div class="name">Administration Block</div></div>
                <div class="building-card"><div class="number">5</div><div class="name">University Hall and Dining Hall</div></div>
                <div class="building-card"><div class="number">6</div><div class="name">Auditorium</div></div>
                <div class="building-card"><div class="number">7</div><div class="name">Multi-Purpose Teaching Block</div></div>
                <div class="building-card"><div class="number">8</div><div class="name">Hospitality and Tourism</div></div>
                <div class="building-card"><div class="number">9</div><div class="name">Wellness and Conference Centre</div></div>
                <div class="building-card"><div class="number">10</div><div class="name">Archive Building</div></div>
                <div class="building-card"><div class="number">11</div><div class="name">Multi Purpose Admin Block East</div></div>
                <div class="building-card"><div class="number">12</div><div class="name">Multi Purpose Admin Block West</div></div>
                <div class="building-card"><div class="number">13</div><div class="name">Resource Centre and Library</div></div>
                <div class="building-card"><div class="number">14</div><div class="name">Executive Offices</div></div>
                <div class="building-card"><div class="number">15</div><div class="name">Library, IT Platform and Auditorium</div></div>
                <div class="building-card"><div class="number">16</div><div class="name">Student Centre</div></div>
                <div class="building-card"><div class="number">17</div><div class="name">Physics Laboratory</div></div>
                <div class="building-card"><div class="number">18</div><div class="name">Engineering Laboratory</div></div>
                <div class="building-card"><div class="number">19</div><div class="name">Chemistry Laboratory</div></div>
                <div class="building-card"><div class="number">20</div><div class="name">Lecture Venue and Offices</div></div>
                <div class="building-card"><div class="number">21</div><div class="name">Undergraduate Science Laboratories and Teaching Venues</div></div>
                <div class="building-card"><div class="number">22</div><div class="name">Offices and Research Laboratories</div></div>
                <div class="building-card"><div class="number">23</div><div class="name">Irrigation Laboratory</div></div>
                <div class="building-card"><div class="number">24</div><div class="name">Offices</div></div>
                <div class="building-card"><div class="number">25</div><div class="name">Operational Support and Facilities Management</div></div>
            </div>

            <div class="category-title">🏠 Residential</div>
            <div class="building-grid">
                <div class="building-card"><div class="number">26</div><div class="name">Third Year Hostel and Flats</div></div>
                <div class="building-card"><div class="number">27</div><div class="name">Hostel Huis Loskop</div></div>
                <div class="building-card"><div class="number">28</div><div class="name">Hostel Huis De Kaap</div></div>
                <div class="building-card"><div class="number">29</div><div class="name">Hostel Huis Onderberg</div></div>
                <div class="building-card"><div class="number">30</div><div class="name">Hostel Huis Letaba</div></div>
                <div class="building-card"><div class="number">31</div><div class="name">Student Residence</div></div>
                <div class="building-card"><div class="number">32</div><div class="name">Student Residence</div></div>
                <div class="building-card"><div class="number">33</div><div class="name">Student Residence</div></div>
                <div class="building-card"><div class="number">34</div><div class="name">Dining Hall</div></div>
            </div>

            <div class="category-title">⚽ Sports & Recreation</div>
            <div class="building-grid">
                <div class="building-card"><div class="number">35</div><div class="name">Health and Wellness, Clinic and Gym</div></div>
                <div class="building-card"><div class="number">36</div><div class="name">Multi Purpose Hall</div></div>
                <div class="building-card"><div class="number">37</div><div class="name">Student Lapa</div></div>
                <div class="building-card"><div class="number">38</div><div class="name">Squash Court</div></div>
                <div class="building-card"><div class="number">39</div><div class="name">Sports Ablutions and Tuck Shop</div></div>
                <div class="building-card"><div class="number">40</div><div class="name">Sports Clubhouse</div></div>
            </div>
        </div>

        
        
        
        
       

        <!-- REQUEST HISTORY -->
        <div class="section">
            <h2>📋 My Service Requests</h2>
            <% if (requests.isEmpty()) { %>
                <div class="empty">
                    <p>You have not submitted any requests yet.</p>
                    <a href="submit.jsp">Submit your first request</a>
                </div>
            <% } else { %>
            <table>
                <tr>
                    <th>#</th>
                    <th>Category</th>
                    <th>Location</th>
                    <th>Description</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
                <% for (ServiceRequest req : requests) { %>
                <tr>
                    <td><%= req.getId() %></td>
                    <td><%= req.getCategory() %></td>
                    <td><%= req.getLocation() %></td>
                    <td><%= req.getDescription() %></td>
                    <td><span class="<%= req.getPriority() %>"><%= req.getPriority() %></span></td>
                    <td><span class="badge <%= req.getStatus() %>"><%= req.getStatus() %></span></td>
                    <td><%= req.getCreatedAt() %></td>
                </tr>
                <% } %>
            </table>
            <% } %>
        </div>

    </div>
        
    <!-- ANNOUNCEMENTS -->
<div class="section">
    <h2>📢 Campus Announcements</h2>
    <%
        List<com.mycompany.scsms.model.Announcement> announcements = new ArrayList<>();
        try {
            Connection connAnn = DBConnection.getConnection();
            ResultSet rsAnn = connAnn.prepareStatement(
                "SELECT * FROM announcements ORDER BY created_at DESC"
            ).executeQuery();
            while (rsAnn.next()) {
                announcements.add(new com.mycompany.scsms.model.Announcement(
                    rsAnn.getInt("id"),
                    rsAnn.getString("title"),
                    rsAnn.getString("message"),
                    rsAnn.getInt("created_by"),
                    rsAnn.getString("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    <% if (announcements.isEmpty()) { %>
        <div class="empty">No announcements at this time.</div>
    <% } else { %>
        <% for (com.mycompany.scsms.model.Announcement ann : announcements) { %>
        <div style="border-left:4px solid #007bff; border-radius:6px; padding:16px; margin-bottom:12px; background-color:#f0f7ff;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                <strong style="color:#007bff; font-size:16px;"><%= ann.getTitle() %></strong>
                <small style="color:#999;"><%= ann.getCreatedAt() %></small>
            </div>
            <p style="color:#333; font-size:14px;"><%= ann.getMessage() %></p>
        </div>
        <% } %>
    <% } %>
</div>
        
        
<script>
    function filterBuildings() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const cards = document.querySelectorAll('.building-card');
        cards.forEach(card => {
            const name = card.querySelector('.name').textContent.toLowerCase();
            const number = card.querySelector('.number').textContent.toLowerCase();
            if (name.includes(input) || number.includes(input)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }
</script>        
    </div>    
</body>
</html>