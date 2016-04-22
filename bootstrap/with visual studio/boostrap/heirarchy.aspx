<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="heirarchy.aspx.cs" Inherits="bootstrap.heirarchy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Heirarchy</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <script src="Scripts/bootsrap.min.js"></script>
    <link rel="stylesheet" href="Content/bootstrap-theme.min.css" />
</head>
<body>

    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12 visible-lg">
                <img src="https://marianoace.files.wordpress.com/2014/06/img-page-header-swoosh-top.png" />
            </div>
        </div>
        <div class="col-md-4" style="background-color: pink">
            Cats
                <div class="col-md-3" style="background-color: papayawhip;">
                    Sphynx
                </div>
            <div class="col-md-3" style="background-color: paleturquoise;">
                Bengle
            </div>
        </div>
        <div class="col-md-4" style="background-color: lightskyblue;">
            Vegetables
                <div class="col-md-3" style="background-color: papayawhip;">
                    Cucumber
                </div>
            <div class="col-md-3" style="background-color: paleturquoise;">
                Loofah
            </div>
        </div>
        <div class="col-md-4" style="background-color: palegreen">
            Minerals
                <div class="col-md-3" style="background-color: papayawhip;">
                    Shungite
                </div>
            <div class="col-md-3" style="background-color: paleturquoise;">
                Goosecreekite
            </div>
        </div>
    </div>

</body>
</html>
