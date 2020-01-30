SELECT ename, job, sal, 
        DECODE(job, 'SALESMAN', CASE
                                    WHEN sal > 1400 THEN sal * 10.5
                                    WHEN sal < 1400 THEN sal * 1.1
                                END,
                    'MANAGER', sal * 1.1,
                    'PRESIDENT', sal*1.2,
                    sal) bonus_sal
FROM emp;

--cond1
--case
SELECT empno, ename, CASE
                        WHEN deptno=10 THEN 'ACCOUNTING'
                        WHEN deptno=20 THEN 'RESEARCH'
                        WHEN deptno=30 THEN 'SALES'
                        WHEN deptno=40 THEN 'OPERATIONS'
                        ELSE 'DDIT'
                    END dname
FROM emp;
--decode
SELECT empno, ename, DECODE(deptno, 10, 'ACCOUNTING'
                                 , 20, 'RESEARCH'
                                 , 30, 'SALES'
                                 ,40, 'OPERATIONS'
                                 ,'DDIT') dname
FROM emp;


--cond3
SELECT empno, ename, hiredate,
                            CASE
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2)=0 THEN
                                    (CASE WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)=0 THEN '건강검진대상자'
                                        WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)!=0 THEN '건강검진비대상자'
                                     END)
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2)!=0 THEN
                                    (CASE WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)!=0 THEN '건강검진대상자'
                                        WHEN MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)=0 THEN '건강검진비대상자'
                                     END)
                             END CONTACT_TO_DOCTOR
FROM emp;


SELECT empno, ename, hiredate,
                            CASE
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2) = MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)
                                THEN '건강검진대상자'
                                WHEN MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2) != MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2)
                                THEN '건강검진비대상자'
                            END CONTACT_TO_DOCTOR                                                              
FROM emp;


SELECT empno, ename, hiredate, DECODE(
                                MOD(TO_NUMBER(TO_CHAR(sysdate,'YYYY')),2) , 
                                MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')),2),
                                '건강검진대상자',
                                '건강검진비대상자')

                                건강
FROM emp;


-- GROUP BY 행을 묶을 기준
-- 부서번호 같은 ROW끼리 묶는 경우 : GROUP BY deptno
-- 담당업무가 같은 ROW끼리 묶는 경우 : GROUP BY job
-- MGR가 같고 담당업무가 같은 ROW끼리 묶는 경우 : GROUP BY mgr, job

--그룹함수의 종류
-- sum : 합계
-- count : 개수 --> NULL이 아닌 ROW의 개수 (NULL은 무시한다.)
-- MAX : 최대값
-- MIN : 최소값
-- AVG : 평균

--그룹함수의 특징
--해당 컬럼에NULL값을 갖는 ROW가 존재할 경우 해당 값은 무시하고 계산한다.(NULL 연산의 결과는 NULL)

--부서별 급여 합

--그룹함수 주의점
--GROUP BY 절에 나온 컬럼이외의 다른 컬럼이 SELECT절에 표현되면 에러
SELECT deptno, ename,
        SUM(sal),MAX(sal),MIN(sal),ROUND(AVG(sal),2),count(deptno)
FROM emp
GROUP BY deptno ,ename;


--GROUPY BY 절이 없는 상태에서 그룹함수를 사용 한 경우
--GROUP BY가 없다면 전체행을 하나의 행으로 묶는다는 뜻

SELECT --deptno, ename, -> 다시 생각해보기
        SUM(sal),MAX(sal),MIN(sal),ROUND(AVG(sal),2),count(deptno),
        COUNT(sal), --sal 칼럼의 값이 null이 아닌 row의 개수
        COUNT(comm), -- COMM 컬럼의 값이 null이 아닌 row의 개수
        COUNT(*) --몇건의 데이터가 있는지
FROM emp;

SELECT *
FROM emp;

--GROUP BY의 기준이 empno이면 결과수가 몇건?
-- 1 sysdate accounting 같은 그룹화와 관련없는 임의의 문자열, 함수, 숫자등은 SELECT에 나오는 것이 가능하다. 
SELECT  1,SYSDATE,'ACCOUNTING',SUM(sal),MAX(sal),MIN(sal),ROUND(AVG(sal),2),count(deptno),
        COUNT(sal), --sal 칼럼의 값이 null이 아닌 row의 개수
        COUNT(comm), -- COMM 컬럼의 값이 null이 아닌 row의 개수
        COUNT(*) --몇건의 데이터가 있는지
FROM emp
GROUP BY empno;

--SINGLE ROW FUNCTION의 경우 WHERE절에서 사용하는 것이 가능하나
--MULTI ROW FUNCTION(GROUP FUNCTION)의 경우 WHERE절에서 사용하는 것이 불가능 하고
--HAVING 절에서 조건을 기술한다.

--부서별 급여 합 조회, 단 급여합이 9000이상인  row만 조회
--deptno, 급여합

SELECT deptno, sum(sal)
FROM emp
GROUP BY deptno
HAVING sum(sal)>=9000;

--grp1

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp;


--grp2

SELECT deptno,MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY deptno;

--grp3

SELECT DECODE( deptno, 10, 'ACCOUNTING', 20, 'RESEARCH',30,'SALES' ) DEPTNO 
,MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY DECODE( deptno, 10, 'ACCOUNTING', 20, 'RESEARCH',30,'SALES' );

--grp4 --> 한번더 확인
-- ORACLE 9i 이전까지는 GROUP BY절에 기술한 컬럼으로 정렬을 보장
-- ORACLE 10g 이후 부터는 GROUP BY 절에 기술한 컬럼으로 정렬을 보장하지 않는다.(GROUP BY 연산시 속도 UP)

SELECT TO_CHAR(hiredate,'YYYYMM') hiredate_YYYYMM, count(*)
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');

--grp5
SELECT TO_CHAR(hiredate, 'YYYY') hre_YYYY, count(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');


