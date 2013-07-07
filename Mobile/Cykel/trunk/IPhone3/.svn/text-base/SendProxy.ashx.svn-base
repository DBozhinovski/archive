<%@ WebHandler Language="C#" Class="SendProxy" %>

using System;
using System.Web;

public class SendProxy : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        //



        System.Net.WebClient client = new System.Net.WebClient();

        string endUrl = "http://cykelscore.dk/_gateways/sendlog.gate.asp?" + context.Request.Form.ToString();

        string responseFromServer = client.UploadString(endUrl, string.Empty);

        context.Response.Write(responseFromServer);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}