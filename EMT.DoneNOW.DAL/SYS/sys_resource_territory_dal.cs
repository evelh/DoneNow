﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_resource_territory_dal : BaseDAL<sys_resource_territory>
    {
        /// <summary>
        /// 根据员工id获取列表
        /// </summary>
        /// <param name="resourceId"></param>
        /// <returns></returns>
        public List<sys_resource_territory> GetListByResourceId(long resourceId)
        {
            string sql = $"SELECT * FROM sys_resource_territory WHERE resource_id={resourceId} AND delete_time=0";
            return FindListBySql(sql);
        }
    }

}
