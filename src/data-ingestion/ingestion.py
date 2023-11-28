# Title: Data Ingestion

# Notes:
    #* Description
        #** Python script to execute DuckDB sql commands for data ingestion and cleaning
    #* Updated
        #** 2023-11-20
        #** dcr

# Load libraries
import duckdb as db
import pandas as pd
# Connect to database
con = db.connect("./data/clean/project-data.db")

# 2012 ANES
    #* Extract data and place in DB
df = pd.read_stata('./data/original/anes_2012/anes-2012.dta', convert_categoricals=False)
con.execute(
    '''
        CREATE OR REPLACE TABLE
            Original12
        AS
            (
                SELECT
                    *
                FROM
                    df
            );
    '''
)
del df
    #* Data transformation
con.execute(
    '''
    CREATE OR REPLACE VIEW
        Temp12
    AS
        (
            SELECT
                caseid AS CaseID,
                weight_full AS Weight,
                /* wid - White Identity
                    CODED AS: ident_whiteid - 1 = Extremely important TO 5 = Not at all important, < 1 = NULL
                    CODED TO: wid - 1 = Not at all important TO 5 = Extremely important, NULL
                */
                (
                    CASE
                        WHEN ident_whiteid == 5 THEN 1
                        WHEN ident_whiteid == 4 THEN 2
                        WHEN ident_whiteid == 3 THEN 3
                        WHEN ident_whiteid == 2 THEN 4
                        WHEN ident_whiteid == 1 THEN 5
                        ELSE NULL
                    END
                ) AS wid,
                /* rboff - Retrospective better off
                    CODED AS: finance_finpast_x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                    CODED TO: rboff - -2 = Much worse TO 2 = Much better, NULL
                */
                (
                    CASE
                        WHEN finance_finpast_x == 5 THEN -2
                        WHEN finance_finpast_x == 4 THEN -1
                        WHEN finance_finpast_x == 3 THEN 0
                        WHEN finance_finpast_x == 2 THEN 1
                        WHEN finance_finpast_x == 1 THEN 2
                        ELSE NULL
                    END
                ) AS rboff,
                /* epast - Economy better/worse than 1 year ago
                    CODED AS: econ_ecpast_x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                    CODED TO: epast - -2 = Much worse TO 2 = Much better, NULL
                */
                (
                    CASE
                        WHEN econ_ecpast_x == 5 THEN -2
                        WHEN econ_ecpast_x == 4 THEN -1
                        WHEN econ_ecpast_x == 3 THEN 0
                        WHEN econ_ecpast_x == 2 THEN 1
                        WHEN econ_ecpast_x == 1 THEN 2
                        ELSE NULL
                    END
                ) AS epast,
                /* unpast - Unemployment better/worse than 1 year ago
                    CODED AS: econ_unpast_x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                    CODED TO: unpast - -2 = Much worse TO 2 = Much better, NULL
                */
                (
                    CASE
                        WHEN econ_unpast_x == 5 THEN -2
                        WHEN econ_unpast_x == 4 THEN -1
                        WHEN econ_unpast_x == 3 THEN 0
                        WHEN econ_unpast_x == 2 THEN 1
                        WHEN econ_unpast_x == 1 THEN 2
                        ELSE NULL
                    END
                ) AS unpast,
                /* edu - Education
                    CODED AS: dem_edugroup_x - 1 = < highschool, 2 = hs, 3 = some post-hs, 4 = BA/BS, 5 = Graduate, < 1 = NULL
                    CODED TO: edu - 1 = < highschool, 2 = hs, 3 = some post-hs, 4 = BS/BA, 5 = Graduate, NULL
                */
                (
                    CASE
                        WHEN dem_edugroup_x >= 1 AND dem_edugroup_x <= 5 THEN dem_edugroup_x
                        ELSE NULL
                    END
                ) AS edu,
                /* income - Income
                    CODED AS: incgroup_prepost_x - < 1 = NULL, > 1 = See codebook
                    CODED TO: NULL, != NULL then see codebook
                */
                (
                    CASE
                        WHEN incgroup_prepost_x <= 0 THEN NULL
                        ELSE incgroup_prepost_x
                    END
                ) as income,
                /* losejob - Worried about losing job
                    CODED AS: dem_losejob - 1 = Not at all TO 5 = Extremely worried, < 1 = NULL
                    CODED TO: losejob - -2 = Extremely worried TO 2 = Not at all, NULL
                */
                (
                    CASE
                        WHEN dem_losejob == 5 THEN -2
                        WHEN dem_losejob == 4 THEN -1
                        WHEN dem_losejob == 3 THEN 0
                        WHEN dem_losejob == 2 THEN 1
                        WHEN dem_losejob == 1 THEN 2
                    END
                ) AS losejob,
                /* immtakejobs - How likely immigrants take jobs
                    CODED AS: immigpo_jobs - 1 = Extremely TO 4 = Not at all, < 1 = NULL
                    CODED TO: immtakejobs - 1 = Extremely TO 4 = Not at all, NULL
                */
                (
                    CASE 
                        WHEN immigpo_jobs >= 1 AND immigpo_jobs <= 4 THEN immigpo_jobs
                        ELSE NULL 
                    END
                ) AS immtakejobs,
                /* ecfamily - Worried about family finances
                    CODED AS: ecperil_worry - 1 = Extremely TO 5 = Not at all, < 1 = NULL
                    CODED TO: ecfamily - -2 = Not at all TO 2 = Extremely, NULL
                */
                (
                    CASE
                        WHEN ecperil_worry == 5 THEN -2
                        WHEN ecperil_worry == 4 THEN -1
                        WHEN ecperil_worry == 3 THEN 0
                        WHEN ecperil_worry == 2 THEN 1
                        WHEN ecperil_worry == 1 THEN 2
                        ELSE NULL
                    END
                ) AS ecfamily,
                /* ecjob - Know someone who lost job
                    CODED AS: ecperil_lostjobs - 1 = someone lost job, 2 = No one lost job, < 1 = NULL
                    CODED TO: ecjob - 0 = No one lost job, 1 = Someone lost job, NULL
                */
                (
                    CASE
                        WHEN ecperil_lostjobs == 2 THEN 0
                        WHEN ecperil_lostjobs == 1 THEN 1
                        ELSE NULL
                    END
                ) AS ecjob,
                /* tradbreak - New lifestyles breaking society
                    CODED AS: trad_lifestyle - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                    CODED TO: tradbreak - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                */
                (
                    CASE
                        WHEN trad_lifestyle == 5 THEN -2
                        WHEN trad_lifestyle == 4 THEN -1
                        WHEN trad_lifestyle == 3 THEN 0
                        WHEN trad_lifestyle == 2 THEN 1
                        WHEN trad_lifestyle == 1 THEN 2
                        ELSE NULL
                    END
                ) AS tradbreak,
                /* govbias - Government is biased against whites
                    CODED AS: nonmain_bias - 1 = Favors whites, 2 = Favors Blacks, 3 = Neither, < 1 = NULL
                    CODED TO: govbias - -1 = Favors blacks, 0 = Neither, 1 = Favors whites, NULL
                */
                (
                    CASE
                        WHEN nonmain_bias == 2 THEN -1
                        WHEN nonmain_bias == 3 THEN 0
                        WHEN nonmain_bias == 1 THEN 1
                        ELSE NULL
                    END
                ) AS govbias,
                /* inflwhite - Influence Whites have on politics
                    CODED AS: racecasi_infwhite - 1 = Too much, 2 = Just about right, 3 = Too little, < 1 = NULL
                    CODED TO: inflwhite - -1 = Too little, 0 = Just about right, 1 = Too much, NULL
                */
                (
                    CASE
                        WHEN racecasi_infwhite == 3 THEN -1
                        WHEN racecasi_infwhite == 2 THEN 0
                        WHEN racecasi_infwhite == 1 THEN 1
                        ELSE NULL
                    END
                ) AS inflwhite,
                /* whitediscrim - Whites are discriminated against
                    CODED AS: discrim_whites - 1 = Strongly agree TO 5 = Strongly Disagree, < 1 = NULL
                    CODED TO: whitediscrim - -2 = Strongly Disagree TO 2 = Strongly Agree, NULL
                */
                (
                    CASE
                        WHEN discrim_whites == 5 THEN -2
                        WHEN discrim_whites == 4 THEN -1
                        WHEN discrim_whites == 3 THEN 0
                        WHEN discrim_whites == 2 THEN -1
                        WHEN discrim_whites == 1 THEN 2
                        ELSE NULL
                    END
                ) AS whitediscrim,
                /* resentworkway - Blacks should work way up
                    CODED AS: resent_workway - 1 = Strongly agree TO 5 = Strongly Disagree, < 1 = NULL
                    CODED TO: resentworkway - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                */
                (
                    CASE
                        WHEN resent_workway == 5 THEN -2
                        WHEN resent_workway == 4 THEN -1
                        WHEN resent_workway == 3 THEN 0
                        WHEN resent_workway == 2 THEN 1
                        WHEN resent_workway == 1 THEN 2
                        ELSE NULL
                    END
                ) AS resentworkway,
                /* resentslavery - Slavery makes it difficult for Blacks
                    CODED AS: resent_slavery - 1 = Strongly agree TO 5 = Strongly Disagree, < 1 = NULL
                    CODED TO: resentslavery - -2 = Strongly agree TO 2 = Strongly disagree, NULL
                */
                (
                    CASE
                        WHEN resent_slavery == 5 THEN 2
                        WHEN resent_slavery == 4 THEN 1
                        WHEN resent_slavery == 3 THEN 0
                        WHEN resent_slavery == 2 THEN -1
                        WHEN resent_slavery == 1 THEN -2
                        ELSE NULL
                    END
                ) AS resentslavery,
                /* resentdeserve - Blacks have gotten less than they deserve
                    CODED AS: resent_deserve - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                    CODED TO: resentdeserve - -2 = Strongly agree TO 2 = Strongly disagree, NULL
                */
                (
                    CASE
                        WHEN resent_deserve == 5 THEN 2
                        WHEN resent_deserve == 4 THEN 1
                        WHEN resent_deserve == 3 THEN 0
                        WHEN resent_deserve == 2 THEN -1
                        WHEN resent_deserve == 1 THEN -2
                        ELSE NULL
                    END
                ) AS resentdeserve,
                /* resenttryhard - Blacks should try harder to get ahead
                    CODED AS: resent_try - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                    CODED TO: resenttryhard - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                */
                (
                    CASE
                        WHEN resent_try == 5 THEN -2
                        WHEN resent_try == 4 THEN -1
                        WHEN resent_try == 3 THEN 0
                        WHEN resent_try == 2 THEN 1
                        WHEN resent_try == 1 THEN 2
                        ELSE NULL
                    END
                ) AS resenttryhard,
                /* pid - Party Identification
                    CODED AS: pid_x - 1 = Strong Democrat TO 7 = Strong Republican, < 1 = NULL
                    CODED TO: pid - 1 = Strong Democrat TO 7 = Strong Republican, NULL
                */
                (
                    CASE 
                        WHEN pid_x >= 1 AND pid_x <= 7 THEN pid_x
                        ELSE NULL
                    END
                ) AS pid,
                /* female - Female
                    CODED AS: gender_respondent_x - 1 = Male, 2 = Female, < 1 = NULL
                    CODED TO: female - 0 = Male, 1 = Female, NULL
                */
                (
                    CASE
                        WHEN gender_respondent_x == 1 THEN 0
                        WHEN gender_respondent_x == 2 THEN 1
                        ELSE NULL
                    END
                ) AS female
            FROM
                Original12
            WHERE
                dem_raceeth_x == 1
        );
    
    CREATE OR REPLACE TABLE
        Clean12
    AS
        (
            SELECT
                Temp12.*,
                /* raceresent - Racial resentment
                    CODED TO: Average of resentworkway, resentslavery, resentdeserve, resenttryhard
                */
                (
                    CASE
                        WHEN 
                            resentworkway IS NOT NULL 
                            AND resentslavery IS NOT NULL 
                            AND resentdeserve IS NOT NULL 
                            AND resenttryhard IS NOT NULL 
                        THEN
                            (resentworkway + resentslavery + resentdeserve + resenttryhard)/4
                        ELSE
                            NULL
                    END
                ) AS raceresent
            FROM
                Temp12
        );

    ALTER TABLE
        Clean12
        DROP COLUMN resentworkway;

    ALTER TABLE
        Clean12
        DROP COLUMN resentslavery;
        
    ALTER TABLE
        Clean12
        DROP COLUMN resentdeserve;
        
    ALTER TABLE
        Clean12
        DROP COLUMN resenttryhard;

    DROP VIEW Temp12;
    '''
)

# 2016 ANES
    #* Extract data and place in DB
df = pd.read_stata('./data/original/anes_2016/anes-2016.dta', convert_categoricals=False)
con.execute(
    '''
        CREATE OR REPLACE TABLE
            Original16
        AS 
            (
                SELECT
                    *
                FROM
                    df
            );
    '''
)
del df
    #* Data transformation
con.execute(
    '''
        CREATE OR REPLACE VIEW
            Temp16
        AS
            (
                SELECT
                    V160001 AS CaseID,
                    V160102 AS Weight,
                    /* wid - White Identity
                        CODED AS: V162327 - 1 = Extremely Important TO 5 = Not at all important < 1 = NULL
                        CODED TO: wid - 1 = Not at all important TO 5 = Extremely important, NULL
                    */
                    (
                        CASE
                            WHEN V162327 == 5 THEN 1
                            WHEN V162327 == 4 THEN 2
                            WHEN V162327 == 3 THEN 3
                            WHEN V162327 == 2 THEN 4
                            WHEN V162327 == 1 THEN 5
                            ELSE NULL
                        END
                    ) AS wid,
                    /* rboff - Retrospective better off
                        CODED AS: V161110 - 1 = Much better TO 5 = Much worse, < 1 = NULL
                        CODED TO: rboff - -2 = Much worse TO 2 = Much better, NULL
                    */
                    (
                        CASE
                            WHEN V161110 == 5 THEN -2
                            WHEN V161110 == 4 THEN -1
                            WHEN V161110 == 3 THEN 0
                            WHEN V161110 == 2 THEN 1
                            WHEN V161110 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS rboff,
                    /* epast - Economy better/worse than 1 year ago
                        CODED AS: V161140x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                        CODED TO: epast - -2 = Much worse TO 2 = Much better, NULL
                    */
                    (
                        CASE
                            WHEN V161140x == 5 THEN -2
                            WHEN V161140x == 4 THEN -1
                            WHEN V161140x == 3 THEN 0
                            WHEN V161140x == 2 THEN 1
                            WHEN V161140x == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS epast,
                    /* unpast - Unemployment better/worse than 1 year ago
                        CODED AS: V161142x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                        CODED TO: unpast - -2 = Much worse TO 2 = Much better, NULL
                    */
                    (
                        CASE
                            WHEN V161142x == 5 THEN -2
                            WHEN V161142x == 4 THEN -1
                            WHEN V161142x == 3 THEN 0
                            WHEN V161142x == 2 THEN 1
                            WHEN V161142x == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS unpast,
                    /* edu - Education
                        CODED AS: V161270 - 1 = < high school TO 16 = Doctorate, < 1 = NULL
                        CODED TO: edu - 1 = < high school TO 16 = Doctorate, NULL
                    */
                    (
                        CASE
                            WHEN V161270 >= 1 AND V161270 <= 16 THEN V161270
                            ELSE NULL
                        END
                    ) AS edu,
                    /* income - Income
                        CODED AS: V161361x - < 1 = NULL, See codebook for others
                        CODED TO: income - NULL, See codebook for other values
                    */
                    (
                        CASE
                            WHEN V161361x <= 0 THEN NULL
                            ELSE V161361x
                        END
                    ) AS income,
                    /* losejob - Worried about losing job
                        CODED AS: V161297 - 1 = Not at all TO 5 = Extremely worried, < 1 = NULL
                        CODED TO: losejob - -2 = Extremely worried TO 2 = Not at all, NULL
                    */
                    (
                        CASE
                            WHEN V161297 == 5 THEN -2
                            WHEN V161297 == 4 THEN -1
                            WHEN V161297 == 3 THEN 0
                            WHEN V161297 == 2 THEN 1
                            WHEN V161297 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS losejob,
                    /* immtakejobs - How likely Immigrants take jobs
                        CODED AS: V162158 - 1 = Extremely TO 4 = Not at all, < 1 = NULL
                        CODED TO: immtakejobs - 1 = Extremely TO 4 = Not at all, NULL
                    */
                    (
                        CASE
                            WHEN V162158 >= 1 AND V162158 <= 4 THEN V162158
                            ELSE NULL
                        END
                    ) AS immtakejobs,
                    /* ecfamily - Worried about family finances
                        CODED AS: V162165 - 1 = Extremely TO 5 = Not at all, < 1 = NULL
                        CODED TO: ecfamily - -2 = Not at all, 2 = Extremely, NULL
                    */
                    (
                        CASE
                            WHEN V162165 == 5 THEN -2
                            WHEN V162165 == 4 THEN -1
                            WHEN V162165 == 3 THEN 0
                            WHEN V162165 == 2 THEN 1
                            WHEN V162165 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS ecfamily,
                    /* ecjob - Know someone who lost job
                        CODED AS: V162167 - 1 = Someone lost job, No one lost job, < 1 = NULL
                        CODED TO: ecjob - 0 = No one lost job, 1 = Someone lost job, NULL
                    */
                    (
                        CASE
                            WHEN V162167 == 2 THEN 0
                            WHEN V162167 == 1 THEN 1
                            ELSE NULL
                        END
                    ) AS ecjob,
                    /* tradbreak - New lifestyles breaking society
                        CODED AS: V162208 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: tradbreak - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V162208 == 5 THEN -2
                            WHEN V162208 == 4 THEN -1
                            WHEN V162208 == 3 THEN 0
                            WHEN V162208 == 2 THEN 1
                            WHEN V162208 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS tradbreak,
                    /* govbias - Government biased against whites
                        CODED AS: V162318 - 1 = Favors whites, 2 = Favors blacks, 3 = Neither, < 1 = NULL
                        CODED TO: govbias - -1 = Favors blacks, 0 = Neither, 1 = Favors whites, NULL
                    */
                    (
                        CASE
                            WHEN V162318 == 2 THEN -1
                            WHEN V162318 == 3 THEN 0
                            WHEN V162318 == 1 THEN 1
                            ELSE NULL
                        END
                    ) AS govbias,
                    /* inflwhite - Influence whites have on politics
                        CODED AS: V162322 - 1 = Too much, 2 = Just about right, 3 = Too little, < 1 = NULL
                        CODED TO: inflwhite - -1 = Too little, 0 = Just about right, 1 = Too much, NULL
                    */
                    (
                        CASE
                            WHEN V162322 == 3 THEN -1
                            WHEN V162322 == 2 THEN 0
                            WHEN V162322 == 1 THEN 1
                            ELSE NULL
                        END
                    ) as inflwhite,
                    /* whitediscrim - Whites are discriminated against
                        CODED AS: V162360 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: whitediscrim - -2 = Strongly disagree TO 2 = Strongly Agree, NULL
                    */
                    (
                        CASE
                            WHEN V162360 == 5 THEN -2
                            WHEN V162360 == 4 THEN -1
                            WHEN V162360 == 3 THEN 0
                            WHEN V162360 == 2 THEN 1
                            WHEN V162360 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS whitediscrim,
                    /* resentworkway - Blacks should work way up
                        CODED AS: V162211 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resentworkway - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V162211 == 5 THEN -2
                            WHEN V162211 == 4 THEN -1
                            WHEN V162211 == 3 THEN 0
                            WHEN V162211 == 2 THEN 1
                            WHEN V162211 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS resentworkway,
                    /* resentslavery - Slavery makes it difficult for blacks
                        CODED AS: V162212 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resentslavery - -2 = Strongly agree TO 2 = Strongly disagree, NULL
                    */
                    (
                        CASE
                            WHEN V162212 == 5 THEN 2
                            WHEN V162212 == 4 THEN 1 
                            WHEN V162212 == 3 THEN 0
                            WHEN V162212 == 2 THEN -1
                            WHEN V162212 == 1 THEN -2
                            ELSE NULL
                        END
                    ) AS resentslavery,
                    /* resentdeserve - Blacks have gotten less than they deserve
                        CODED AS: V162213 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resentdeserve - -2 = Strongly agree TO 2 = Strongly disagree, NULL
                    */
                    (
                        CASE
                            WHEN V162213 == 5 THEN 2
                            WHEN V162213 == 4 THEN 1
                            WHEN V162213 == 3 THEN 0
                            WHEN V162213 == 2 THEN -1
                            WHEN V162213 == 1 THEN -2
                            ELSE NULL
                        END
                    ) AS resentdeserve,
                    /* resenttryhard - Blacks should try harder to get ahead
                        CODED AS: V162214 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resenttryhard - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V162214 == 5 THEN -2
                            WHEN V162214 == 4 THEN -1
                            WHEN V162214 == 3 THEN 0
                            WHEN V162214 == 2 THEN 1
                            WHEN V162214 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS resenttryhard,
                    /* pid - Party Identification
                        CODED AS: V161158x - 1 = Strong Democrat TO 7 = Strong Republican, < 1 = NULL
                        CODED TO: pid - 1 = Strong Democrat TO 7 = Strong Republican, NULL
                    */
                    (
                        CASE
                            WHEN V161158x >= 1 AND V161158x <= 7 THEN V161158x
                            ELSE NULL
                        END
                    ) AS pid,
                    /* female - Female
                        CODED AS: V161342 - 1 = Male, 2 = Female, < 1 = NULL
                        CODED TO: female - 0 = Male, 1 = Female, NULL
                    */
                    (
                        CASE
                            WHEN V161342 == 1 THEN 0
                            WHEN V161342 == 2 THEN 1
                            ELSE NULL
                        END
                    ) AS female
                FROM
                    Original16
                WHERE
                    V161310x == 1
            );
    
    CREATE OR REPLACE TABLE
        Clean16
    AS
        (
            SELECT Temp16.*,
            /* raceresent - Racial resentment
                CODED TO: Average of resentworkway, resentslavery, resentdeserve, resenttryhard
            */
            (
                CASE
                    WHEN 
                        resentworkway IS NOT NULL
                        AND resentslavery IS NOT NULL
                        AND resentdeserve IS NOT NULL
                        AND resenttryhard IS NOT NULL
                    THEN
                        (resentworkway + resentslavery + resentdeserve + resenttryhard)/4
                    ELSE
                        NULL
                END
            ) AS raceresent
            FROM
                Temp16
        );

    ALTER TABLE
        Clean16
        DROP COLUMN resentworkway;

    ALTER TABLE
        Clean16
        DROP COLUMN resentslavery;
        
    ALTER TABLE
        Clean16
        DROP COLUMN resentdeserve;
        
    ALTER TABLE
        Clean16
        DROP COLUMN resenttryhard;
    
    DROP View Temp16;
    '''
)
# 2020 ANES
    #* Extract data and place in DB
df = pd.read_stata('./data/original/anes_2020/anes_2020_original.dta', convert_categoricals=False)
con.execute(
    '''
        CREATE OR REPLACE TABLE
            Original20
        AS
            (
                SELECT
                    *
                FROM
                    df
            );
    '''
)
del df
    #* Data transformation
con.execute(
    '''
        CREATE OR REPLACE VIEW
            Temp20
        AS
            (
                SELECT
                    V200001 AS CaseID,
                    V200010a AS Weight,
                    /* wid - White Identity
                        CODED AS: V202499x - 1 = Extremely Important TO 5 = Not at all important, < 1 = NULL
                        CODED TO: wid - 1 = Not at all important TO 5 = Extremely Important, NULL
                    */
                    (
                        CASE
                            WHEN V202499x == 5 THEN 1
                            WHEN V202499x == 4 THEN 2
                            WHEN V202499x == 3 THEN 3
                            WHEN V202499x == 2 THEN 4
                            WHEN V202499x == 1 THEN 5
                            ELSE NULL
                        END
                    ) AS wid,
                    /* rboff - Retrospective better off
                        CODED AS: V201502 - 1 = Much better TO 5 = Much worse, < 1 = NULL
                        CODED TO: rboff - -2 = Much worse TO 2 = Much better, NULL
                    */
                    (
                        CASE
                            WHEN V201502 == 5 THEN -2
                            WHEN V201502 == 4 THEN -1
                            WHEN V201502 == 3 THEN 0
                            WHEN V201502 == 2 THEN 1
                            WHEN V201502 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS rboff,
                    /* epast - Economy better/worse than 1 year ago
                        CODED AS: V201327x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                        CODED TO: epast - -2 = Much worse TO 2 = Much better, NULL
                    */
                    (
                        CASE
                            WHEN V201327x == 5 THEN -2
                            WHEN V201327x == 4 THEN -1
                            WHEN V201327x == 3 THEN 0
                            WHEN V201327x == 2 THEN 1
                            WHEN V201327x == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS epast,
                    /* unpast - Unemployment better/wose than 1 year ago
                        CODED AS: V201333x - 1 = Much better TO 5 = Much worse, < 1 = NULL
                        CODED TO: unpast - -2 = Much worse TO 2 = Much better, NULL
                    */
                    (
                        CASE
                            WHEN V201333x == 5 THEN -2
                            WHEN V201333x == 4 THEN -1
                            WHEN V201333x == 3 THEN 0
                            WHEN V201333x == 2 THEN 1
                            WHEN V201333x == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS unpast,
                    /* edu - Education
                        CODED AS: V201511x - 1 = < high school, 2 = hs, 3 = some post-his, 4 = BS/BA, 5 = graduate, NULL
                        CODED TO: edu - 1 = < hs, 2 = hs, 3 = some post-hs, 4 = BS/BA, 5 = graduate, NULL
                    */
                    (
                        CASE
                            WHEN V201511x >= 1 AND V201511x <= 5 THEN V201511x
                            ELSE NULL
                        END
                    ) AS edu,
                    /* income - Income
                        CODED AS: V202468x - NULL = < 1, See codebook for other values
                        CODED TO: income - NULL, See codebook for other values
                    */
                    (
                        CASE
                            WHEN V202468x <= 0 THEN NULL
                            ELSE V202468x
                        END
                    ) AS income,
                    /* losejob - Worried about losing job
                        CODED AS: V201540 - 1 = Not at all TO 5 = Extremely worried, < 1 = NULL
                        CODED TO: losejob - -2 = Extremely worried TO 2 = Not at all, NULL
                    */
                    (
                        CASE
                            WHEN V201540 == 5 THEN -2
                            WHEN V201540 == 4 THEN -1
                            WHEN V201540 == 3 THEN 0
                            WHEN V201540 == 2 THEN 1
                            WHEN V201540 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS losejob,
                    /* immtakejobs - How likely immigrants take jobs
                        CODED AS: V202233 - 1 = Extremely TO 4 = Not at all, < 1 = NULL
                        CODED TO: immtakejobs 1 = Extremely TO 4 = Not at all, NULL
                    */
                    (
                        CASE
                            WHEN V202233 >= 1 AND V202233 <= 4 THEN V202233
                            ELSE NULL
                        END
                    ) AS immtakejobs,
                    /* ecfamily - Worried about family finances
                        CODED AS: V201594 - 1 = Extremely TO 5 = Not at all, < 1 = NULL
                        CODED TO: ecfamily - -2 = Not at all TO 2 = Extremely, NULL
                    */
                    (
                        CASE
                            WHEN V201594 == 5 THEN -2
                            WHEN V201594 == 4 THEN -1
                            WHEN V201594 == 3 THEN 0
                            WHEN V201594 == 2 THEN 1
                            WHEN V201594 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS ecfamily,
                    /* ecjob - Know someone who lost job
                        CODED AS: V202488 - 1 = Someone lost job, 2 = No one lost job, < 1 = NULL
                        CODED TO: ecjob - 0 = No one lost job, 1 = Someone lost job, NULL
                    */
                    (
                        CASE 
                            WHEN V202488 == 2 THEN 0
                            WHEN V202488 == 1 THEN 1
                            ELSE NULL
                        END
                    ) AS ecjob,
                    /* govbias - Government biased against whites
                        CODED AS: V202488 - 1 = Favors whites, 2 = Favors blacks, 3 = Neither, < 1 = NULL
                        CODED TO: govbias - -1 = Favors blacks, 0 = Neither, 1 = Favors whites, NULL
                    */
                    (
                        CASE
                            WHEN V202488 == 2 THEN -1
                            WHEN V202488 == 3 THEN 0
                            WHEN V202488 == 1 THEN 1
                            ELSE NULL
                        END
                    ) AS govbias,
                    /* inflwhite - Influence whites have on politics
                        CODED AS: V202494 - 1 = Too much, 2 = Just about right, 3 = Too little, < 1 = NULL
                        CODED TO: inflwhite - -1 = Too little, 0 = Just about right, 1 = Too much, NULL
                    */
                    (
                        CASE
                            WHEN V202494 == 3 THEN -1
                            WHEN V202494 == 2 THEN 0
                            WHEN V202494 == 1 THEN 1
                            ELSE NULL
                        END
                    ) AS inflwhite,
                    /* whitediscrim - Whites are discriminated against
                        CODED AS: V202530 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: whitediscrim - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V202530 == 5 THEN -2
                            WHEN V202530 == 4 THEN -1
                            WHEN V202530 == 3 THEN 0
                            WHEN V202530 == 2 THEN 1
                            WHEN V202530 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS whitediscrim,
                    /* resentworkway - Blacks should work way up
                        CODED AS: V202300 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resentworkway - -2 = Strongly dissagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V202300 == 5 THEN -2
                            WHEN V202300 == 4 THEN -1
                            WHEN V202300 == 3 THEN 0
                            WHEN V202300 == 2 THEN 1
                            WHEN V202300 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS resentworkway,
                    /* resentslavery - Slavery makes it difficult for Blacks
                        CODED AS: V202301 - 1 = Strongly agree TO 5 = Strongly Disagree, < 1 = NULL
                        CODED TO: resentslavery - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V202301 == 5 THEN 2
                            WHEN V202301 == 4 THEN 1
                            WHEN V202301 == 3 THEN 0
                            WHEN V202301 == 2 THEN -1
                            WHEN V202301 == 1 THEN -2
                            ELSE NULL
                        END
                    ) AS resentslavery,
                    /* resenttryhard - Blacks should try harder to get ahead
                        CODED AS: V202303 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resenttryhard - -2 = Strongly disagree TO 2 = Strongly agree, NULL
                    */
                    (
                        CASE
                            WHEN V202303 == 5 THEN -2
                            WHEN V202303 == 4 THEN -1
                            WHEN V202303 == 3 THEN 0
                            WHEN V202303 == 2 THEN 1
                            WHEN V202303 == 1 THEN 2
                            ELSE NULL
                        END
                    ) AS resenttryhard,
                    /* resentdeserve - Blacks have gotten less than they deserve
                        CODED AS: V202302 - 1 = Strongly agree TO 5 = Strongly disagree, < 1 = NULL
                        CODED TO: resentdeserve - -2 = Strongly agree TO 5 = Strongly disagree, NULL
                    */
                    (
                        CASE
                            WHEN V202302 == 5 THEN 2
                            WHEN V202302 == 4 THEN 1
                            WHEN V202302 == 3 THEN 0
                            WHEN V202302 == 2 THEN -1
                            WHEN V202302 == 1 THEN -2
                            ELSE NULL
                        END
                    ) AS resentdeserve,
                    /* pid - Party Identification
                        CODED AS: V201231x - 1 = Strong Democrat TO 7 = Strong Republican, < 1 = NULL
                        CODED TO: pid - 1 = Strong Democrat TO 7 = Strong Republican, NULL
                    */
                    (
                        CASE
                            WHEN V201231x >= 1 AND V201231x <= 7 THEN V201231x
                            ELSE NULL
                        END
                    ) AS pid,
                    /* female - Female
                        CODED AS: V201600 - 1 = Male, 2 = Female, < 1 = NULL
                        CODED TO: female - 0 = male, 1 = female, NULL
                    */
                    (
                        CASE
                            WHEN V201600 == 1 THEN 0
                            WHEN V201600 == 2 THEN 1
                            ELSE NULL
                        END
                    ) AS female
                FROM
                    Original20
                WHERE
                    V201549x == 1
            );
        
        CREATE OR REPLACE TABLE
            Clean20
        AS
            (
                SELECT
                    Temp20.*,
                    /* raceresent - Racial resentment
                        CODED TO: Average of resentworkway, resentslavery, resentdeserve, resenttryhard
                    */
                    (
                        CASE
                            WHEN
                                resentworkway IS NOT NULL
                                AND resentslavery IS NOT NULL
                                AND resentdeserve IS NOT NULL
                                AND resenttryhard IS NOT NULL
                            THEN
                                (resentworkway + resentslavery + resentdeserve + resenttryhard)/4
                            ELSE
                                NULL
                        END
                    ) AS raceresent
                FROM
                    Temp20
            );

    ALTER TABLE
        Clean20
        DROP COLUMN resentworkway;

    ALTER TABLE
        Clean20
        DROP COLUMN resentslavery;
        
    ALTER TABLE
        Clean20
        DROP COLUMN resentdeserve;
        
    ALTER TABLE
        Clean20
        DROP COLUMN resenttryhard;

    DROP VIEW Temp20;
    '''
)

# Close DB connection
con.close()

# Print message
print("\nData ingestion successful!\n")