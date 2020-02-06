--CROSS JOIN  ==> 카티션 프로덕트(Cartesian product)
--조인하는 두 테이블의 연결 조건이 누락되는 경우
--가능한 모든 조합에 대해 연결(조인)이 시도
--dept(4건), emp(14)의 CROSS JOIN의 결과는 4*14 = 56건
--dept 테이블과 emp테이블을 조인을 하기 위해 FROM 절에 두개의 테이블을 기술
--WHERE 절에 두 테이블의 연결 조건을 누락
--테이블간 적용하는 경우보다 데이터 복제를 위해 사용한다.

SELECT *
FROM emp;

SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno=10
AND dept.deptno = emp.deptno;

--crossjoin1
SELECT *
FROM customer CROSS JOIN product
order by customer.CID;

--SUBQUERY : 쿼리안에 다른 쿼리가 들어가 있는 경우
--SUBQUERY가 사용된 위치에 따라 3가지 분류
--SELECT 절 : SCALAR SUBQUERY : 하나의 행 , 하나의 컬럼만 리턴해야 에러가 발생하지 않음
--FROM 절 : INLINE-VIEW (VIEW)  
--WHERE 절 : SUBQUERY

--SMITH가 속한 부서에 속하는 직원들의 정보를 조회
--1.SMITH가 속하는 부서 번호를 구한다.
--2. 1번에서 구한 부서 번호에 속하는 직원들 정보를 조회한다.

--1
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--2
SELECT *
FROM emp
WHERE deptno = 20;


--SUBQUERY를 이용하면 두개의 쿼리를 동시에 하나의 SQL로 실행가능
--괄호안의 쿼리가 먼저 실행되고 나머지 쿼리가 실행된다.
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
               FROM emp
               WHERE ename = 'SMITH');

select *
from emp;

--서브쿼리 실습1
--sub1 : 평균 급여보다 높은 급여를 받는 직원의 수
--1. 평균급여 구하기
--2. 구한 평균 급여보다 높은 급여를 받는 사람
SELECT count(*) 
FROM emp
WHERE sal>(SELECT avg(sal)
           FROM emp);
           

--sub2
SELECT * 
FROM emp
WHERE sal>(SELECT avg(sal)
           FROM emp);
    

--다중행 연산자
--IN : 서브쿼리의 여러행중 일치하는 값이 존재할 때
--ANY [활용도는 다소 떨어짐] : 서브쿼리의 여러행중 한 행이라도 조건을 만족할때
--ALL [활용도는 다소 떨어짐] : 서브쿼리의 여러행중 모든 행에 대해 조건을 만족할 때

--SMITH가 속하는 부서의 모든 조건을 조회
--SMITH와 WARD 직원이 속하는 부서의 모든 직원을 조회


--서브쿼리의 결과가 여러 행일 때는 '=' 연산자를 사용하지 못한다
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));


--SMITH, WARD 사원의 급여보다 급여가 작은 직원을 조회(SMITH, WARD의 급여 2가지 아무거나)

SELECT *
FROM emp
WHERE sal < ANY (SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH','WARD'));

--SMITH, WARD 사원의 급여보다 급여가 높은 직원을 조회(SMITH, WARD의 급여 2가지 모두에 대해 높을때)

SELECT * 
FROM emp
WHERE sal> ALL (SELECT sal
               FROM emp
               WHERE ename IN ('SMITH','WARD'));
               

--IN, NOT IN의 NULL과 관련된 유의 사항
--직원의 관리자 사번이 7566이거나 NULL
--IN 연산자는 OR연산자로 치환 가능
--IN에서는 null이 인식되지 않는다.
--IN, NOT IN 연산자 사용시 서브쿼리의 결과에 NULL이 존재할경우
--전체가 NULL인 것처럼 동작한다.
SELECT *
FROM emp
WHERE mgr IN (7902,null);

--null비교는 = 연산자가 아니라 IS NULL로 비교해야지만, IN연산자는 =로 계산한다.
SELECT *
FROM emp
WHERE mgr =7902
OR mgr is null;

--empno NOT IN (7902, NULL) --> AND
--사원번호가 7902가 아니면서(AND) NULL이 아닌 데이터

SELECT *
FROM emp
WHERE empno NOT IN(7902, NULL);

SELECT *
FROM emp
WHERE empno != 7902 AND
      empno != null;
      
      
SELECT *
FROM emp
WHERE empno != 7902 AND
      empno is not null;
      
--pairwisw (순서쌍)
--(mgr,deptno)
--(7698,30), (7839,10)


SELECT *
FROM emp
WHERE( mgr, deptno) IN(SELECT mgr, deptno
                       FROM emp
                       WHERE empno IN(7499,7782));

--non-pairwise 는 순서쌍을 동시에 만족시키지 않는 형태로 작성
--mgr 값이 7698 이거나 7839 이면서
--deptno가 10이거나 30번인 직원
--MGR,detpno
--(7698,10) , (7698,30)
--(7839,10), (7839,30)

SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
             FROM emp
             WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno
              FROM emp
              WHERE empno IN(7499,7782));
              

--스칼라 서브쿼리 SELECT 절에 기술 , 1개의 ROW, 1개의 COL을 조회하는 쿼리
--스칼라 서브쿼리는 MAIN쿼리의 컬럼을 사용하는게 가능하다.


SELECT (SELECT SYSDATE
        FROM dual), d.*
FROM dept d;

SELECT empno, ename, deptno, 
    (SELECT dname
     FROM dept
     WHERE emp.deptno = dept.deptno) dname
FROM emp;


--INLINE VIEW : FROM절에 기술되는 서브쿼리

--MAIN쿼리의 컬럼을 SUBQUERY에서 사용하는 지 유무에 따른분류
--사용할 경우 : correlateed subquery(상호 연관 쿼리), 서브쿼리만 단독으로 실행 하는게 불가능하다.
        --      실행 순서가 정해져 있다.(main --> sub)
--사용하지 않을 경우 : non-correlated subquery(비상호 연관 서브쿼리), 서브쿼리만 단독으로 실행하는게 가능
    --              실행 순서가 정해져 있지 않다.(main --> sub) (sub --> main)

--모든직원의 급여 평균보다 급여가 높은 사람을 조회
SELECT *
FROM emp
WHERE sal>
        (SELECT AVG(sal)
        FROM emp);
        
--직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회        

SELECT *
FROM emp e
WHERE sal>
        (SELECT AVG(sal)
         FROM emp e1
         WHERE e.deptno = e1.deptno
         );

--위의 문제를 조인을 이용해서 풀어보자
--1. 조인 테이블 선정
--   emp, 부서별 급여 평균

SELECT e.ename, sal.*
FROM emp e, ( SELECT deptno, AVG(sal) avg_sal
                FROM emp GROUP BY deptno) sal
WHERE e.deptno = sal.deptno
AND e.sal> sal.avg_sal;


SELECT *
FROM emp e, (SELECT deptno, AVG(sal) avg_sal
             FROM emp
             GROUP BY deptno)sal
WHERE e.deptno = sal.deptno
AND e.sal>sal.avg_sal;

--sub4 데이터 추가
INSERT INTO dept VALUES(99,'ddit','daejeon');
commit;
DELETE dept
WHERE deptno = 99;


-- 트랜잭션 확정 : commit
-- 트랜잭션 취소 : rollback

--sub4
--dept 테이블에는 5건의 데이터가 존재
--emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서에 속해있다(deptno)
--부서중 직원이 속해 있지 않은 부서 정보를 조회
--서브쿼리에서 데이터의 조건이 맞는지 확인자 역할을 하는 서브쿼리 작성

SELECT deptno, dname, loc
FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);
--WHERE (SELECT deptno FROM emp) NOT IN deptno;
-- in 왼쪽에 있는 것은 결과 같이 하나여야 한다. 위값은 14건이 나오는 데이터이기 때문에 안된다.
-- sql문을 전체로 비교하지말고 값 하나하나를 대입시키는 방법으로 생각해볼것 ex) for문
-- 그룹바이를 사용하면 데이터를 읽고 묶는 작업이 추가되기 때문에 속도면에서는 느리다.
