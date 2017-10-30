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
    public partial class ProjectSummary : BasePage
    {
        protected pro_project thisProject = null;
        protected List<sdk_task> taskList = null;
        protected ProjectBLL proBLL = new ProjectBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(id));
                if (thisProject != null)
                {
                    taskList = new sdk_task_dal().GetProjectTask(thisProject.id);
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