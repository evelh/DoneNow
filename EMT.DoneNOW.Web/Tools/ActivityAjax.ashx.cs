﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// 活动处理（备注/待办等）
    /// </summary>
    public class ActivityAjax : IHttpHandler, IRequiresSessionState
    {
        private ActivityBLL bll = new ActivityBLL();
        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "CheckTodo":
                        var id = context.Request.QueryString["id"];
                        CheckTodo(context, long.Parse(id));
                        break;
                    case "Delete":
                        id = context.Request.QueryString["id"];
                        DeleteActivity(context, long.Parse(id));
                        break;
                    case "TodoComplete":
                        id = context.Request.QueryString["id"];
                        TodoSetCompleted(context, long.Parse(id));
                        break;
                    case "NoteSetScheduled":
                        id = context.Request.QueryString["id"];
                        NoteSetScheduled(context, long.Parse(id));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {
                context.Response.Write("{\"code\": 'error', \"msg\": \"参数错误！\"}");
            }
        }

        /// <summary>
        /// 判断一个待办是否是备注和是否有商机，显示不同的右键菜单
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void CheckTodo(HttpContext context, long id)
        {
            List<string> rtn = new List<string>();
            rtn.Add(bll.CheckIsNote(id) == true ? "1" : "0");
            var act = bll.GetActivity(id);
            if (act.opportunity_id == null)
                rtn.Add("0");
            else
                rtn.Add(act.opportunity_id.ToString());
            context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
        }

        /// <summary>
        /// 删除活动
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void DeleteActivity(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteActivity(id, (context.Session["dn_session_user_info"] as sys_user).id)));
        }

        /// <summary>
        /// 设置待办完成
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void TodoSetCompleted(HttpContext context, long id)
        {
            bll.TodoSetCompleted(id, (context.Session["dn_session_user_info"] as sys_user).id);
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

        /// <summary>
        /// 备注转为待办
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void NoteSetScheduled(HttpContext context, long id)
        {
            bll.NoteSetScheduled(id, (context.Session["dn_session_user_info"] as sys_user).id);
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}