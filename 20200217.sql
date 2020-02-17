:dt ==> 202002

SELECT DECODE(d,1,iw+1,iw) iw,
       MIN(DECODE(d,1,dt)) sun,
       MIN(DECODE(d,2,dt)) mon,
       MIN(DECODE(d,3,dt)) tue,
       MIN(DECODE(d,4,dt)) wed,
       MIN(DECODE(d,5,dt)) tur,
       MIN(DECODE(d,6,dt)) fri,
       MIN(DECODE(d,7,dt)) sat
FROM
(SELECT TO_DATE(:dt, 'yyyymm')-3 + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')-3 + (LEVEL-1),'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')-3 + (LEVEL-1),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'DD') +TO_CHAR(NEXT_DAY(TO_DATE(:dt, 'yyyymm'),1),'DD'))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY iw;

1. 해당 월의 1일자가 속한 주의 일요일 구하기
2. 해당 월의 마지막 일자가 속한 주의 토요일 구하기
3. 2-1을 하여 총 일수 구하기


SELECT DECODE(d,1,iw+1,iw) iw,
       MIN(DECODE(d,1,dt)) sun,
       MIN(DECODE(d,2,dt)) mon,
       MIN(DECODE(d,3,dt)) tue,
       MIN(DECODE(d,4,dt)) wed,
       MIN(DECODE(d,5,dt)) tur,
       MIN(DECODE(d,6,dt)) fri,
       MIN(DECODE(d,7,dt)) sat
FROM
(SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) + (LEVEL-1),'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) + (LEVEL-1),'iw') iw
FROM dual
CONNECT BY LEVEL <=  LAST_DAY(TO_DATE(:dt,'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D')) 
        -(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D'))))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY iw;


기존 : 시작일자 1일, 마지막 날짜 : 해당월의 마지막 일자
SELECT TO_DATE('202002','YYYYMM') +(LEVEL-1)
FROM dual
CONNECT BY LEVEL <= 29;

 변경 : 시작일자 : 해당월의 1일자가 속한 주의 일요일
        마지막일자 : 해당월의 마지막 일자가 속한 주의 토요일
SELECT TO_DATE('20200126','YYYYMMDD') + LEVEL-1
FROM dual
CONNECT BY LEVEL <=35;

SELECT
    TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) st,
    LAST_DAY(TO_DATE(:dt,'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D')) ed,
    LAST_DAY(TO_DATE(:dt,'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D')) 
        -(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D'))) daycnt
FROM dual;        

create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


SELECT *
FROM sales;

--calendar1
SELECT MIN(DECODE(dt1,1, a)) JAN,
       MIN(DECODE(dt1,2, a)) FEB,
       NVL(MIN(DECODE(dt1,3, a)),0) MAR,
       MIN(DECODE(dt1,4, a)) APR,
       MIN(DECODE(dt1,5, a)) MAY,
       MIN(DECODE(dt1,6, a)) JUN
FROM(SELECT TO_CHAR(dt,'MM') dt1, sum(sales) a
     FROM sales
     GROUP BY TO_CHAR(dt,'MM'));
     
--1. dt(일자) ==> 월, 월단위별 sum(sales) ==> 월의 수만큼 행이 그룹핑 된다.
SELECT NVL(SUM(jan),0) jan, NVL(SUM(FEB),0),
       NVL(SUM(MAR),0), SUM(NVL(jan,0)),
       NVL(SUM(APR),0),NVL(SUM(MAY),0),
       NVL(SUM(JUN),0)
FROM
(SELECT DECODE(TO_CHAR(dt,'MM'), '01',SUM(sales)) JAN,
        DECODE(TO_CHAR(dt,'MM'), '02',SUM(sales)) FEB,
        DECODE(TO_CHAR(dt,'MM'), '03',SUM(sales)) MAR,
        DECODE(TO_CHAR(dt,'MM'), '04',SUM(sales)) APR,
        DECODE(TO_CHAR(dt,'MM'), '05',SUM(sales)) MAY,
        DECODE(TO_CHAR(dt,'MM'), '06',SUM(sales)) JUN
        FROM sales
        GROUP BY TO_CHAR(dt,'MM'));

--sum(nvl) 보다 nvl(sum)의 효율이 높음 왜냐하면 후자가 nvl이 한번만 실행되기 때문이다.

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;


--오라클 계층형 쿼리 문법
--SELECT..
--FROM ...
--WHERE
--START WITH 조건 : 어떤 행을 시작점으로 삼을지 
--CONNECT BY 행과 형을 연결하는 기준
--          PRIOR : 이미 읽은 행
--          "  "  : 앞으로 읽을 행
--
--하향식 : 상위에서 자식노드로 연결 (위 ==> 아래)
--
--XX회사(최상위 조직)에서 시작하여 하위 부서로 내려가는 계층쿼리

SELECT dept_h.* , LEVEL, LPAD(' ' , (LEVEL-1)*4, ' ')||deptnm
FROM dept_h
START WITH DEPTCD = 'dept0'
--START WITH DEPTNM = 'XX회사'
--START WITH p_deptcd IS NULL 3가지 경우가 가능하다.
CONNECT BY   p_deptcd = PRIOR deptcd;  이렇게 써도된다.
--행과 행의 연결조건 (priorXX회사 - " "3가지 부(디자인부, 정보기획부, 정보시스템부))
--PRIOR XX회사.deptcd = 디자인부.p_deptcd
--PRIOR 디자인부.deptcd = 디자인팀.p_deptcd

--PRIOR XX.회사.deptcd = 정보기획부.p_deptcd
--PRIOR 정보기획부.deptcd = 기획팀.p_deptcd
--PRIOR 기획팀.deptcd = 기획파트.p_dept_cd

--PRIOR XX회사.deptcd = 정보시스템부.p_deptcd (개발1팀, 개발2팀)
--PRIOR 정보시스템부.p_deptcd = 개발1팀.p_deptcd
--PRIOR 개발1팀.p_deptcd !=...
--PRIOR 정보시스템부 .deptcd = 개발2팀.p_deptcd
--PRIOR 개발2팀.deptcd != .... 

