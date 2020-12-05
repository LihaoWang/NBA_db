import pandas as pd
import psycopg2
import streamlit as st
from configparser import ConfigParser
from PIL import Image

image = Image.open('logo.jpg')
st.image(image, width=250)


'# NBA Statistics'

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

'## General Information'

'### Select a season'
seasons = query_db('select year from years')['year'].tolist()
season_selected = st.selectbox('Seasons', seasons)

'### Select a team'
teams = query_db('select name from teams')['name'].tolist()
team_selected = st.selectbox('Teams', teams)
if team_selected and season_selected:
    st.markdown('**Team Information**')

    sql_team_table = f"select name, city, court, conference_name from teams where name = '{team_selected}';"
    df_team_name = query_db(sql_team_table).loc[0]['name']
    df_team_city = query_db(sql_team_table).loc[0]['city']
    df_team_court = query_db(sql_team_table).loc[0]['court']
    df_team_conference = query_db(sql_team_table).loc[0]['conference_name']

    sql_owner_table = f"select O.name from owned_by_owner as OWO, owners as O where OWO.oid = O.oid and OWO.year = '{season_selected}' and OWO.tid in (select tid from Teams as T where T.name = '{team_selected}');"
    df_team_owner = query_db(sql_owner_table).loc[0]['name']

    sql_coach_table = f"select C.name from coached_by_coach as CBC, coaches as C where CBC.coid = C.coid and CBC.year = '{season_selected}' and CBC.tid in (select tid from Teams as T where T.name = '{team_selected}');"
    df_team_coach = query_db(sql_coach_table).loc[0]['name']
    st.write(f"Name: {df_team_name}")
    st.write(f"Conference: {df_team_conference}")
    st.write(f"City: {df_team_city}")
    st.write(f"Home: {df_team_court}")
    st.write(f"Owner: {df_team_owner}")
    st.write(f"Coach: {df_team_coach}")

    sql_statistics_from_team_year = f"""select P.name, S.season, S.gp, S.gs, S.min, S.pts, S.oreb, S.dr, S.reb, S.ast, S.stl, S.blk, S.tuov, S.pf, S.ast_tuov, S.per
    from statistics S, players P
    where S.season = {season_selected}
    and S.pid = P.pid and S.pid in (select pid from plays_in_team PT
                                    where PT.year = {season_selected}
                                    and PT.tid in (select tid from Teams T
                                    where T.name = '{team_selected}'));"""
    st.markdown('**Player Information**')
    df_player_table = query_db(sql_statistics_from_team_year)
    st.dataframe(df_player_table)

'## Season Award List'

'### Select a season'
years = query_db('select year from years')['year'].tolist()
year_selected = st.selectbox('Select a season', years)

'### MVP'
if year_selected:
    sql_mvp_table = f"select P.name, S.gp, S.gs, S.min, S.pts, S.oreb, S.dr, S.reb, S.ast, S.stl, S.blk, S.tuov, S.pf, S.ast_tuov, S.per from players as P, statistics as S where P.pid = S.pid and S.season={year_selected} and S.gp >= 50 order by (S.pts * 0.3 + S.reb * 0.2 + S.ast * 0.2 + S.stl * 0.1 + S.blk * 0.1) desc limit 1;"
    df_mvp_table = query_db(sql_mvp_table)
    st.dataframe(df_mvp_table)

'### Top-10 Players'
if season_selected:
    sql_top_table = f"select P.name, S.pts, S.reb, S.ast, S.stl, S.blk from players as P, statistics as S where P.pid = S.pid and S.season={year_selected} and S.gp >= 50 order by S.pts desc, S.reb desc, S.ast desc, S.stl desc, S.blk desc limit 10;"
    df_top_table = query_db(sql_top_table)
    st.dataframe(df_top_table)

'### Statistics Leaders'
max_stat_list = ('pts', 'oreb', 'dr', 'reb', 'ast','stl', 'blk', 'tuov', 'pf', 'ast_tuov')
max_stat_selected = st.selectbox('select the specific statistic you want to see', max_stat_list)
if year_selected and max_stat_selected:
    sql_leader_table = f"select P.name, S.{max_stat_selected} from players as P, statistics as S where P.pid = S.pid and S.season={year_selected} and S.gp >= 50 order by S.{max_stat_selected} desc limit 10;"
    df_leader_table = query_db(sql_leader_table)
    st.dataframe(df_leader_table)
    
'### All Star Team'
if year_selected:
    sql_max_pts_by_position = f"select P1.name, P1.pos as position, S1.pts from players P1, statistics S1 where S1.season = {year_selected} and P1.pid = S1.pid and S1.pts in (select MAX(S.pts) from players P, statistics S, Positions PS where S.season = {year_selected} and PS.name = P.pos and P.pid = S.pid group by PS.name);"
    df_max_pts_by_position = query_db(sql_max_pts_by_position)
    st.dataframe(df_max_pts_by_position)
    
'### Best Scorer By Conference'
if year_selected:
    sql_max_pts_by_conference = f"""select T.conference_name as conference, T.name as team, S.pts, P.name
        from players P, statistics S, plays_in_team PT, teams T
        where S.season = {year_selected}
        and PT.year = {year_selected}
        and PT.tid = T.tid
        and PT.pid = P.pid
        and P.pid = S.pid
        and S.pts in (select MAX(S.pts)
            from players P, statistics S, conferences C, plays_in_team PT, years Y, teams T
            where S.season = {year_selected}
            and Y.year = {year_selected}
            and PT.tid = T.tid
            and PT.pid = P.pid
            and P.pid = S.pid
            and C.name = T.conference_name
            group by C.name);"""
    df_max_pts_by_conference  =query_db(sql_max_pts_by_conference)
    st.dataframe(df_max_pts_by_conference)


'## Single Player Look-up'

"### Career Best"
player_name_input = st.text_input("Type player's name", 'Aaron Gordon')
stats_selected = st.radio("Choose the statistic you want to see", ('Points', 'Rebounds', 'Assists', 'Steals', 'Blocks'))
if player_name_input and stats_selected:
    if stats_selected == 'Points':
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
        st.write(f"Highest **points** in **{player_name_input}**'s career is **{player_max_pts}**.")
    elif stats_selected == 'Rebounds':
        sql_max_reb_from_player = f"""
        select MAX(reb) maxreb, P.name
        from statistics S, players P
        where S.pid = P.pid
        and P.pid in (select P1.pid from players P1
                    where P1.name = '{player_name_input}'
        )
        group by P.name;
        """
        player_max_reb = query_db(sql_max_reb_from_player).loc[0]['maxreb']
        st.write(f"Highest **rebounds** in **{player_name_input}**'s career is **{player_max_reb}**.")
    elif stats_selected == 'Assists':
        sql_max_ast_from_player = f"""
        select MAX(ast) maxast, P.name
        from statistics S, players P
        where S.pid = P.pid
        and P.pid in (select P1.pid from players P1
                    where P1.name = '{player_name_input}'
        )
        group by P.name;
        """
        player_max_ast = query_db(sql_max_ast_from_player).loc[0]['maxast']
        st.write(f"Highest **assists** in **{player_name_input}**'s career is **{player_max_ast}**.")
    elif stats_selected == 'Steals':
        sql_max_stl_from_player = f"""
        select MAX(stl) maxstl, P.name
        from statistics S, players P
        where S.pid = P.pid
        and P.pid in (select P1.pid from players P1
                    where P1.name = '{player_name_input}'
        )
        group by P.name;
        """
        player_max_stl = query_db(sql_max_stl_from_player).loc[0]['maxstl']
        st.write(f"Highest **steals** in **{player_name_input}**'s career is **{player_max_stl}**.")
    else:
        sql_max_blk_from_player = f"""
        select MAX(blk) maxblk, P.name
        from statistics S, players P
        where S.pid = P.pid
        and P.pid in (select P1.pid from players P1
                    where P1.name = '{player_name_input}'
        )
        group by P.name;
        """
        player_max_blk = query_db(sql_max_blk_from_player).loc[0]['maxblk']
        st.write(f"Highest **blocks** in **{player_name_input}**'s career is **{player_max_blk}**.")
