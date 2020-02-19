--쿼리 실행 결과 11건
--페이징 처리 (페이지당 10건의 게시글)
--1페이지 1~10
--2페이징 11~20
--바인변수 :page, :pagesize
--중요한 쿼리이다.
SELECT *
FROM
    (SELECT ROWNUM rn, a.*
    FROM
        (SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title, DECODE(parent_seq, NULL, seq, parent_seq) gn
        FROM board_test
        START WITH parent_seq is null
        CONNECT BY prior seq = parent_seq
        ORDER SIBLINGS BY gn desc, seq asc) a 
    )
WHERE rn between (:page-1)*:pageSize+1 AND :page*:pageSize;


SELECT part_b.deptno, part_b.ename,part_a.lv
FROM
(SELECT part1.* , rownum a
FROM
(SELECT a.*
FROM
(SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= 14)) a,

(SELECT deptno, count(*) cnt
FROM emp
GROUP BY deptno) b

WHERE b.cnt >= a.lv
ORDER BY b.deptno, a.lv) part1) part_a, 


(SELECT deptno, ename, rownum a
FROM
(select *
FROM emp e
order by deptno, sal desc, ename)) part_b
WHERE part_a.a = part_b.a;

--위의 쿼리를 분석함수를 사용해서 표현하면

SELECT ename, sal, deptno, ROW_NUMBER() over(partition by deptno order by sal desc) rank
FROM emp;

--분석함수 문법
--분삭함수명([인자]) over([partition by 컬럼] [order by 컬럼] [windowing]);
--PARTITION BY 컬럼 : 해당컬럼이 같은 ROW끼리 하나의 그룹으로 묶는다.
--ORDER BY 컬럼 : PARTITION BY에 의해 묶은 그룹 내에서 ORDER BY 컬럼으로 정렬하겠다.

ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) rank;

--순위 관련 분석함수
--RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복 값만큼 떨어진 값부터 시작
--         2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다.
--DENS_RANK() : 같은 값을 가질때 중복순위를 인정, 후순위는 중복순위 다음부터 시작한다.
--              2등이 2명이더라도 후순위는 3등부터 시작
--ROW_NUMBER() : ROWNUM과 유사, 중복된 값을 허용하지 않음
--

부서별, 급여 순위를 3개의 랭키 관련 함수를 적용
SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal desc) rank
        ,DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal desc) dens,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal desc) rn
FROM emp;

--anal : 

SELECT emp.* , ROW_NUMBER() OVER(ORDER BY sal desc) rank
             , RANK() OVER(ORDER BY sal desc , empno) rank
             ,DENSE_RANK() OVER(ORDER BY sal desc, empno) rank
FROM emp;

SELECT a.empno, a.ename, a.deptno, b.c
FROM
    (SELECT *
    FROM emp) a
    
    JOIN
    
    (SELECT deptno, count(*) c
    FROM emp 
    GROUP BY deptno)b
    
    ON(a.deptno = b.deptno)
ORDER BY a.deptno;


--통계관련 분석함수(GROUP 함수에서 제공하는 함수 종료와 동일)
--SUM(컬럼)
--COUNT(*), COUNT(컬럼)
--MIN(컬럼)
--MAX(컬럼)
--AVG(컬럼)

--no_ana2를 분석함수를 사용하여 작성
--부서별 직원수

SELECT empno, ename, deptno, COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

SELECT empno,ename, deptno, ROUND(AVG(sal) OVER(PARTITION BY deptno),2) avg
FROM emp;

SELECT empno,ename, deptno, MAX(sal) OVER(PARTITION BY deptno) MAX
FROM emp;

SELECT empno, ename, deptno, MIN(sal) OVER(PARTITION BY deptno) MIN
FROM emp;

급여를 내림차순 정렬하고, 급여가 같을 땐 입사일자가 빠른사람이 높은 우선순위가 되도록 정렬하여
현재행의 다음행(lead)의 sal 컬럼을 구하는 쿼리 작성

SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY sal desc,hiredate) lead_sal
FROM emp;

SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY sal desc, hiredate) lad_sas
FROM emp;


SELECT empno, ename, hiredate, job, sal, Lag(sal) OVER(PARTITION BY job ORDER BY sal desc, hiredate) a
FROM emp;

SELECT empno, ename, sal, sum(LAG(sal) OVER(ORDER BY sal asc)+ sal)
FROM(
SELECT empno, ename, sal, 0 as a
FROM emp)
GROUP BY empno, ename, sal;

no_ana3을 분석함수를 이용하여 SQL 작성

SELECT empno, ename, sal, sum(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

현재행을 기준으로 이전한 행부터 이후 한행까지 총 3개행의 sal 합계 구하기
SELECT empno, ename, sal, sum(sal) OVER( ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;


SELECT empno, ename, empno, sal, 
sum(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

--ORDER BY 기술후 WINDOWING 절을 기술하지 않을 경우 다음 WINDOWING이 기본 값으로 적용된다.
--RANGE UNBOUNDED PRECEDING
--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--두개가 같은말이다

SELECT empno, ename, empno, sal, 
sum(sal) OVER(PARTITION BY deptno ORDER BY sal, empno RANGE UNBOUNDED PRECEDING) c_sum
FROM emp;

SELECT empno, ename, empno, sal, 
sum(sal) OVER(PARTITION BY deptno ORDER BY sal ROWS UNBOUNDED PRECEDING) row_,
sum(sal) OVER(PARTITION BY deptno ORDER BY sal RANGE UNBOUNDED PRECEDING) range_,
sum(sal) OVER(PARTITION BY deptno ORDER BY sal ) default_
FROM emp;

--row는 구별
--range는 중복값을 포함해서더한다.
--default는 range와 같다.
--WINDOWING의 RANGE, ROWS비교
--RANGE : 논리적인 행의 단위, 같은 값을 가지는 컬럼까지 자신의 행으로 취급
--ROWS : 물리적인 행의 단위
