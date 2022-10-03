import pandas as pd
import mysql.connector as msql
from mysql.connector import Error
import pysftp
import os
from dotenv import load_dotenv
import attendance_yona

def connection_attendace_csv_to_mysql():
    cnopts = pysftp.CnOpts()
    cnopts.hostkeys = None
    load_dotenv() 
    with pysftp.Connection(host=os.environ["sftp_hostname"], username=os.environ["sftp_username"], port=22, password=os.environ["sftp_password"], cnopts=cnopts) as sftp:
       print('SFTP Connection successfully established ... ')
       sftp.get_d(os.environ["sftp_remote_dir"], os.environ["csv_dir_in_the_container"], True)
    
    conn = msql.connect(host=os.environ["mysql_host"], user=os.environ["mysql_user"], password=os.environ["mysql_password"], database=os.environ["mysql_db"])
    
    attendance_yona.start(os.environ["csv_dir_in_the_container"])
    csv_path = os.getcwd() + '/attendance.csv'
    df_yona = pd.read_csv(csv_path, index_col=False, delimiter=',')
    df_filtered = df_yona[['names', 'average']].copy()
        
    if conn.is_connected():
      cursor = conn.cursor()
      cursor.execute("CREATE DATABASE IF NOT EXISTS yossidb;")
      cursor.execute("USE yossidb;")
      record = cursor.fetchone()
      cursor.execute('DROP TABLE IF EXISTS attendance_data;')
      print('Creating table....')
      cursor.execute("CREATE TABLE attendance_data(Names VARCHAR(20), Average VARCHAR(20))")
      for i, row in df_filtered.iterrows():
         sql = "INSERT INTO yossidb.attendance_data VALUES (%s, %s)"
         cursor.execute(sql, tuple(row))
         conn.commit()
    query = "SELECT * FROM yossidb.attendance_data;"
    cursor.execute(query)
    df_from_sql = pd.DataFrame(columns=['names','average'])
    records = cursor.fetchall()
    for record in records:
       df_from_sql.loc[len(df_from_sql)] = record
       
    conn.close()
    
    return df_from_sql  
