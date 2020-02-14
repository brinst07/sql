--MERGE : SELECT�ϰ��� �����Ͱ� ��ȸ�Ǹ� UPDATE
--        SELECT�ϰ��� �����Ͱ� ��ȸ���� ������ INSERT
--        
--SELECT + UPDATE / SELECT + INSERT ==> MERGE;

--REPORT GROUP FUNCTION 
--1.ROLLUP
--    -GROUP BY ROLLUP(�÷�1, �÷�2)
--    -ROLLUP���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷����� SUBGROUP
--    -GROUP BY �÷�1, �÷�2
--     UNION
--     GROUP BY �÷�1
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


--�ٽ��ѹ� �˾ƺ� ����
SELECT b.DNAME,a.job,a.sal
FROM 
(SELECT deptno, job, sum(sal) sal
 FROM emp
 GROUP BY ROLLUP(deptno, job))a LEFT OUTER JOIN dept b ON (a.deptno = b.deptno)
 ;

--GROUP_AD5     
SELECT  CASE 
        WHEN grouping(d.DNAME) = 1 THEN '����'
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

Ȱ�뵵
3,1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CUBE

GROUPING SETS
������ ���� ���� ���� �׷��� ����ڰ� ���� ����
����� : GROUP BY GROUPING SETS(col1, col2..)
�����÷� ��뿹

GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�.
ROLLUP�� �÷� ��� ������ ��� ������ ��ģ��.
GROUP BY GROUPING SETS(col1, col2..)

-->
GROUP BY col1
UNION ALL
GROUP BY col2
�����÷� ��뿹
GROUP BY GROUPING SETS((col1, col2),col3,col4..)
==>
GROUP BY col1, col2
UNION ALL
GROUP BY col3
UNION ALL
GROUP BY col4;

�ΰ��� ����� ������?
GROUP BY GROUPING SETS((col1, col2),col3,col4..)
GROUP BY GROUPING SETS(col4, (col1, col2),col3..)

SELECT job, deptno, sum(sal)
FROM emp
GROUP BY GROUPING SETS(job, deptno);
-->
GROUP BY job
UNION ALL
GROUP BY deptno;

--UNION ALL �� ���� ���� �÷����� grouping�� ���ָ� �ߺ��� ���� �ϳ��� ������ �ʰ� UNION ALL�� �ȴ�.
SELECT job, sum(sal)
FROM emp
GROUP BY GROUPING SETS(job, job);


job, deptno �� GROUP BY �� �����
mgr�� GROUP BY�� ����� ��ȸ�ϴ� SQL�� GROUPING SET�� SUM(sal) �ۼ�

SELECT job, deptno, mgr,sum(sal)
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr)
ORDER BY job,deptno;

--CUBE
--������ ��� �������� �÷��� ������ SUB GROUP�� �����Ѵ�.
--�� ����� �÷��� ������ ��Ų��.

EX : GROUP BY CUBE(col1,col2);

--(col1,col2) -> 
--(null, col2) == group by col2
--(null, null) == group by ��ü
--(col1, null) == group by col1
--(col1, col2) == group by col1,col2;

���� �÷� 3����  CUBE���� ����� ��� ���ü� �ִ� ������ ??


SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY job, rollup(deptno), CUBE(mgr);

--�ǹ������� ������ �ڵ带 ������ �ʴ´�.

--GROUP BY JOB, deptno,mgr = GROUP BY job, deptno, mgr
--GROUP BY JOB, deptno = GROUP BY job, deptno
--GROUP BY JOB, null, mgr = GROUP BY job, mgr
--GROUP BY JOB, null, null = GROUP BY job


�������� UPDATE
1. emp_test ���̺� drop
2. emp ���̺��� �̿��ؼ� emp_test ���̺���� (��� �࿡ ���� ctas)
3. emp_test ���̺� dname VARCHAR2(14)�÷��߰�
3. emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ

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
--dept_test ���̺� �ִ� �μ��߿� ������ ������ ���� �μ������� ����
--*dept_test.empcnt �÷��� ������� �ʰ�
--emp ���̺��� �̿��ؼ� ����
INSERT INTO dept_test1 VALUES (99, 'it1' , 'daejeon', 0);
INSERT INTO dept_test1 VALUES (98, 'it2' , 'daejeon', 0);
commit;

--join�� ����ؼ� Ǭ�� (�ʹ� ��ư� Ǯ����...)
SELECT *
FROM dept_test1 d, emp e
WHERE d.deptno = e.deptno(+)
AND e.deptno is null;

--�������� Ǫ�Ű�
DELETE dept_test1
WHERE 0 = (SELECT COUNT(*)
           FROM emp
           WHERE deptno = dept_test1.deptno);
           


--sub_a3
--���� Ǭ��
UPDATE emp_test set sal = sal+200
WHERE empno IN (SELECT empno
                FROM emp_test e ,(SELECT deptno,AVG(sal) sal
                                  FROM emp_test 
                                  GROUP BY deptno) a
                WHERE a.deptno =e.deptno AND e.sal<a.sal);


--�������� Ǭ��            
UPDATE emp_test a SET sal = sal +200
WHERE sal < (SELECT AVG(SAL)
             FROM emp_test b
             WHERE a.deptno = b.deptno);
             

SELECT *
FROM emp_test;

--WITH��
--�ϳ��� �������� �ݺ��Ǵ� SUBQUERY�� ���� ��
--�ش� SUBQUERY�� ������ �����Ͽ� ����

--MAIN ������ ����ɶ� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
--> MAIN������ ����Ǹ� �޸� ����

--SUBQUERY �ۼ��ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O�� �ݺ������� �Ͼ����

--WITH���� ���� �����Ѵٸ� �ѹ��� SUBQUERY�� ����ǰ� �� ����� �޷θ��� ������ ���� ����

--��, �ϳ��� �������� SUBQUERY�� �ݺ������� �����°Ŵ� �߸� �ۼ� SQL�� Ȯ���� ����

--WITH ������� �̸� AS (
--           ��������
-- )

SELECT *
FROM �������� ����̸�;

--������ �μ��� �޿� ����� ��ȸ�ϴ� ������� WITH���� ���� ����

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

�޷¸����
CONNECT BY LEVEL <[=] ����
�ش����̺��� ���� ���� ��ŭ �����ϰ�, ������ ���� �����ϱ� ���ؼ� LEVEL�� �ο�
LEVEL�� 1���� ����

SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <=10; 

SELECT dept.*, LEVEL
FROM dept
CONNECT BY LEVEL <=5;

2020�� 2���� �޷��� ����
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