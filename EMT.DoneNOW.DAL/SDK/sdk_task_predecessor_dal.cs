﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_predecessor_dal : BaseDAL<sdk_task_predecessor>
    {
        /// <summary>
        /// 根据taskid 获取到将这个作为前驱任务的Task
        /// </summary>
        public List<sdk_task> GetTaskByPreId(long preTaskId)
        {
            return FindListBySql<sdk_task>($"SELECT * from sdk_task where id in( SELECT task_id from sdk_task_predecessor where predecessor_task_id = {preTaskId} and delete_time = 0)  and delete_time = 0");
        } 
    }
}
