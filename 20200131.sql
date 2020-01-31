SELECT ename, deptno
FROM emp;

select *
from dept;

select e.empno ,e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno;

-- JOIN �� ���̺��� �����ϴ� �۾�
-- JOIN ����
-- 1. ANSI ����
-- 2. ORACLE ����

-- Natural JOIN
-- �� ���̺� �÷����� ���� �� �ش� �÷����� ����
-- emp, dept ���̺��� deptno��� �÷��� ����
-- �� ���̺� ������ �̸��� ���� ��� Į���鿡 ���� ���������� �����Ѵ�.

SELECT *
FROM emp NATURAL JOIN dept;

-- Natural join �� ���� ���� Į��(deptno)�� ������(ex: ���̺��, ���̺� ��Ī)�� ������� �ʰ�
-- �÷��� ����Ѵ�.(dept.deptno --> deptno)
SELECT e.empno, e.ename, d.dname ,deptno
FROM emp e NATURAL JOIN dept d;

--���̺� ���� ��Ī�� ��밡��

-- ORACLE JOIN
-- FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�.
-- ������ ���̺��� ���������� WHERE ���� ����Ѵ�.
-- emp, dpet ���̺� �����ϴ� deptno �÷��� ���� �� ����

EXPLAIN PLAN FOR
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno; 


SELECT *
FROM TABLE(dbms_xplan.display);

-- ����Ŭ ������ ���̺� ��Ī

SELECT e.empno, e.ename, d.dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- ANSI : JOIN WITH USING
-- ���� �Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ������� �ϳ��� �÷����θ� ������ �ϰ����Ҷ�
-- �����Ϸ��� ���� �÷��� ���
-- emp, dept ���̺��� �����÷� : deptno

SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

-- JOIN WITH USING�� ORACLE�� ǥ���ϸ�

SELECT e.ename, d.dname, e.deptno 
FROM emp e, dept d
WHERE e.deptno = d.deptno;


-- ANSI  : JOIN WITH ON
-- �����Ϸ����ϴ� ���̺��� �÷� �̸��� ���� �ٸ���

SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--JOIN WITH ON --> ORACLE
SELECT e.ename, d.dname, e.deptno 
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- SELF JOIN :  ���� ���̺��� ����
-- ex)emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� ������ �̸��� ��ȸ�Ҷ�
-- ����ʿ��� mgr�� �о���ϰ� -> e.mgr �Ŵ����ʿ����� �Ŵ����� ���� m.empno
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);


--����Ŭ �������� �ۼ�
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno;

--equal ���� : =
--non equal ���� : !=, >, <, BETWEEN AND

-- ����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ� �ش����� �޿� ����� ���غ���
SELECT ename, sal
FROM emp;

SELECT *
FROM salgrade;

SELECT e.ename, e.sal,s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.LOSAL AND s.HISAL;

--ANSI ������ �̿��Ͽ� ���� ���� ���� �ۼ�

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


