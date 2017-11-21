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
using System.IO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class TaskNote : BasePage
    {
        protected crm_account thisAccount = null;
        protected sdk_task thisTask = null;
        protected com_activity thisNote = null;
        protected bool isAdd = true;
        protected List<com_attachment> thisNoteAtt = null;   // 这个备注的附件
        protected Dictionary<string, object> dic = new ProjectBLL().GetField();
        protected sys_resource thisUser = null;
        protected sys_resource thisAccManger;    // 客户经理
        protected d_general sys_email = new d_general_dal().FindNoDeleteById((int)DicEnum.SUPPORT_EMAIL.SYS_EMAIL);
        protected sys_resource task_creator = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    publish_type_id.DataTextField = "name";
                    publish_type_id.DataValueField = "id";
                    var pushList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.NOTE_PUBLISH_TYPE);
                    if(pushList!=null&& pushList.Count > 0)
                    {
                        pushList = pushList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                    }
                    publish_type_id.DataSource = pushList;
                    publish_type_id.DataBind();

                    status_id.DataTextField = "show";
                    status_id.DataValueField = "val";
                    status_id.DataSource = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value;
                    status_id.DataBind();

                    action_type_id.DataTextField = "name";
                    action_type_id.DataValueField = "id";
                    var actList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.ACTION_TYPE);
                    if (actList != null && actList.Count > 0)
                    {
                        actList = actList.Where(_ => _.ext2 == ((int)DicEnum.ACTIVITY_CATE.TASK_NOTE).ToString()).ToList();
                    }
                    action_type_id.DataSource = actList;
                    action_type_id.DataBind();
                    
                }
                thisUser = new sys_resource_dal().FindNoDeleteById(GetLoginUserId());
                var caDal = new com_activity_dal();
                var stDal = new sdk_task_dal();
                var ppDal = new pro_project_dal();
                var accDal = new crm_account_dal();
                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    thisNote = caDal.FindNoDeleteById(long.Parse(id));
                    if (thisNote != null)
                    {
                        isAdd = false;
                        thisTask = stDal.FindNoDeleteById(thisNote.object_id);
                        thisNoteAtt = new com_attachment_dal().GetAttListByOid(thisNote.id);
                        if (!IsPostBack)
                        {

                            if (thisNote.publish_type_id != null)
                            {
                                publish_type_id.SelectedValue = thisNote.publish_type_id.ToString();
                            }
                            action_type_id.SelectedValue = thisNote.action_type_id.ToString();
                        }


                    }
                }
                var taskId = Request.QueryString["task_id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTask = stDal.FindNoDeleteById(long.Parse(taskId));
                }
                if (thisTask != null)
                {
                    task_creator = new sys_resource_dal().FindNoDeleteById(thisTask.create_user_id);
                    if (!IsPostBack)
                    {
                        status_id.SelectedValue = thisTask.status_id.ToString();
                    }
                    
                    if (thisTask.project_id != null)
                    {
                        var project = ppDal.FindNoDeleteById((long)thisTask.project_id);
                        if (project != null)
                        {
                            thisAccount = accDal.FindNoDeleteById(project.account_id);
                        }
                    }
                }
                if (thisAccount == null)
                {
                    Response.End();
                }
                else
                {
                    if (thisAccount.resource_id != null)
                    {
                        thisAccManger = new sys_resource_dal().FindNoDeleteById((long)thisAccount.resource_id);
                    }
                }
            }
            catch (Exception msg)
            {
                Response.Write(msg);
                Response.End();
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            var param = GetParam();
            var result = new TaskBLL().AddTaskNote(param,GetLoginUserId());
            // 操作完成，清除session暂存
            Session.Remove(thisTask.id + "_Att");
            //if (result)
            //{
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();self.opener.location.reload();</script>");
            //}
            //else
            //{
            //    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();self.opener.location.reload();</script>");
            //}
            
            
        }

        private TaskNoteDto GetParam()
        {
            TaskNoteDto param = new TaskNoteDto();
            var pageTaskNote = AssembleModel<com_activity>();
          
            if (isAdd)
            {

            }
            else
            {
                param.attIds = Request.Form["attIds"];
            }
            param.incloNoteDes = CKIncluDes.Checked;
            param.incloNoteAtt = CKIncloAtt.Checked;
            param.toCrea = CKcreate.Checked;
            param.toAccMan = CKaccMan.Checked;
            param.ccMe = CCMe.Checked;
            param.fromSys = Cksys.Checked;
            param.thisTask = thisTask;
            param.filtList = GetSessAttList(thisTask.id);
            param.taskNote = pageTaskNote;
            param.otherEmail = Request.QueryString["otherEmail"];
            param.subjects = Request.QueryString["subjects"];
            param.AdditionalText = Request.QueryString["AdditionalText"];
            if (!string.IsNullOrEmpty(Request.QueryString["notify_id"]))
            {
                param.notify_id = int.Parse(Request.QueryString["notify_id"]);
            }
            return param;
        }

        /// <summary>
        /// 根据任务Id获取相关缓存文件(新增备注附件)
        /// </summary>
        private List<AddFileDto> GetSessAttList(long task_id)
        {
            
            var attList = Session[task_id + "_Att"] as List<AddFileDto>;
            if(attList!=null&& attList.Count > 0)
            {
                foreach (var thisAtt in attList)
                {
                    if (thisAtt.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                    {
                        string saveFilename = "";
                      
                        try
                        {
                            SavePic(thisAtt, out saveFilename);
                        }
                        catch (Exception msg)
                        {
                            continue;
                        }
                        thisAtt.fileSaveName = saveFilename;
                
                    }
                }
            }
            return attList;
        }



        private string SavePic(AddFileDto thisAttDto, out string saveFileName)
        {
            saveFileName = "";
            string fileExtension = Path.GetExtension(thisAttDto.old_filename).ToLower();    //取得文件的扩展名,并转换成小写
            string filepath = $"/Upload/Attachment/{DateTime.Now.ToString("yyyyMM")}/";
            if (Directory.Exists(Server.MapPath(filepath)) == false)    //如果不存在就创建文件夹
            {
                Directory.CreateDirectory(Server.MapPath(filepath));
            }
            string virpath = filepath + Guid.NewGuid().ToString() + fileExtension;//这是存到服务器上的虚拟路径
            string mappath = Server.MapPath(virpath);//转换成服务器上的物理路径
            //FileStream fs = new FileStream(oldPath, FileMode.Open, FileAccess.ReadWrite);
            File.WriteAllBytes(mappath, thisAttDto.files as Byte[]);
           //  fileForm.SaveAs(mappath);//保存图片
            //fs.Close();
            saveFileName = virpath;
            return "";
        }
    }
}