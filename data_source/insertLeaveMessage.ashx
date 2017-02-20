<%@ WebHandler Language="C#" Class="insertLeaveMessage" %>

using System;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public class insertLeaveMessage : IHttpHandler {

    private static object thislock = new object();

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        lock(thislock)
        {
            string result = "";

            string nickname = context.Request.Form["nickname"].ToString();
            string message = context.Request.Form["message"].ToString();

            message = message.Replace("\n", "<br>");

            string leaveMessageTime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            string connectionString = ConfigurationManager.ConnectionStrings["SQLServerConnectionString"].ToString();

            SqlConnection sqlConnection = new SqlConnection(connectionString);

            try
            {
                sqlConnection.Open();

                string sql = "INSERT INTO MessageBoard(nickname, message, leaveMessageTime) VALUES(@nickname, @message, @leaveMessageTime)";

                SqlCommand sqlCommand = new SqlCommand(sql, sqlConnection);

                sqlCommand.Parameters.Add("nickname", SqlDbType.NVarChar).Value = nickname;
                sqlCommand.Parameters.Add("message", SqlDbType.NVarChar).Value = message;
                sqlCommand.Parameters.Add("leaveMessageTime", SqlDbType.NVarChar).Value = leaveMessageTime;

                sqlCommand.ExecuteNonQuery();

                result = "Success";
            }
            catch(Exception error)
            {
                result = error.ToString();
            }
            finally
            {
                sqlConnection.Close();

                context.Response.Write(result);
            }
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}