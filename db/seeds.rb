# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
# car
ActiveRecord::Base.connection.execute('TRUNCATE TABLE `user_managements`')
if UserManagement.count.zero?
  CSV.foreach('db/user_management.csv', col_sep: "\t", headers: false) do |row|
    UserManagement.create(id: row[0],
                          user_id: row[1],
                          nickname: row[2],
                          name: row[3],
                          sex: row[4],
                          password: row[5],
                          age: row[6],
                          phone: row[7],
                          mail: row[8],
                          addr_province: row[9],
                          addr_city: row[10],
                          addr_district: row[11],
                          addr_location: row[12],
                          date_of_birth: row[13],
                          photo: row[14],
                          hobby: row[15],
                          activity: row[16],
                          lvl: row[17],
                          current_state: row[18],
                          last_sign_in: row[19],
                          total_time: row[20],
                          date_of_sign_up: row[21])
  end
end

# user_relation
ActiveRecord::Base.connection.execute('TRUNCATE TABLE `user_relations`')
if UserRelation.count.zero?
  CSV.foreach('db/user_relation.csv') do |row|
    UserRelation.create(id: row[0],user_id_1: row[1],user_id_2: row[2],relation: row[3])
  end
end

# name_note
ActiveRecord::Base.connection.execute('TRUNCATE TABLE `name_notes`')
if NameNote.count.zero?
  CSV.foreach('db/name_note.csv') do |row|
    NameNote.create(id: row[0],user_id: row[1],noted_id: row[2],note_name: row[3])
  end
end

# group_info
ActiveRecord::Base.connection.execute('TRUNCATE TABLE `group_infos`')
if GroupInfo.count.zero?
  CSV.foreach('db/group_info.csv', col_sep: "\t", headers: false) do |row|
    GroupInfo.create(id: row[0], group_id: row[1], member_list: row[2], group_creator: row[3], create_date: row[4])
  end
end


