# frozen_string_literal: true

class LogController < ApplicationController
    def index
    end

    def getlog
        p "getlog"
        if(params[:log_type] == "apl")
            result_all = IO.readlines("/opt/application/current/log/apl_log.log")
            result_len = result_all.length
            result = tail_read(params[:log_len], result_len, result_all)
        elsif (params[:log_type] == "uni")
            result_all = IO.readlines("/opt/application/current/log/unicorn.log")
            result_len = result_all.length
            result = tail_read(params[:log_len], result_len, result_all)
        elsif (params[:log_type] == "dev")
            result_all = IO.readlines("/opt/application/current/log/development.log")
            result_len = result_all.length
            result = tail_read(params[:log_len], result_len, result_all)
        elsif (params[:log_type] == "prd")
            result_all = IO.readlines("/opt/application/current/log/production.log")
            result_len = result_all.length
            result = tail_read(params[:log_len], result_len, result_all)
        end
        render json: result
    end

    # 读取文件最后几行
    # result_all 文件内容
    # result_len 文件实际行数
    # log_len 需要显示行数
    def tail_read(log_len, result_len, result_all)
        res = []
        if log_len.to_i > result_len.to_i
            res.push("数据量行数过小")
        else
            for i in result_len.to_i-log_len.to_i-1..result_len.to_i-1
                res.push(result_all[i])
            end
        end
        return res
    end

    #得到文件树
    def get_file_list
        path = "/opt/application/current"
        arr_filepath=[]
        c_dir = "DDDDD"
        c_file = "FFFFF"
        traverse(path, c_dir, c_file, arr_filepath)
        puts arr_filepath.length
        result = arr_adjust(arr_filepath)
        render json: result
    end

    #遍历的文件绝对路径，返回数组
    def traverse(filepath, c_dir, c_file, arr_filepath)
        str_file = ""
        if File.directory?(filepath)
            str_file = c_dir+filepath
            arr_filepath.push(str_file)
            # puts "Dirs:" + filepath
            Dir.foreach(filepath) do |filename|
                if filename != "." and filename != ".."
                    traverse(filepath + "/" + filename, c_dir, c_file, arr_filepath)
                end
            end
        else
            str_file = c_file+filepath
            arr_filepath.push(str_file)
            # puts "Files:" + filepath
        end
    end

    def openfile
        p "openfile"
        res = []
        File.open(params[:url].to_s,"r").each_line do |line|
            res.push(line)
        end
        render json: res
    end

    #更新既存代码
    def changefile
        p "changefile"
        File.open(params[:file_url].to_s,"w+") do |f|
            f.puts params[:file_content].to_s
        end
        result = "success"
        render json: result
    end

    #将遍历的文件绝对路径数组转化成ztree需要的simpleData格式数组
    def arr_adjust(arr_filepath)
        p "arr_adjust"
        arr_result = []
        arr_result_uni = []
        arr_filepath_copy = []
        arr_filepath_copy = Array.new(arr_filepath)
        arr_result_test = []
        for i in 0..arr_filepath.length-1
            arr_path_single= []
            arr_path_single = arr_filepath[i].split('/')
            #从数组第4个元素开始判断 （app同级目录）
            for j in 4..arr_path_single.length-1
                #屏蔽部分目录
                if arr_path_single[4] != ".circleci" && arr_path_single[4] != ".git" && arr_path_single[4] != "data" && arr_path_single[4] != "coverage" && arr_path_single[4] != "tmp" && arr_path_single[4] != "spec" && arr_path_single[4] != "node_modules"
                    node = Hash.new
                    node_uni = Hash.new
                    str_tmp = ""
                    str_pre = ""
                    str_ord_pid = ""
                    str_ord_id = ""
                    if j == 4
                        node["pId"] = 0
                    else
                        #将pId目录名转化成ASC(目录名=父级前两位+当前) （app同级目录）
                        str_pre = arr_path_single[j-2][0,2].to_s
                        str_tmp = str_pre + arr_path_single[j-1].to_s
                        str_tmp.each_char(){ |c|
                            str_ord_pid += c.ord.to_s
                        }
                        node["pId"] = str_ord_pid.to_i
                    end
                    #将id目录名转化成ASC(目录名=父级前两位+当前) （app同级目录）
                    str_pre = arr_path_single[j-1][0,2].to_s
                    str_tmp = str_pre + arr_path_single[j].to_s
                    str_tmp.each_char(){ |c|
                        str_ord_id += c.ord.to_s
                    }
                    node["id"] = str_ord_id.to_i
                    node_uni["id"] = node["id"].dup
                    node_uni["pId"] = node["pId"].dup
                    #判断pId 和id 是否有重复
                    if arr_result_uni.include?(node_uni)
                    else
                        arr_result_uni.push(node_uni)
                        node["name"] = arr_path_single[j]
                        node["url"] = arr_filepath_copy[i].to_s[5..-1]
                        node["dirOrFile"] = arr_filepath_copy[i].to_s[0]
                        arr_result.push(node)
                    end
                end
            end
        end
        return arr_result
    end

    #获取数据库表的ztree
    def searchdb
        p "searchdb"
        result = Hash.new
        result[:user_management] = UserInfo.new.show_tables("user_management_20190516")
        result[:health_diag] = HealthDiagReport.new.show_tables("health_diag_20190613")
        sql_select = 'select table_name from information_schema.tables where table_schema=\'lupin\''
        lupin_table = ActiveRecord::Base.send(
            :sanitize_sql_array,
            [sql_select]
        )
        select_data = ActiveRecord::Base.connection.select_all(lupin_table)
        result[:lupin] = select_data
        p result
        render json: result
    end

    #查该表数据
    def showtable
        p "showtable"
        result = Hash.new
        if params[:pid] == "1"
            sql_col_name = 'select COLUMN_NAME from information_schema.COLUMNS where table_schema = \'lupin\' and table_name = \''
            sql_col_name += params[:tb_name]
            sql_col_name += '\''
            click_table_col_name = ActiveRecord::Base.send(
                :sanitize_sql_array,
                [sql_col_name]
            )
            result[:col_name] = ActiveRecord::Base.connection.select_all(click_table_col_name)
            sql_content = 'select * from '
            sql_content += params[:tb_name]
            click_table_content = ActiveRecord::Base.send(
                :sanitize_sql_array,
                [sql_content]
            )
            result[:content] = ActiveRecord::Base.connection.select_all(click_table_content)
        elsif params[:pid] == "2"
            result[:col_name] = UserInfo.new.show_click_table_col_name("user_management_20190516", params[:tb_name])
            result[:content] = UserInfo.new.show_click_table_content(params[:tb_name])
        elsif params[:pid] == "3"
            result[:col_name] = HealthDiagReport.new.show_click_table_col_name("health_diag_20190613", params[:tb_name])
            result[:content] = HealthDiagReport.new.show_click_table_content(params[:tb_name])
        else
            result[:col_name] = []
            result[:content] = []
        end
        render json: result
    end

    #sql语句执行
    def sqlexe
        p "sqlexe"
        sql = params[:sql_content].to_s
        if params[:datebase_select_val] == "lupin"
            result = ActiveRecord::Base.connection.execute(sql)
        elsif params[:datebase_select_val] == "user_management_20190516"
            result = UserModule.connection.execute(sql)
        elsif params[:datebase_select_val] == "health_diag_20190613"
            result = DiagModule.connection.execute(sql)
        end
    end
end
