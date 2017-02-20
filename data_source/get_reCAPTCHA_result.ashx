<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Net;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;



public class Handler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json";

        string response = context.Request.Form["g-recaptcha-response"].ToString();

        string postData = "secret=6LfmHxYUAAAAAKInsywEAB2Z3Vc6Iiv-ixNWSarb&response=" + response;

        WebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create("https://www.google.com/recaptcha/api/siteverify?" + postData);

        webRequest.Method = "GET";

        WebResponse webResponse = webRequest.GetResponse();

        Stream stream = webResponse.GetResponseStream();

        StreamReader streamReader = new StreamReader(stream);

        string result = streamReader.ReadToEnd();

        streamReader.Close();
        stream.Close();

        /*JObject jobject = JsonConvert.DeserializeObject<JObject>(result);

        context.Response.Write(jobject["success"]);*/

        context.Response.Write(result);

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}