SELECT ename, deptno
FROM emp;

select *
from dept;

select e.empno ,e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno;

-- JOIN 두 테이블을 연결하는 작업
-- JOIN 문법
-- 1. ANSI 문법
-- 2. ORACLE 문법

-- Natural JOIN
-- 두 테이블간 컬럼명이 같을 때 해당 컬럼으로 조인
-- emp, dept 테이블에는 deptno라는 컬럼이 존재
-- 두 테이블간 동일한 이름을 갖는 모든 칼럼들에 대해 동등조인을 수행한다.

SELECT *
FROM emp NATURAL JOIN dept;

-- Natural join 에 사용된 조인 칼럼(deptno)는 한정자(ex: 테이블명, 테이블 별칭)을 사용하지 않고
-- 컬럼명만 기술한다.(dept.deptno --> deptno)
SELECT e.empno, e.ename, d.dname ,deptno
FROM emp e NATURAL JOIN dept d;

--테이블에 대한 별칭도 사용가능

-- ORACLE JOIN
-- FROM 절에 조인할 테이블 목록을 ,로 구분하여 나열한다.
-- 조인할 테이블의 연결조건을 WHERE 절에 기술한다.
-- emp, dpet 테이블에 존재하는 deptno 컬럼이 같을 때 조인

EXPLAIN PLAN FOR
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno; 


SELECT *
FROM TABLE(dbms_xplan.display);

-- 오라클 조인의 테이블 별칭

SELECT e.empno, e.ename, d.dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : JOIN WITH USING
-- 조인 하려는 두개의 테이블에 이름이 같은 컬럼이 두개이지만 하나의 컬럼으로만 조인을 하고자할때
-- 조인하려는 기준 컬럼을 기술
-- emp, dept 테이블의 공통컬럼 : deptno

SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WITH USING을 ORACLE로 표현하면

SELECT e.ename, d.dname, e.deptno 
FROM emp e, dept d
WHERE e.deptno = d.deptno;


-- ANSI  : JOIN WITH ON
-- 조인하려고하는 테이블의 컬럼 이름이 서로 다를때

SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--JOIN WITH ON --> ORACLE
SELECT e.ename, d.dname, e.deptno 
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- SELF JOIN :  같은 테이블간의 조인
-- ex)emp 테이블에서 관리되는 사원의 관리자 사번을 이용하여 관리자 이름을 조회할때
-- 사원쪽에서 mgr를 읽어야하고 -> e.mgr 매니저쪽에서는 매니저의 정보 m.empno
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);


--오라클 문법으로 작성
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno;

--equal 조인 : =
--non equal 조인 : !=, >, <, BETWEEN AND

-- 사원의 급여 정보와 급여 등급 테이블을 이용하여 해당사원의 급여 등급을 구해보자
SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

SELECT e.ename, e.sal,s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL;

--ANSI 문법을 이용하여 위의 조인 문을 작성

SELECT e.ename, e.sal,s.grade
FROM emp e JOIN salgrade s ON (e.sal BETWEEN s.LOSAL AND s.HISAL);

--join0

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

--JOIN0_1

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno IN (10,30);

--JOIN0_2

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
WHERE sal>2500
ORDER BY d.deptno;

--JOIN0_3
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e JOIN dept d USING(deptno)
WHERE sal>2500 AND e.empno>7600;

--JOIN0_4
SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e JOIN dept d USING(deptno)
WHERE sal>2500 AND e.empno>7600 AND d.dname = 'RESEARCH';


SELECT *
FROM prod;


--PROD : PROD_LGU
--LPROD : LPROD_GU

SELECT *
FROM prod;

SELECT *
FROM lprod;

SELECT p.prod_lgu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu
ORDER BY p.prod_lgu;


SELECT b.buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p, buyer b
WHERE p.prod_buyer = b.buyer_id;


