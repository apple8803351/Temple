<%@ WebHandler Language="C#" Class="insertParticipateList" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;

public class insertParticipateList : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json";

        string sql = "";

        string lightName = context.Request.Form["lightName"].ToString();
        string searchZodiac = context.Request.Form["zodiac"].ToString();
        string start = context.Request.Form["start"].ToString();
        string end = Int32.Parse(start) + Int32.Parse(context.Request.Form["length"].ToString()) + "";

        string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnectionString"].ToString();

        SqlConnection sqlConnection = new SqlConnection(connectionString);

        if(searchZodiac.Equals("12"))
        {
            sql = "SELECT 姓名,年,月,日,出生時間 FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY id) as row FROM ParticipateList WHERE " + lightName + " = '1') a WHERE row >" + start + " and row <= " + end;
        }
        else
        {
            sql = "SELECT 姓名,年,月,日,出生時間 FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY id) as row FROM ParticipateList WHERE " + lightName + " = '1' AND TRY_CONVERT(INT,年) % 12 = " + searchZodiac + ") a WHERE row >" + start + " and row <= " + end;
        }

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