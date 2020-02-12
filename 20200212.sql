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
--���� job�ε����� �о ���� �Ÿ��� LIKE ������ �����ϱ� ���� full scan�Ѵ�.


CREATE INDEX idx_n_emp_03 ON emp(job,ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT*
FROM TABLE (dbms_xplan.display);
-- ���Ǳ�� ������ 1������ ���͸��� ������ٴ� ��
-- �ε��� ��ü�� job�� ename���� ������ ���ֱ� ������ b�� �����ϴ� black�� ������ ����
-- ���Ŀ� ����ó�����ؼ� ���ϴ� ���� ã����
-- ���̺� �׼����� �ؼ� ���ϴ� ������ ������ �°�
-- �ε����� ����Ҷ� '%����'�� ������ �ε����� ���� �����Ѵٰ� ����ȴ�. �ֳ��ϸ� ��¼�� ���о����

--1.table full
--2.idx1 : empno
--3.idx2 : job
--4.idx3 : job+ename
--5.idx4 : ename + job

CREATE INDEX idx_n_emp_04 ON emp (ename, job);

--3��° �ε����� ������
--3,4 ��° �ε����� �÷������� �����ϰ� �������ٸ���
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

--�̷� �������� ���ϴ� �ٴ� �ε����� �÷������� ��� �ϴ��Ŀ� ���� �д� �Ǽ��� �޶��� �� �� �ִ�.

--�������� �����ϴ� �ε����� �ִٰ� �ؼ� �׻� �ε����� ����ϴ°��� �ƴϴ�.

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
--1.����
--
--
--2�� ���̺� ����
--������ ���̺� �ε��� 5���� �ִٸ�
--�� ���̺� ���� ���� : 6 -> 36*2 = 72
--
--
--
--ORACLE - �ǽð� ���� : OLTP(ON LINE TRASCATION PROCESSING)
--         ��ü ó���ð� : OLAP (ON LINE ANALYSIS PROCESSING) - ������ ������ �����ȹ�� ����µ� 30M~1H
--
--
--EMP ���� ������ dept���� ������?? -> ���� FROM ���� ����Ѽ����� �д°��� �ƴ� ����Ŭ�� ����������, ����Ŭ�� �Ǵ�

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
--�������� ���簡 NOT NULL�� �ȴ�.
--����̳�, �׽�Ʈ������
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
--3�� deptno(=), empno(LIKE ������ȣ%) -> index empno �� index empno, deptno �� ��ü���� -> empno, deptno�� empno�� ������ ������ 
--                                                                                         deptno�� �ѹ� �� �����ϴ� ��
--4�� deptno(=), sal (BETWEEN)
--5�� deptno(=) / mgr �����ϸ� ����
--6�� deptno, hiredate�� �ε��� �����ϸ� ����



