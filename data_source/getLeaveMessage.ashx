<%@ WebHandler Language="C#" Class="getLeaveMessage" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;

public class getLeaveMessage : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json";

        string start = context.Request.Form["start"].ToString();
        string end = Int32.Parse(start) + Int32.Parse(context.Request.Form["length"].ToString()) + "";

        string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnectionString"].ToString();

        SqlConnection sqlConnection = new SqlConnection(connectionString);

        string sql = "SELECT * FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY id) as row FROM messageBoard) a WHERE row >" + start + " and row <= " + end;

        SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sql, sqlConnection);

        DataTable dataTable = new DataTable();

        sqlDataAdapter.Fill(dataTable);

        string result = JsonConvert.SerializeObject(dataTable, Formatting.Indented);

        context.Response.Write(result);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}