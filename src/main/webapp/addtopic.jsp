<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="tinymce/js/tinymce/tinymce.min.js"></script>
  </head>
  <body>
    		<%@ include file="adminnavbar.jsp" %>
            <div class="col-1">

            </div>
            <div class="col-7 py-3">
            <form action="addtopiccontroller" method="post">
            	<div class="mb-3">
                   <h2> <label for="exampleFormControlTextarea1" class="form-label">Title</label></h2>
                    <input class="form-control" type="text" name="title">
                  </div>
                  <div class="mb-3">
                    <h2><label for="exampleFormControlTextarea1" class="form-label">Description</label></h2>
                    <textarea class="form-control" id="exampleFormControlTextarea1" name="description" rows="3"></textarea>
                  </div>
                  <input type="hidden" value=<%=request.getParameter("courseid") %> name="courseid">
                  <button type="submit" class="btn btn-primary">Add</button>
             </form>
            </div>
       
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
<script>
  tinymce.init({
    selector: 'textarea#exampleFormControlTextarea1', // Use the correct ID
    // Add more TinyMCE options as needed
  });
</script>
    
  </body>
</html>