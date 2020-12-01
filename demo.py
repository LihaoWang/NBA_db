import pandas as pd
import psycopg2
import streamlit as st
from configparser import ConfigParser

'# Basketball'

@st.cache
def get_config(filename='database.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)
    return {k: v for k, v in parser.items(section)}


@st.cache
def query_db(sql: str):
    # print(f'Running query_db(): {sql}')

    db_info = get_config()

    # Connect to an existing database
    conn = psycopg2.connect(**db_info)

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a command: this creates a new table
    cur.execute(sql)

    # Obtain data
    data = cur.fetchall()
    
    column_names = [desc[0] for desc in cur.description]

    # Make the changes to the database persistent
    conn.commit()

    # Close communication with the database
    cur.close()
    conn.close()

    df = pd.DataFrame(data=data, columns=column_names)

    return df


'## Read tables'

sql_all_table_names = "select relname from pg_class where relkind='r' and relname !~ '^(pg_|sql_)';"
all_table_names = query_db(sql_all_table_names)['relname'].tolist()
table_name = st.selectbox('Choose a table', all_table_names)
if table_name:
    f'Display the table'

    sql_table = f'select * from {table_name};'
    df = query_db(sql_table)
    st.dataframe(df)


#'## Query owners'
#
#sql_customer_names = 'select name from owners;'
#customer_names = query_db(sql_customer_names)['name'].tolist()
#customer_name = st.selectbox('Choose an owner', customer_names)
#if customer_name:
#    sql_customer = f"select * from owners where name = '{customer_name}';"
#    customer_info = query_db(sql_customer).loc[0]
##    c_age, c_city, c_state = customer_info['age'], customer_info['city'], customer_info['state']
#    oid=customer_info['oid']
#    st.write(f"{customer_name} is {oid}")
    
#'## Query teams from city'
#sql_team_city= 'select distinct city from teams'
#city_names = query_db(sql_team_city)['city'].tolist()
#city_name_selected = st.selectbox('choose a city', city_names)
#if city_name_selected:
#    sql_team_name = f"select name from teams where city = '{city_name_selected}';"
#    df = query_db(sql_team_name)
#    st.dataframe(df)

'## Query statistics from player name'
player_names = query_db('select distinct name from players')['name'].tolist()
player_name_selected = st.selectbox('choose a player', player_names)
if player_name_selected:
    sql_statistics_from_name = f"""select S.season, S.gp, S.gs, S.min, S.pts, S.oreb, S.dr, S.reb, S.ast, S.stl, S.blk, S.tuov, S.pf, S.ast_tuov, S.per from statistics S 
    where S.pid in 
    (select P.pid from players P where P.name = '{player_name_selected}');"""
    df_f1 = query_db(sql_statistics_from_name)
    st.dataframe(df_f1)

'## Query statistics from team name and year'
team_names = query_db('select distinct name from teams')['name'].tolist()
team_name_selected = st.selectbox('choose a team', team_names)
years = query_db('select year from years')['year'].tolist()
year_selected = st.selectbox('choose a year', years)
if year_selected and team_name_selected:
    sql_statistics_from_team_year = f"""select P.name, S.season, S.gp, S.gs, S.min, S.pts, S.oreb, S.dr, S.reb, S.ast, S.stl, S.blk, S.tuov, S.pf, S.ast_tuov, S.per 
    from statistics S, players P
    where S.season = {year_selected}
    and S.pid = P.pid and S.pid in (select pid from plays_in_team PT 
                                    where PT.year = {year_selected} 
                                    and PT.tid in (select tid from Teams T 
                                    where T.name = '{team_name_selected}'));"""
    df_f2 = query_db(sql_statistics_from_team_year)
    st.dataframe(df_f2)
"## Query a player's career max pts"
player_name_input = st.text_input('player name', 'Andre Iguodala')
if player_name_input:
    sql_max_pts_from_player = f"""
    select MAX(pts) maxpoint, P.name
    from statistics S, players P
    where S.pid = P.pid
    and P.pid in (select P1.pid from players P1
                where P1.name = '{player_name_input}'
    )
    group by P.name;
    """
    player_max_pts = query_db(sql_max_pts_from_player).loc[0]['maxpoint']
    st.write(f"Max pts in {player_name_input}'s career is {player_max_pts}")

'## Query the highest statistic among all seasons'
max_stat_list = ('gp', 'gs', 'min', 'pts', 'oreb', 'dr', 'reb', 'ast','stl', 'blk', 'tuov', 'pf', 'ast_tuov', 'per')
max_stat_selected = st.selectbox('select the stat you want to see', max_stat_list)
stat_order_selected = st.radio('order by (ascending)', ('season','max_stat'))
if max_stat_selected and stat_order_selected:
    sql_max_stat_all_season = f"""
    select season, MAX({max_stat_selected}) max_stat
    from statistics S
    group by season
    order by {stat_order_selected};
    """
    df_f3 = query_db(sql_max_stat_all_season)
    st.dataframe(df_f3)


#'## Query orders'
#
#sql_order_ids = 'select order_id from orders;'
#order_ids = query_db(sql_order_ids)['order_id'].tolist()
#order_id = st.selectbox('Choose an order', order_ids)
#if order_id:
#    sql_order = f"""select C.name, O.order_date
#                    from orders as O, customers as C 
#                    where O.order_id = {order_id}
#                    and O.customer_id = C.id;"""
#    customer_info = query_db(sql_order).loc[0]
#    customer_name = customer_info['name']
#    order_date = customer_info['order_date']
#    st.write(f'This order is placed by {customer_name} on {order_date}.')