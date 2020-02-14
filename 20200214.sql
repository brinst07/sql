--MERGE : SELECT하고나서 데이터가 조회되면 UPDATE
--        SELECT하고나서 데이터가 조회되지 않으면 INSERT
--        
--SELECT + UPDATE / SELECT + INSERT ==> MERGE;

--REPORT GROUP FUNCTION 
--1.ROLLUP
--    -GROUP BY ROLLUP(컬럼1, 컬럼2)
--    -ROLLUP절에 기술한 컬럼을 오른쪽에서 하나씩 제거한 컬럼으로 SUBGROUP
--    -GROUP BY 컬럼1, 컬럼2
--     UNION
--     GROUP BY 컬럼1
--     UNION
--     GROUP BY 
--2.CUBE
--3.GROUPING SETS

--GROUP_AD3

SELECT DEPTNO , JOB ,sum(sal)
     FROM emp
     GROUP BY ROLLUP(deptno,job);
     
SELECT d.dname, e.job, sum(sal)
FROM emp e,dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname,e.job DESC;


--다시한번 알아볼 문제
SELECT b.DNAME,a.job,a.sal
FROM 
(SELECT deptno, job, sum(sal) sal
 FROM emp
 GROUP BY ROLLUP(deptno, job))a LEFT OUTER JOIN dept b ON (a.deptno = b.deptno)
 ;

--GROUP_AD5     
SELECT  CASE 
        WHEN grouping(d.DNAME) = 1 THEN '총합'
        ELSE d.DNAME
        END dname, e.job , sum(sal)
FROM emp e,dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP(d.dname, e.job)
ORDER BY d.dname,e.job DESC;


REPORT GROUP FUNCTION
1. ROLLUP
2. CUBE
3. GROUPING SETS

활용도
3,1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CUBE

GROUPING SETS
순서와 관계 없이 서브 그룹을 사용자가 직접 지시
사용방법 : GROUP BY GROUPING SETS(col1, col2..)
단일컬럼 사용예

GROUPING SETS의 경우 컬럼 기술 순서가 결과에 영향을 미치지 않는다.
ROLLUP은 컬럼 기술 순서가 결과 영향을 미친다.
GROUP BY GROUPING SETS(col1, col2..)

-->
GROUP BY col1
UNION ALL
GROUP BY col2
복수컬럼 사용예
GROUP BY GROUPING SETS((col1, col2),col3,col4..)
==>
GROUP BY col1, col2
UNION ALL
GROUP BY col3
UNION ALL
GROUP BY col4;

두개의 결과가 같을까?
GROUP BY GROUPING SETS((col1, col2),col3,col4..)
GROUP BY GROUPING SETS(col4, (col1, col2),col3..)

SELECT job, deptno, sum(sal)
FROM emp
GROUP BY GROUPING SETS(job, deptno);
-->
GROUP BY job
UNION ALL
GROUP BY deptno;

--UNION ALL 인 이유 같은 컬럼으로 grouping을 해주면 중복된 값이 하나로 나오지 않고 UNION ALL이 된다.
SELECT job, sum(sal)
FROM emp
GROUP BY GROUPING SETS(job, job);


job, deptno 로 GROUP BY 한 결과과
mgr로 GROUP BY한 결과를 조회하는 SQL을 GROUPING SET로 SUM(sal) 작성

SELECT job, deptno, mgr,sum(sal)
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr)
ORDER BY job,deptno;

--CUBE
--가능한 모든 조합으로 컬럼을 조합한 SUB GROUP을 생성한다.
--단 기술한 컬럼의 순서는 지킨다.

EX : GROUP BY CUBE(col1,col2);

--(col1,col2) -> 
--(null, col2) == group by col2
--(null, null) == group by 전체
--(col1, null) == group by col1
--(col1, col2) == group by col1,col2;

만약 컬럼 3개를  CUBE절에 기술한 경우 나올수 있는 가지수 ??


SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY job, rollup(deptno), CUBE(mgr);

--실무에서는 위같은 코드를 쓰지는 않는다.

--GROUP BY JOB, deptno,mgr = GROUP BY job, deptno, mgr
--GROUP BY JOB, deptno = GROUP BY job, deptno
--GROUP BY JOB, null, mgr = GROUP BY job, mgr
--GROUP BY JOB, null, null = GROUP BY job


서브쿼리 UPDATE
1. emp_test 테이블 drop
2. emp 테이블을 이용해서 emp_test 테이블생성 (모든 행에 대해 ctas)
3. emp_test 테이블에 dname VARCHAR2(14)컬럼추가
3. emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

ALTER TABLE emp_test ADD (dname VARCHAR(14));

SELECT *
FROM emp_test;

UPDATE emp_test SET dname = (SELECT dname
                            FROM dept
                            WHERE dept.deptno = emp_test.deptno);

drop table dept_test;

CREATE TABLE dept_test1 AS
SELECT *
FROM dept;

ALTER TABLE dept_test1 ADD(empcnt NUMBER);

UPDATE dept_test1 SET empcnt =  NVL((select count(*)
                                FROM emp
                                WHERE emp.deptno = dept_test1.deptno
                                GROUP BY emp.deptno),0);
           
select *
FROM dept_test1;

--sub_a2
--dept_test 테이블에 있는 부서중에 직원이 속하지 않은 부서정보를 삭제
--*dept_test.empcnt 컬럼은 사용하지 않고
--emp 테이블을 이용해서 삭제
INSERT INTO dept_test1 VALUES (99, 'it1' , 'daejeon', 0);
INSERT INTO dept_test1 VALUES (98, 'it2' , 'daejeon', 0);
commit;

--join을 사용해서 푼것 (너무 어렵게 풀었다...)
SELECT *
FROM dept_test1 d, emp e
WHERE d.deptno = e.deptno(+)
AND e.deptno is null;

--선생님이 푸신것
DELETE dept_test1
WHERE 0 = (SELECT COUNT(*)
           FROM emp
           WHERE deptno = dept_test1.deptno);
           


--sub_a3
--내가 푼것
UPDATE emp_test set sal = sal+200
WHERE empno IN (SELECT empno
                FROM emp_test e ,(SELECT deptno,AVG(sal) sal
                                  FROM emp_test 
                                  GROUP BY deptno) a
                WHERE a.deptno =e.deptno AND e.sal<a.sal);


--선생님이 푼것            
UPDATE emp_test a SET sal = sal +200
WHERE sal < (SELECT AVG(SAL)
             FROM emp_test b
             WHERE a.deptno = b.deptno);
             

SELECT *
FROM emp_test;

--WITH절
--하나의 쿼리에서 반복되는 SUBQUERY가 있을 떄
--해당 SUBQUERY를 별도로 선언하여 재사용

--MAIN 쿼리가 실행될때 WITH 선언한 쿼리 블럭이 메모리에 임시적으로 저장
--> MAIN쿼리가 종료되면 메모리 해제

--SUBQUERY 작성시에는 해당 SUBQUERY의 결과를 조회하기 위해서 I/O가 반복적으로 일어나지만

--WITH절을 통해 선언한다면 한번만 SUBQUERY가 실행되고 그 결과를 메로리에 저장해 놓고 재사용

--단, 하나의 쿼리에서 SUBQUERY가 반복적으로 나오는거는 잘못 작성 SQL일 확률이 높음

--WITH 쿼리블록 이름 AS (
--           서브쿼리
-- )

SELECT *
FROM 서브쿼리 블록이름;

--직원의 부서별 급여 평균을 조회하는 쿼리블록 WITH절을 통해 선언

WITH sal_avg_dept AS(
    SELECT deptno, ROUND(AVG(sal),2) sal
    FROM emp
    GROUP BY deptno
),
    dept_empcnt AS(
    SELECT deptno, COUNT(*) empcnt
    FROM emp
    GROUP BY deptno)


SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;


WITH temp AS(
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL
    SELECT sysdate -3 FROM dual)
SELECT *
FROM temp;

-----------------------------

달력만들기
CONNECT BY LEVEL <[=] 정수
해당테이블의 행을 정수 만큼 복제하고, 복제된 행을 구별하기 위해서 LEVEL을 부여
LEVEL은 1부터 시작

SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <=10; 

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <=5;

2020년 2월의 달력을 생성
:dt =  202002,202003
1.
SELECT TO_DATE('202002','YYYYMM')+ LEVEL-1,
       TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1),'D')
       DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
            1, TO_DATE('202002','YYYYMM') + (LEVEL-1))s,
             DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
            1, TO_DATE('202002','YYYYMM') + (LEVEL-1))m,
             DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
            1, TO_DATE('202002','YYYYMM') + (LEVEL-1))s,
             DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
            1, TO_DATE('202002','YYYYMM') + (LEVEL-1))s,
             DECODE(TO_CHAR(TO_DATE('202002','YYYYMM') + (LEVEL-1), 'D'),
            1, TO_DATE('202002','YYYYMM') + (LEVEL-1))s
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002','YYYYMM')),'DD');

SELECT TO_CHAR(LAST_DAY(TO_DATE('202002','YYYYMM')),'D')
FROM dual;