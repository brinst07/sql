--1.table full
--2. idx1 : empno
--3. idx2 : job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);
--먼저 job인덱스를 읽어서 값을 거르고 LIKE 조건을 수행하기 위해 full scan한다.


CREATE INDEX idx_n_emp_03 ON emp(job,ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT*
FROM TABLE (dbms_xplan.display);
-- 주의깊게 볼것은 1번에서 필터링이 사라졌다는 것
-- 인덱스 자체가 job과 ename으로 정렬이 되있기 때문에 b로 시작하는 black는 읽지도 않음
-- 그후에 필터처리를해서 원하는 값을 찾은후
-- 테이블에 액세스를 해서 원하는 정보를 가지고 온것
-- 인덱스를 사용할때 '%문자'가 나오면 인덱스를 거의 사용못한다고 보면된다. 왜냐하면 어쩌피 다읽어야함

--1.table full
--2.idx1 : empno
--3.idx2 : job
--4.idx3 : job+ename
--5.idx4 : ename + job

CREATE INDEX idx_n_emp_04 ON emp (ename, job);

--3번째 인덱스를 지우자
--3,4 번째 인덱스가 컬럼구성이 동일하고 순서만다르다
DROP INDEX idx_n_emp_03;

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job =  'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--이런 예제들이 뜻하는 바는 인덱스의 컬럼구성을 어떻게 하느냐에 따라서 읽는 건수가 달라질 수 가 있다.

--조건절에 부합하는 인덱스가 있다고 해서 항상 인덱스를 사용하는것은 아니다.

--emp - table full, pk_emp(empno)
--dept - table full, pk_dept(deptno)
--
--(emp-table full, dept-table full)
--(dept-table full, emp-table full)
--(emp-table full, dept-pk_dept)
--(dept-pk_dept, emp-table full)
--(emp-pk_emp, dept-table full)
--(dept-table full, emp-pk_emp)
--(dept-pk_dept , emp-pk_emp)
--
--1.순서
--
--
--2개 테이블 조인
--각각의 테이블에 인덱스 5개씩 있다면
--한 테이블에 접근 전략 : 6 -> 36*2 = 72
--
--
--
--ORACLE - 실시간 응답 : OLTP(ON LINE TRASCATION PROCESSING)
--         전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) - 복잡한 쿼리의 실행계획을 세우는데 30M~1H
--
--
--EMP 부터 읽을까 dept부터 읽을까?? -> 내가 FROM 절에 기술한순서로 읽는것이 아님 오라클은 순서가없음, 오라클이 판단

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);
--4 3 5 2 6 1 0

--idx1
--CTAS
--제약조건 복사가 NOT NULL만 된다.
--백업이나, 테스트용으로
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1;

CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);

CREATE INDEX idx_n_dept_test2_02 ON dept_test2 (dname);

CREATE INDEX idx_n_dept_test2_03 ON dept_test2 (deptno,dname);


--idx2
DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_n_dept_test2_02;
DROP INDEX idx_n_dept_test2_03;

--idx3

CREATE TABLE emp_test3 AS
SELECT *
FROM emp;

CREATE UNIQUE INDEX idx_u_emp_test3_01 ON emp_test3 (deptno, empno);

CREATE INDEX idx_n_emp_test3_02 ON emp_test3 (empno,mgr);
drop index idx_n_emp_test3_02;
EXPLAIN PLAN FOR
SELECT B.*
FROM EMP_TEST3 A, emp_test3 B
WHERE A.mgr = B.empno
AND A.deptno = :deptno;

SELECT*

FROM TABLE (dbms_xplan.display);

--index mgr, (deptno,empno)
--|   0 | SELECT STATEMENT             |                    |     1 |   113 |     6  (17)| 00:00:01 |
--|*  1 |  HASH JOIN                   |                    |     1 |   113 |     6  (17)| 00:00:01 |
--|   2 |   TABLE ACCESS BY INDEX ROWID| EMP_TEST3          |     1 |    26 |     2   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN          | IDX_U_EMP_TEST3_01 |     1 |       |     1   (0)| 00:00:01 |
--|   4 |   TABLE ACCESS FULL          | EMP_TEST3          |    13 |  1131 |     3   (0)| 00:00:01 |
--   1 - access("A"."MGR"="B"."EMPNO")
--   3 - access("A"."DEPTNO"=TO_NUMBER(:DEPTNO))

--index (deptno,empno,mgr)
-- |   0 | SELECT STATEMENT   |                    |     1 |   113 |     5  (20)| 00:00:01 |
--|*  1 |  HASH JOIN         |                    |     1 |   113 |     5  (20)| 00:00:01 |
--|*  2 |   INDEX RANGE SCAN | IDX_N_EMP_TEST3_02 |     1 |    26 |     1   (0)| 00:00:01 |
--|   3 |   TABLE ACCESS FULL| EMP_TEST3          |    13 |  1131 |     3   (0)| 00:00:01 |
--   1 - access("A"."MGR"="B"."EMPNO")
--   2 - access("A"."DEPTNO"=TO_NUMBER(:DEPTNO))
  
CREATE INDEX idx_n_emp_test3_02 ON emp_test3 (hiredate);
drop index idx_n_emp_test3_02;

EXPLAIN PLAN FOR
SELECT deptno, TO_CHAR(hiredate, 'yyyymm'), count(*) cnt
FROM emp
GROUP  BY deptno, to_char(hiredate, 'yyyymm');

select *
FROM TABLE (dbms_xplan.display);

----------------------------------------------------------
--access pattern
--empno(=)
--ename(=)
--3번 deptno(=), empno(LIKE 직원번호%) -> index empno 는 index empno, deptno 로 대체가능 -> empno, deptno는 empno가 같은게 있을때 
--                                                                                         deptno로 한번 더 정렬하는 것
--4번 deptno(=), sal (BETWEEN)
--5번 deptno(=) / mgr 동반하면 유리
--6번 deptno, hiredate가 인덱스 존재하면 유리



