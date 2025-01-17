﻿using CodeToCure_MVC.Models;
using Data.DataAccess;
using Data.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.VisualBasic;
using System.Data;
using static CodeToCure_MVC.Models.MasterPage;

namespace CodeToCure_MVC.Extensions
{
    public class CustomPageSetupAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            MasterpageResponse aResponse = new MasterpageResponse();
            string CurrentURL = StaticPublicObjects.ado.GetRequestPath();
            MasterPage masterPage = new MasterPage();
            aResponse = masterPage.MasterPage_Code(aResponse);

            if (!aResponse.IsSessionEnabled)
            {
                filterContext.Result = new RedirectResult(aResponse.RedirectURL);
                return;
            }

            //StaticPublicObjects.ado.IsValidToken(StaticPublicObjects.ado.GetPublicClaimObjects(), AppEnum.WebTokenExpiredTime.Seconds);
            var controller = filterContext.Controller as Controller;

            if (controller != null)
            {
                controller.ViewBag.Sidebarstring = Side_Menu.GetSideBar();
                controller.ViewBag.PageGroupDT = filterContext.HttpContext.Session.GetObject<DataTable>("PageGroupDT");
                controller.ViewBag.PageDT = filterContext.HttpContext.Session.GetObject<DataTable>("PageDT");
                controller.ViewBag.CurrentPG = filterContext.HttpContext.Session.GetIntNotNull("CurrentPG");
                var _publicClaimObjects = filterContext.HttpContext.Session.GetObject<PublicClaimObjects>("PublicClaimObjects");
                controller.ViewBag.FullName = _publicClaimObjects.P_Get_User_Info_Class.FullName;
                controller.ViewBag.UserName = _publicClaimObjects.username;
                controller.ViewBag.ConnectionId = filterContext.HttpContext.Connection.Id;
                bool? IsApplicantLogin = filterContext.HttpContext.Session.GetBool("IsApplicantLogin") ?? false;
                controller.ViewBag.IsApplicantLogin = IsApplicantLogin;
                controller.ViewBag.Applicant = _publicClaimObjects.username;

                try
                {
                    if (string.IsNullOrEmpty(filterContext.HttpContext.Session.GetString("FileGUID")))
                        filterContext.HttpContext.Session.SetStringValue("FileGUID", Guid.NewGuid().ToString().ToLower());

                    controller.ViewBag.GUID = filterContext.HttpContext.Session.GetString("FileGUID") ?? Guid.NewGuid().ToString().ToLower();
                }
                catch (Exception ex)
                {
                    StaticPublicObjects.logFile.ErrorLog(FunctionName: "OnActionExecuting", SmallMessage: ex.Message, Message: ex.ToString());
                    controller.ViewBag.GUID = Guid.NewGuid().ToString().ToLower();
                }
            }

            base.OnActionExecuting(filterContext);
        }
    }
}
