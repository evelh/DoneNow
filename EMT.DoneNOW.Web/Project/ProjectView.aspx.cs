﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;


namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectView : BasePage
    {
        protected pro_project thisProject = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    // todo 校验 是否有权限进行查看

                    var thisAccount = new CompanyBLL().GetCompany(thisProject.account_id);
                    ShowTitle.Text = "项目-"+thisProject.no+thisProject.name+"("+ thisAccount.name + ")";
                    var type = Request.QueryString["type"];
                    switch (type)
                    {
                        case "Schedule":
                            viewProjectIframe.Src = "ProjectSchedule?project_id=" + thisProject.id;
                          
                            break;
                        case "ScheduleTemp":
                            viewProjectIframe.Src = "ProjectSchedule?project_id=" + thisProject.id+ "&isTranTemp=1";
                            break;
                        case "Team":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_TEAM + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_TEAM;
                            break;
                        case "Cost":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?id=" + thisProject.id + "&cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_COST_EXPENSE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.PROJECT_COST_EXPENSE+ "&isCheck=1";
                            break;// project_cost_expense
                        case "Note":
                            viewProjectIframe.Src = "../Common/SearchBodyFrame.aspx?cat=" + (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJETC_NOTE + "&type=" + (int)EMT.DoneNOW.DTO.QueryType.project_note+ "&con1054="+ thisProject.id+"&con1055=";
                            break;
                        default:
                            viewProjectIframe.Src = "ProjectSummary?id=" + thisProject.id;
                            break;
                    }
                }
                else
                {
                    Response.End();
                }

            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
    }
}