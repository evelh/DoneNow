﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

using System.Web.SessionState;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System.Text;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ContactAjax 的摘要说明
    /// </summary>
    public class ContactAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var contact_id = context.Request.QueryString["id"];
                        DeleteContact(context, Convert.ToInt64(contact_id));
                        break;
                    case "GetConList":
                        var conIds = context.Request.QueryString["ids"];
                        GetConList(context, conIds);
                        break;
                    case "GetConName":
                        var conNameIds = context.Request.QueryString["ids"];
                        GetConName(context, conNameIds);
                        break;
                    case "GetContacts":
                        var aId = context.Request.QueryString["account_id"];
                        GetConAccAndPar(context,long.Parse(aId));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {

                context.Response.End();
            }
        }

        /// <summary>
        /// 删除联系人的事件
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contact_id"></param>
        public void DeleteContact(HttpContext context, long contact_id)
        {
            var result = new ContactBLL().DeleteContact(contact_id, LoginUserId);

            if (result)
            {
                context.Response.Write("删除联系人成功！");
            }
            else
            {
                context.Response.Write("删除联系人失败！");
            }
        }
        private void GetConList(HttpContext context, string ids)
        {
            StringBuilder con = new StringBuilder();
            if (!string.IsNullOrEmpty(ids))
            {
                var conList = new crm_contact_dal().GetContactByIds(ids);
                if (conList != null && conList.Count > 0)
                {
                    conList.ForEach(_ => con.Append($"<option value='{_.id}'>{_.name}</option>"));
                }
            }
            context.Response.Write(con.ToString());
        }

        private void GetConName(HttpContext context, string ids)
        {
            StringBuilder con = new StringBuilder();
            if (!string.IsNullOrEmpty(ids))
            {
                var conList = new crm_contact_dal().GetContactByIds(ids);
                if (conList != null && conList.Count > 0)
                {
                    conList.ForEach(_ => con.Append($";{_.name}"));
                }
            }
            context.Response.Write(con.ToString());
        }
        /// <summary>
        /// 获取到客户和父客户的联系人
        /// </summary>
        private void GetConAccAndPar(HttpContext context,long account_id)
        {
            StringBuilder conHtml = new StringBuilder();
            
            var account = new crm_account_dal().FindNoDeleteById(account_id);
            if (account != null)
            {
                var conList = new crm_contact_dal().GetContactByAccountId(account.id);
                if (conList != null && conList.Count > 0)
                {
                    foreach (var con in conList)
                    {
                        conHtml.Append("<tr><td><input type='checkbox' value='" + con.id + "' class='checkCon' /></td><td>" + con.name + "</td><td><a href='mailto:" + con.email + "'>" + con.email + "</a></td></tr>");
                    }
                }
                if (account.parent_id != null)
                {
                    var parConList = new crm_contact_dal().GetContactByAccountId((long)account.parent_id);
                    if(parConList!=null&& parConList.Count > 0)
                    {
                        conHtml.Append("<tr><td colspan='3'>父客户联系人</td></tr>");
                        foreach (var con in conList)
                        {
                            conHtml.Append("<tr><td><input type='checkbox' value='" + con.id + "' class='checkCon' /></td><td>" + con.name + "</td><td><a href='mailto:" + con.email + "'>" + con.email + "</a></td></tr>");
                        }
                    }
                }
            }
            context.Response.Write(conHtml.ToString());
        }
    }
}