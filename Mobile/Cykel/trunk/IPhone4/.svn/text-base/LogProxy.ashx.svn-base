<%@ WebHandler Language="C#" Class="LogProxy" %>

using System;
using System.Web;

public class LogProxy : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.BinaryWrite((new System.Net.WebClient()).DownloadData( string.Format("http://cykelscore.dk/_gateways/getlog.gate.asp?userid={0}", context.Request.QueryString["userid"])));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}